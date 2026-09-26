/// Agent auquel un administrateur peut écrire.
class MessageRecipient {
  final String login;
  final String nom;
  final String prenom;

  MessageRecipient({
    required this.login,
    required this.nom,
    required this.prenom,
  });

  String get nomComplet => '$prenom $nom';
}
