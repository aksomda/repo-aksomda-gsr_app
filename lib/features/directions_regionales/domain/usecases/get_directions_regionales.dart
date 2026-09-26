import '../entities/direction_regionale.dart';
import '../repositories/direction_regionale_repository.dart';

class GetDirectionsRegionales {
  final DirectionRegionaleRepository repository;

  GetDirectionsRegionales(this.repository);

  Future<List<DirectionRegionale>> call() =>
      repository.getDirectionsRegionales();
}
