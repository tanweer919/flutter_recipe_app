import 'package:dekorner_recipe/constants.dart';
import 'package:dekorner_recipe/services/local_storage_service.dart';
import 'package:dio/dio.dart';

class HttpService {
  final LocalStorageService localStorageService;
  HttpService({required this.localStorageService});
  Future<Dio> getAuthenticatedApiClient() async {
    final Map<String, dynamic> tokens =
        await localStorageService.getAuthToken();
    BaseOptions options = BaseOptions(baseUrl: '$baseUrl/');
    final dio0 = Dio(options);
    final dio = Dio(options);
    dio0.interceptors.clear();
    dio0.interceptors.add(QueuedInterceptorsWrapper(onRequest:
        (RequestOptions options, RequestInterceptorHandler handler) async {
      String? accessToken = tokens['accessToken'];
      if (accessToken != null) {
        options.headers['Authorization'] = "Bearer $accessToken";
      }
      return handler.next(options);
    }, onResponse:
        (Response<dynamic> response, ResponseInterceptorHandler handler) {
      return handler.next(response);
    }, onError: (DioException error, ErrorInterceptorHandler handler) async {
      if (error.response?.statusCode == 401) {
        RequestOptions options = error.requestOptions;
        String? refreshToken = tokens['refreshToken'];
        try {
          final tokenResponse = await dio.get('api/v1/auth/refresh/',
              options:
                  Options(headers: {'Authorization': 'Bearer $refreshToken'}));
          if (tokenResponse.statusCode == 200) {
            final String newAccessToken = tokenResponse.data['accessToken'];
            final String newRefreshToken = tokenResponse.data['refreshToken'];
            await localStorageService.setAuthToken(
                accessToken: newAccessToken, refreshToken: newRefreshToken);
            String url = options.path.startsWith(options.baseUrl)
                ? options.path
                : '${options.baseUrl}${options.path}';
            final opts = Options(method: options.method);
            opts.headers = {
              ...?opts.headers,
              'Authorization': "Bearer $newAccessToken"
            };
            try {
              final response = await dio.request(url,
                  data: options.data,
                  queryParameters: options.queryParameters,
                  options: opts);
              return handler.resolve(response);
            } on DioException catch (e) {
              return handler.next(e);
            }
          } else {
            return handler.next(error);
          }
        } on DioException catch (e) {
          return handler.next(e);
        }
      } else {
        return handler.next(error);
      }
    }));
    return dio0;
  }

  Future<Dio> getApiClient() async {
    BaseOptions options = BaseOptions(baseUrl: '$baseUrl/');
    final dio = Dio(options);
    return dio;
  }
}
