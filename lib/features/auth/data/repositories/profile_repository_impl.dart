import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<bool> uploadPhoto({
    required List<int> bytes,
    required String filename,
    required String contentType,
  }) {
    return remoteDataSource.uploadPhoto(
      bytes: bytes,
      filename: filename,
      contentType: contentType,
    );
  }

  @override
  Future<bool> deletePhoto() => remoteDataSource.deletePhoto();
}
