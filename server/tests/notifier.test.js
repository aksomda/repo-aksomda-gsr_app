jest.mock('../config/db');
jest.mock('../config/firebase', () => ({ sendPush: jest.fn() }));

const pool = require('../config/db');
const { sendPush } = require('../config/firebase');
const { createNotification } = require('../services/notifier');

// createNotification est le point de passage unique utilisé par
// messageController (nouveau message) et reservationController (réservation
// validée/rejetée) : le tester ici couvre le push pour ces trois événements
// sans dupliquer les scénarios dans chaque contrôleur.
describe('createNotification', () => {
  it('écrit toujours la notification en base, même si aucun appareil n\'est enregistré', async () => {
    pool.query.mockResolvedValueOnce([{ insertId: 1 }]); // INSERT notifications
    pool.query.mockResolvedValueOnce([[]]); // SELECT fcm_tokens : aucun

    await createNotification(pool, {
      login: '217071K',
      title: 'Réservation validée',
      body: 'Votre demande a été validée.',
      type: 'reservation_validee',
      referenceId: 5,
    });

    expect(pool.query.mock.calls[0][0]).toMatch(/INSERT INTO notifications/);
    expect(sendPush).not.toHaveBeenCalled();
  });

  it('envoie un push à tous les appareils connus de l\'utilisateur', async () => {
    pool.query.mockResolvedValueOnce([{ insertId: 2 }]);
    pool.query.mockResolvedValueOnce([[{ token: 'tok-1' }, { token: 'tok-2' }]]);
    sendPush.mockResolvedValueOnce({ sent: 2, invalidTokens: [] });

    await createNotification(pool, {
      login: '217071K',
      title: 'Nouveau message',
      body: 'Vous avez un nouveau message.',
      type: 'nouveau_message',
      referenceId: 9,
    });

    expect(sendPush).toHaveBeenCalledWith(
      ['tok-1', 'tok-2'],
      expect.objectContaining({ title: 'Nouveau message', body: 'Vous avez un nouveau message.' })
    );
  });

  it('purge les jetons que Firebase signale comme invalides', async () => {
    pool.query.mockResolvedValueOnce([{ insertId: 3 }]);
    pool.query.mockResolvedValueOnce([[{ token: 'tok-vivant' }, { token: 'tok-mort' }]]);
    sendPush.mockResolvedValueOnce({ sent: 1, invalidTokens: ['tok-mort'] });
    pool.query.mockResolvedValueOnce([{ affectedRows: 1 }]); // DELETE fcm_tokens

    await createNotification(pool, { login: '217071K', title: 't', body: 'b', type: 'x' });

    const deleteCall = pool.query.mock.calls.find(([sql]) => sql.includes('DELETE FROM fcm_tokens'));
    expect(deleteCall[1]).toEqual([['tok-mort']]);
  });

  it("un échec de sendPush ne fait jamais échouer createNotification (la notification in-app est déjà écrite)", async () => {
    pool.query.mockResolvedValueOnce([{ insertId: 4 }]);
    pool.query.mockResolvedValueOnce([[{ token: 'tok-1' }]]);
    sendPush.mockRejectedValueOnce(new Error('Firebase indisponible'));

    await expect(
      createNotification(pool, { login: '217071K', title: 't', body: 'b', type: 'x' })
    ).resolves.toBeUndefined();
  });
});
