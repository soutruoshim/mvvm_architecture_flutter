import 'package:dartz/dartz.dart';
import '../../data/network/failure.dart';
import '../../data/request/request.dart';
import '../../presentation/domain/model.dart';
import '../model/model.dart';
abstract class Repository{
  Future<Either<Failure,Authentication>> login(LoginRequest loginRequest);
  Future<Either<Failure, String>> forgotPassword(String email);
  Future<Either<Failure,Authentication>> register(RegisterRequest registerRequest);
  Future<Either<Failure,HomeObject>> getHome();
  Future<Either<Failure, StoreDetails>> getStoreDetails();

}