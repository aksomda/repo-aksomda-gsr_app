// Teste config/firebase.js en simulant la présence/absence du fichier de
// compte de service et le SDK firebase-admin, sans jamais appeler la vraie
// API Google (aucun réseau, aucun projet réel requis).
jest.mock('fs');
jest.mock('firebase-admin', () => ({
  apps: [],
  credential: { cert: jest.fn(() => 'cert') },
  initializeApp: jest.fn(() => 'app'),
  app: jest.fn(),
  auth: jest.fn(),
  messaging: jest.fn(),
  storage: jest.fn(),
}));

const fs = require('fs');
const admin = require('firebase-admin');
const firebase = require('../config/firebase');

beforeEach(() => {
  jest.clearAllMocks();
  admin.apps = [];
  // Repart d'un état "non initialisé" à chaque test (voir _resetForTests) :
  // sans ça, le module garderait la connexion établie par le test précédent.
  firebase._resetForTests();
});

describe('config/firebase (non configuré)', () => {
  beforeEach(() => {
    fs.existsSync.mockReturnValue(false);
  });

  it('isEnabled() est false sans fichier de compte de service', () => {
    expect(firebase.isEnabled()).toBe(false);
  });

  it('createCustomToken renvoie null sans planter', async () => {
    expect(await firebase.createCustomToken('217071K', {})).toBeNull();
  });

  it('sendPush ne fait rien et ne plante pas', async () => {
    const result = await firebase.sendPush(['tok1'], { title: 't', body: 'b' });
    expect(result).toEqual({ sent: 0, invalidTokens: [] });
  });

  it('uploadPhoto et deletePhoto sont des no-op', async () => {
    expect(await firebase.uploadPhoto('217071K', Buffer.from('x'), 'image/png')).toBeNull();
    await expect(firebase.deletePhoto('217071K')).resolves.toBeUndefined();
  });
});

describe('config/firebase (configuré)', () => {
  beforeEach(() => {
    fs.existsSync.mockReturnValue(true);
    fs.readFileSync.mockReturnValue(JSON.stringify({ project_id: 'gsr-app' }));
  });

  it('isEnabled() est true quand le fichier existe et est valide', () => {
    expect(firebase.isEnabled()).toBe(true);
  });

  it("createCustomToken crée l'utilisateur Firebase au besoin puis renvoie un jeton", async () => {
    const getUser = jest.fn().mockRejectedValue({ code: 'auth/user-not-found' });
    const createUser = jest.fn().mockResolvedValue();
    const setCustomUserClaims = jest.fn().mockResolvedValue();
    const createCustomToken = jest.fn().mockResolvedValue('jeton-abc');
    admin.auth.mockReturnValue({ getUser, createUser, setCustomUserClaims, createCustomToken });

    const token = await firebase.createCustomToken('217071K', { role: 'agent' });

    expect(createUser).toHaveBeenCalledWith({ uid: '217071K' });
    expect(setCustomUserClaims).toHaveBeenCalledWith('217071K', { role: 'agent' });
    expect(token).toBe('jeton-abc');
  });

  it("createCustomToken ne recrée pas l'utilisateur s'il existe déjà", async () => {
    const getUser = jest.fn().mockResolvedValue({ uid: '217071K' });
    const createUser = jest.fn();
    const setCustomUserClaims = jest.fn().mockResolvedValue();
    const createCustomToken = jest.fn().mockResolvedValue('jeton-abc');
    admin.auth.mockReturnValue({ getUser, createUser, setCustomUserClaims, createCustomToken });

    await firebase.createCustomToken('217071K', {});

    expect(createUser).not.toHaveBeenCalled();
  });

  it('createCustomToken renvoie null si Firebase Auth échoue (best effort)', async () => {
    admin.auth.mockReturnValue({ getUser: jest.fn().mockRejectedValue(new Error('boom')) });

    expect(await firebase.createCustomToken('217071K', {})).toBeNull();
  });

  it('sendPush renvoie le nombre envoyé et les jetons invalides à purger', async () => {
    const sendEachForMulticast = jest.fn().mockResolvedValue({
      successCount: 1,
      responses: [
        { success: true },
        { success: false, error: { code: 'messaging/registration-token-not-registered' } },
      ],
    });
    admin.messaging.mockReturnValue({ sendEachForMulticast });

    const result = await firebase.sendPush(['tok-ok', 'tok-mort'], { title: 'Titre', body: 'Corps' });

    expect(result).toEqual({ sent: 1, invalidTokens: ['tok-mort'] });
  });

  it('uploadPhoto téléverse le fichier et renvoie une URL publique', async () => {
    const save = jest.fn().mockResolvedValue();
    const makePublic = jest.fn().mockResolvedValue();
    const file = jest.fn(() => ({ save, makePublic }));
    admin.storage.mockReturnValue({ bucket: () => ({ file, name: 'gsr-app.appspot.com' }) });

    const url = await firebase.uploadPhoto('217071K', Buffer.from('img'), 'image/png');

    expect(file).toHaveBeenCalledWith('profile-photos/217071K');
    expect(save).toHaveBeenCalled();
    expect(url).toContain('217071K');
  });

  it('uploadPhoto renvoie null si Storage échoue (MySQL reste la source de vérité)', async () => {
    admin.storage.mockReturnValue({
      bucket: () => ({ file: () => ({ save: jest.fn().mockRejectedValue(new Error('quota')) }) }),
    });

    expect(await firebase.uploadPhoto('217071K', Buffer.from('img'), 'image/png')).toBeNull();
  });
});
