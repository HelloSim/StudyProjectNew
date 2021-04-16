import 'package:dio/dio.dart';

class DioUtil {
  static final DioUtil _instance = DioUtil._internal();

  factory DioUtil() => _instance;

  DioUtil._internal();

  Dio _dio;

  /// 请求(默认get)
  Future requset(String baseUrl, String module,
      {String method = "get", Map<String, dynamic> params}) async {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: 15000,
    ));
    Options options = Options(method: method);
    try {
      final result =
          await _dio.request(module, queryParameters: params, options: options);
      return result;
    } on DioError catch (error) {
      throw error;
    }
  }
}
