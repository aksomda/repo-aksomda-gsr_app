import '../../domain/entities/message_recipient.dart';

class MessageRecipientModel extends MessageRecipient {
  MessageRecipientModel({
    required super.login,
    required super.nom,
    required super.prenom,
  });

  factory MessageRecipientModel.fromJson(Map<String, dynamic> json) {
    return MessageRecipientModel(
      login: json['login']?.toString() ?? '',
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
    );
  }
}
