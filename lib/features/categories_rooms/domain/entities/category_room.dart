class CategoryRoom {
  final int? id;
  final String libelleCat;

  /// 'gratuite' ou 'location'.
  final String type;
  final double montantLocation;
  final int actif;

  CategoryRoom({
    this.id,
    required this.libelleCat,
    required this.type,
    required this.montantLocation,
    required this.actif,
  });

  bool get isGratuite => type == 'gratuite';
}
