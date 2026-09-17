import '../../domain/entities/reservation_room.dart';

class ReservationRoomModel extends ReservationRoom {
  ReservationRoomModel({
    super.id,
    required super.meetingSubject,
    required super.organizingStructure,
    required super.date,
    required super.startTime,
    required super.endTime,
    required super.state,
    required super.status,
  });

  factory ReservationRoomModel.fromJson(Map<String, dynamic> json) {
    return ReservationRoomModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      meetingSubject: json['meeting_subject'] ?? '',
      organizingStructure: json['organizing_structure'] ?? '',
      date: json['date'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      state: json['state'] ?? 'en cours',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'meeting_subject': meetingSubject,
      'organizing_structure': organizingStructure,
      'date': date,
      'start_time': startTime,
      'end_time': endTime,
      'state': state,
      'status': status,
    };
  }

  factory ReservationRoomModel.fromEntity(ReservationRoom reservation) {
    return ReservationRoomModel(
      id: reservation.id,
      meetingSubject: reservation.meetingSubject,
      organizingStructure: reservation.organizingStructure,
      date: reservation.date,
      startTime: reservation.startTime,
      endTime: reservation.endTime,
      state: reservation.state,
      status: reservation.status,
    );
  }
}
