import 'dart:developer';

import 'package:bookcenter/service/storage_services/cache_service.dart';
import 'package:bookcenter/service/storage_services/local_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;

class ApiService extends getx.GetxService {
  // Dio With Interceptors
  final _dio = Dio();
  final _baseUrl = 'https://cbc.calvaryalbums.com/api';

  @override
  void onInit() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Content-Type'] = 'application/json';
          String token = getx.Get.find<LocalStoragaeService>()
                  .getUserValue(UserField.token) ??
              '';

          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Token $token';
          }
          // log('Request: ${options.method} ${options.path} ${options.headers}');

          if (options.method != 'GET') {
            // log(' - With -');
            // log('${options.data}');
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          // log('Response: ${response.statusCode} ${response.statusMessage}');
          // TODO : Don't forget to Comment this
          // Future.delayed(const Duration(seconds: 3), () {
          //   return handler.next(response);
          // });
          return handler.next(response);
        },
        onError: (error, handler) {
          // log('Error: ${error.message}');
          return handler.next(error);
        },
      ),
    );
    super.onInit();
  }

  Future<Response> get(
    String path, {
    bool? customBaseURL,
    bool? cache,
    Duration? cacheExpiry,
    CancelToken? cancelToken,
  }) async {
    _dio.options.baseUrl = customBaseURL ?? false ? path : _baseUrl;

    if (cache ?? false) {
      if (cacheExpiry == null) {
        // log('Cache Expiry is required');
        throw Exception('Cache Expiry is required');
      }

      Map<String, dynamic>? cachedData = CacheService.instance.getDataFromCache(
        apiPath: path,
      );

      if (cachedData != null) {
        return Response(
          data: cachedData,
          requestOptions: RequestOptions(path: path),
          statusCode: 200,
        );
      }

      var response = await _dio.get(
        customBaseURL ?? false ? '' : path,
      );

      if (response.statusCode == 200) {
        // TODO : Don't forget to remove this
        if (path == '/cart/address/') {
          response.data = {'result': response.data};
        }

        await CacheService.instance.addDataToCache(
          apiPath: path,
          data: response.data,
          expiry: cacheExpiry,
        );
      }

      return response;
    }

    return await _dio.get(
      customBaseURL ?? false ? '' : path,
      cancelToken: cancelToken,
    );
    // return _dio.get(path);
  }

  Future<Response> post(
    String path,
    dynamic data, {
    bool? customBaseURL,
  }) async {
    try {
      await removeIfDataInCache(path);
    } catch (e) {
      // log('Error: $e');
    }

    _dio.options.baseUrl = customBaseURL ?? false ? path : _baseUrl;
    return await _dio.post(
      customBaseURL ?? false ? '' : path,
      data: data,
    );
  }

  Future<Response> put(String path, dynamic data, {bool? customBaseURL}) async {
    await removeIfDataInCache(path);
    _dio.options.baseUrl = customBaseURL ?? false ? path : _baseUrl;
    return await _dio.put(
      customBaseURL ?? false ? '' : path,
      data: data,
    );
  }

  Future<Response> patch(
    String path,
    int id,
    dynamic data, {
    bool? customBaseURL,
  }) async {
    await removeIfDataInCache(path);
    _dio.options.baseUrl = customBaseURL ?? false ? path : _baseUrl;
    return await _dio.patch(
      customBaseURL ?? false ? '' : '$path$id/',
      data: data,
    );
  }

  Future<Response> delete(String path, int id, {bool? customBaseURL}) async {
    await removeIfDataInCache(path);
    _dio.options.baseUrl = customBaseURL ?? false ? path : _baseUrl;
    return await _dio.delete(
      customBaseURL ?? false ? '' : '$path$id/',
    );
  }

  Future removeIfDataInCache(String path) async {
    if (CacheService.instance.isDataInCache(apiPath: path)) {
      await CacheService.instance.deleteDataFromCache(apiPath: path);
    }
  }

  Future downloadFile(
    String url, {
    ProgressCallback? onReceiveProgress,
  }) async {
    _dio.options.baseUrl = '';

    var response = await _dio.get(
      url,
      options: Options(
        responseType: ResponseType.bytes,
      ),
      onReceiveProgress: onReceiveProgress,
    );
    return response;
  }
}
