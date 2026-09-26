import '../../../../core/network/api_client.dart';

class ProfileRemoteDataSource {
  Future<bool> uploadPhoto({
    required List<int> bytes,
    required String filename,
    required String contentType,
  }) async {
    try {
      await ApiClient.postMultipart(
        '/profile/photo',
        fieldName: 'photo',
        bytes: bytes,
        filename: filename,
        contentType: contentType,
      );
      return true;
    } on ApiException {
      return false;
    }
  }

  Future<bool> deletePhoto() async {
    try {
      await ApiClient.delete('/profile/photo');
      return true;
    } on ApiException {
      return false;
    }
  }
}
