/// Direction régionale des impôts : ligne de `ref_structure` (lecture seule).
/// [id] est le CODE_CDI (ex. "DGI-4"), [nom] le LIBELLE_LONG_CDI.
class DirectionRegionale {
  final String? id;
  final String nom;

  DirectionRegionale({this.id, required this.nom});
}
