class ReservationRoom {
  final int? id;
  final String meetingSubject;
  final String organizingStructure;
  final String date;
  final String startTime;
  final String endTime;

  /// État métier de la demande : 'en cours', 'traitée' ou 'rejetée'.
  final String state;

  /// Statut d'affichage (ex: nom lisible du statut de la salle réservée).
  final String status;

  ReservationRoom({
    this.id,
    required this.meetingSubject,
    required this.organizingStructure,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.state,
    required this.status,
  });
}
