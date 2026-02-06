import 'package:dio/dio.dart';

class AuthRemoteDS {
  final Dio dio;

  AuthRemoteDS(this.dio);

  Future<Response> login(String email, String password) {
    return dio.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
  }
}
