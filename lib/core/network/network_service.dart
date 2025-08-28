import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/app_constants.dart';
import '../errors/exceptions.dart';

/// Network service for API communication
class NetworkService {
  static NetworkService? _instance;
  static NetworkService get instance => _instance ??= NetworkService._();

  NetworkService._() {
    _dio = Dio();
    _setupDio();
  }

  late final Dio _dio;
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  /// Setup Dio configuration
  void _setupDio() {
    _dio.options = BaseOptions(
      baseUrl: AppConstants.supabaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'apikey': AppConstants.supabaseAnonKey,
      },
    );

    // Add interceptors
    _dio.interceptors.addAll([
      _AuthInterceptor(),
      _LoggingInterceptor(),
      _ErrorInterceptor(),
    ]);
  }

  /// Get Supabase client instance
  SupabaseClient get supabaseClient => _supabaseClient;

  /// Generic GET request
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data!;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Unexpected error occurred: ${e.toString()}');
    }
  }

  /// Generic POST request
  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data!;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Unexpected error occurred: ${e.toString()}');
    }
  }

  /// Generic PUT request
  Future<T> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data!;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Unexpected error occurred: ${e.toString()}');
    }
  }

  /// Generic PATCH request
  Future<T> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data!;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Unexpected error occurred: ${e.toString()}');
    }
  }

  /// Generic DELETE request
  Future<T> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data!;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Unexpected error occurred: ${e.toString()}');
    }
  }

  /// Upload file using FormData
  Future<T> uploadFile<T>(
    String path,
    File file, {
    String fieldName = 'file',
    Map<String, dynamic>? additionalFields,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
        ...?additionalFields,
      });

      final response = await _dio.post<T>(
        path,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      return response.data!;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('File upload failed: ${e.toString()}');
    }
  }

  /// Check internet connectivity
  Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Handle Dio exceptions and convert to app exceptions
  AppException _handleDioException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();

      case DioExceptionType.connectionError:
        return const NoInternetException();

      case DioExceptionType.badResponse:
        return _handleResponseError(dioException);

      case DioExceptionType.cancel:
        return const NetworkException('Request was cancelled');

      case DioExceptionType.unknown:
      default:
        if (dioException.error is SocketException) {
          return const NoInternetException();
        }
        return NetworkException('Network error: ${dioException.message}');
    }
  }

  /// Handle HTTP response errors
  AppException _handleResponseError(DioException dioException) {
    final statusCode = dioException.response?.statusCode;
    final data = dioException.response?.data;

    String message = 'Server error occurred';
    String? code;

    // Try to extract error message from response
    if (data is Map<String, dynamic>) {
      message = data['message'] ?? data['error'] ?? message;
      code = data['code']?.toString();
    }

    switch (statusCode) {
      case 400:
        return NetworkException('Bad request: $message', code);
      case 401:
        return const UnauthorizedException();
      case 403:
        return NetworkException('Access forbidden: $message', code);
      case 404:
        return NetworkException('Resource not found', code);
      case 422:
        return ValidationException(message, code);
      case 429:
        return const TooManyRequestsException();
      case 500:
      case 502:
      case 503:
      case 504:
        return const ServerException();
      default:
        return NetworkException('HTTP Error $statusCode: $message', code);
    }
  }
}

/// Interceptor for adding authentication headers
class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add auth header if user is authenticated
    final session = Supabase.instance.client.auth.currentSession;
    if (session?.accessToken != null) {
      options.headers['Authorization'] = 'Bearer ${session!.accessToken}';
    }
    
    handler.next(options);
  }
}

/// Interceptor for logging requests and responses
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('🌐 REQUEST[${options.method}] => PATH: ${options.path}');
    print('Headers: ${options.headers}');
    print('Query Parameters: ${options.queryParameters}');
    if (options.data != null) {
      print('Data: ${options.data}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    print('Data: ${response.data}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('❌ ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    print('Message: ${err.message}');
    print('Data: ${err.response?.data}');
    handler.next(err);
  }
}

/// Interceptor for handling common errors
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle token refresh if needed
    if (err.response?.statusCode == 401) {
      // Token might be expired, could trigger refresh flow here
    }
    
    handler.next(err);
  }
}

/// Network info helper
class NetworkInfo {
  static Future<bool> get isConnected async {
    return await NetworkService.instance.hasInternetConnection();
  }
}
