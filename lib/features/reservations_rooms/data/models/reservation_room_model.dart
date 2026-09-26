import '../../domain/entities/reservation_room.dart';

class ReservationRoomModel extends ReservationRoom {
  ReservationRoomModel({
    super.id,
    required super.roomId,
    super.roomName,
    super.requesterName,
    required super.meetingSubject,
    required super.organizingStructure,
    required super.date,
    required super.startTime,
    required super.endTime,
    required super.status,
    super.rejectionReason,
  });

  factory ReservationRoomModel.fromJson(Map<String, dynamic> json) {
    final nom = json['nom'];
    final prenom = json['prenom'];

    return ReservationRoomModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      roomId: json['room_id'] is int
          ? json['room_id']
          : int.tryParse(json['room_id'].toString()) ?? 0,
      roomName: json['room_name'],
      requesterName: (nom != null && prenom != null) ? '$prenom $nom' : null,
      meetingSubject: json['meeting_subject'] ?? '',
      organizingStructure: json['organizing_structure'] ?? '',
      date: json['date'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      status: json['status'] ?? 'en_attente',
      rejectionReason: json['rejection_reason'],
    );
  }
}
