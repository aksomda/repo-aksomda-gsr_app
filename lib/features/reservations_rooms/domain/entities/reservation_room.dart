class ReservationRoom {
  final int? id;
  final int roomId;
  final String? roomName;
  final String? requesterName;
  final String meetingSubject;
  final String organizingStructure;
  final String date;
  final String startTime;
  final String endTime;

  /// 'en_attente', 'validee' ou 'rejetee'.
  final String status;
  final String? rejectionReason;

  ReservationRoom({
    this.id,
    required this.roomId,
    this.roomName,
    this.requesterName,
    required this.meetingSubject,
    required this.organizingStructure,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.rejectionReason,
  });

  /// Heures au format HH:mm (le serveur renvoie HH:mm:ss).
  String get startTimeShort =>
      startTime.length >= 5 ? startTime.substring(0, 5) : startTime;
  String get endTimeShort =>
      endTime.length >= 5 ? endTime.substring(0, 5) : endTime;
}
