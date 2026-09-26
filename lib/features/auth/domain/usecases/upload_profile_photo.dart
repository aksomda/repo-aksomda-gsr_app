import '../repositories/profile_repository.dart';

class UploadProfilePhoto {
  final ProfileRepository repository;

  UploadProfilePhoto(this.repository);

  Future<bool> call({
    required List<int> bytes,
    required String filename,
    required String contentType,
  }) {
    return repository.uploadPhoto(
      bytes: bytes,
      filename: filename,
      contentType: contentType,
    );
  }
}
