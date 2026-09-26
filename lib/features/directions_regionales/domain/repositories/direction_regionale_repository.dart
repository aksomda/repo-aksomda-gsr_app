import '../entities/direction_regionale.dart';

abstract class DirectionRegionaleRepository {
  Future<List<DirectionRegionale>> getDirectionsRegionales();
}
