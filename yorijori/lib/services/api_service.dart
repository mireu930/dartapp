import 'package:dio/dio.dart';
import '../models/api_response.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';

/// API 통신 예외 클래스
class ApiException implements Exception {
  final String message;
  final String? errorCode;
  final int? statusCode;

  ApiException({
    required this.message,
    this.errorCode,
    this.statusCode,
  });

  @override
  String toString() => message;
}

/// API 서비스 클래스
/// 
/// [REQ-1.2] FastAPI 서버와 통신하여 레시피 분석 요청
class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.apiBaseUrl,
        connectTimeout: AppConstants.apiTimeout,
        receiveTimeout: AppConstants.apiTimeout,
        sendTimeout: AppConstants.apiTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // 에러 인터셉터 추가
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          // 에러 응답 파싱
          if (error.response != null) {
            final statusCode = error.response!.statusCode;
            final data = error.response!.data;

            // 에러 응답이 JSON 형식인 경우
            if (data is Map<String, dynamic>) {
              try {
                final errorResponse = ApiErrorResponse.fromJson(data);
                final apiException = ApiException(
                  message: errorResponse.message,
                  errorCode: errorResponse.errorCode,
                  statusCode: statusCode,
                );
                return handler.reject(
                  DioException(
                    requestOptions: error.requestOptions,
                    response: error.response,
                    error: apiException,
                  ),
                );
              } catch (e) {
                // JSON 파싱 실패 시 기본 에러 메시지 사용
              }
            }
          }

          // 네트워크 에러 처리
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.sendTimeout) {
            return handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                error: ApiException(
                  message: AppConstants.errorNetwork,
                  statusCode: error.response?.statusCode,
                ),
              ),
            );
          }

          return handler.next(error);
        },
      ),
    );
  }

  /// YouTube URL로 레시피 분석 요청
  /// 
  /// [REQ-1.1] URL 유효성 검증 후 서버에 요청
  /// [REQ-1.2] 서버로부터 구조화된 JSON 데이터 수신
  /// [REQ-1.3] 예외 처리 (NO_TRANSCRIPT, NOT_COOKING 등)
  /// 
  /// Parameters:
  /// - [youtubeUrl]: 분석할 YouTube 영상 URL
  /// 
  /// Returns:
  /// - [RecipeApiResponse]: 분석된 레시피 데이터
  /// 
  /// Throws:
  /// - [ApiException]: API 통신 실패 또는 에러 응답
  Future<RecipeApiResponse> analyzeRecipe(String youtubeUrl) async {
    // URL 유효성 검증
    if (!Validators.isValidYouTubeUrl(youtubeUrl)) {
      throw ApiException(
        message: AppConstants.errorInvalidUrl,
        errorCode: 'INVALID_URL',
      );
    }

    try {
      // API 요청
      final response = await _dio.post(
        AppConstants.analyzeEndpoint,
        data: {
          'url': youtubeUrl,
        },
      );

      // 성공 응답 파싱
      if (response.statusCode == 200 && response.data != null) {
        try {
          return RecipeApiResponse.fromJson(response.data);
        } catch (e) {
          throw ApiException(
            message: '응답 데이터를 파싱할 수 없습니다.',
            errorCode: 'PARSE_ERROR',
            statusCode: response.statusCode,
          );
        }
      } else {
        throw ApiException(
          message: AppConstants.errorUnknown,
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      // DioException에서 ApiException 추출
      if (e.error is ApiException) {
        final apiException = e.error as ApiException;
        
        // 에러 코드에 따른 메시지 매핑
        String errorMessage = apiException.message;
        if (apiException.errorCode == 'NO_TRANSCRIPT') {
          errorMessage = AppConstants.errorNoTranscript;
        } else if (apiException.errorCode == 'NOT_COOKING') {
          errorMessage = AppConstants.errorNotCooking;
        }

        throw ApiException(
          message: errorMessage,
          errorCode: apiException.errorCode,
          statusCode: apiException.statusCode,
        );
      }

      // 일반 DioException 처리
      throw ApiException(
        message: e.message ?? AppConstants.errorUnknown,
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      // 기타 예외 처리
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(
        message: e.toString(),
      );
    }
  }

  /// Base URL 변경 (개발/프로덕션 전환용)
  void setBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }
}
