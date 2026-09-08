import '../repositories/auth_repository.dart';

class DeleteAccount {
  const DeleteAccount(this._repository);

  final AuthRepository _repository;

  Future<void> call(String password) =>
      _repository.deleteAccount(password: password);
}