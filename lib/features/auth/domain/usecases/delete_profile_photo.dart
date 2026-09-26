import '../repositories/profile_repository.dart';

class DeleteProfilePhoto {
  final ProfileRepository repository;

  DeleteProfilePhoto(this.repository);

  Future<bool> call() => repository.deletePhoto();
}
