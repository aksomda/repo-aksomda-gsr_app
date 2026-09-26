/// Une page de résultats d'une liste paginée côté serveur.
class Paged<T> {
  final List<T> items;

  /// Le serveur a d'autres résultats après cette page.
  final bool hasMore;

  const Paged(this.items, {this.hasMore = false});

  Paged<R> map<R>(R Function(T) convert) =>
      Paged(items.map(convert).toList(), hasMore: hasMore);
}
