import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../storage/token_storage.dart';

// import 'package:dio/dio.dart';
import '../storage/token_storage.dart';
import '../navigation/app_navigator.dart';

class DioClient {
  static final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              final token = await TokenStorage.getToken();
              if (token != null) {
                options.headers['Authorization'] = 'Bearer $token';
              }
              return handler.next(options);
            },

            onError: (DioException e, handler) async {
              if (e.response?.statusCode == 401) {
                await TokenStorage.clearToken();

                AppNavigator.logout(); // force logout
              }

              return handler.next(e);
            },
          ),
        );
}
