import '../../../../core/network/api_client.dart';
import '../models/direction_regionale_model.dart';

class DirectionRegionaleRemoteDataSource {
  /// Lève une [ApiException] si le chargement échoue.
  Future<List<DirectionRegionaleModel>> getDirectionsRegionales() async {
    final data = await ApiClient.getList('/directions-regionales');
    return data.map((json) => DirectionRegionaleModel.fromJson(json)).toList();
  }
}
