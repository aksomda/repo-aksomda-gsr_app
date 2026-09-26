/// Vue "boîte de réception" côté admin : un agent, avec son dernier message.
class MessageThread {
  final String login;
  final String nom;
  final String prenom;
  final DateTime? lastMessageAt;
  final int unreadCount;

  MessageThread({
    required this.login,
    required this.nom,
    required this.prenom,
    this.lastMessageAt,
    required this.unreadCount,
  });

  String get nomComplet => '$prenom $nom';
}
