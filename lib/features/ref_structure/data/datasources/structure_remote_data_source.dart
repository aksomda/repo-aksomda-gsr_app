import '../../../../core/network/api_client.dart';
import '../models/structure_model.dart';

class StructureRemoteDataSource {
  /// Route publique : consultée depuis le formulaire d'inscription, avant
  /// authentification. Lève une [ApiException] si le chargement échoue.
  Future<List<StructureModel>> getStructures() async {
    final data = await ApiClient.getList('/structures', auth: false);
    return data.map((json) => StructureModel.fromJson(json)).toList();
  }

  Future<bool> saveStructure(StructureModel model) async {
    try {
      await ApiClient.post('/structures/save', body: model.toJson());
      return true;
    } on ApiException {
      return false;
    }
  }

  Future<bool> deleteStructure(String codeCdi) async {
    try {
      await ApiClient.post('/structures/delete', body: {'code_cdi': codeCdi});
      return true;
    } on ApiException {
      return false;
    }
  }
}
