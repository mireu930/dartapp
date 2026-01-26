import 'package:json_annotation/json_annotation.dart';
import 'step.dart';

part 'api_response.g.dart';

/// API 응답 모델
/// 
/// [REQ-1.2] 서버로부터 받는 분석 결과 구조
@JsonSerializable()
class RecipeApiResponse {
  /// YouTube 영상 ID
  final String youtubeId;
  
  /// 요리 제목
  final String title;
  
  /// 채널 이름
  final String channelName;
  
  /// 썸네일 URL
  final String thumbnailUrl;
  
  /// 재료 목록 (수량 포함)
  final List<String> ingredients;
  
  /// 조리 단계 리스트
  final List<Step> steps;

  RecipeApiResponse({
    required this.youtubeId,
    required this.title,
    required this.channelName,
    required this.thumbnailUrl,
    required this.ingredients,
    required this.steps,
  });

  /// JSON에서 RecipeApiResponse 객체 생성
  factory RecipeApiResponse.fromJson(Map<String, dynamic> json) =>
      _$RecipeApiResponseFromJson(json);

  /// RecipeApiResponse 객체를 JSON으로 변환
  Map<String, dynamic> toJson() => _$RecipeApiResponseToJson(this);

  @override
  String toString() =>
      'RecipeApiResponse(youtubeId: $youtubeId, title: $title, steps: ${steps.length})';
}

/// API 에러 응답 모델
@JsonSerializable()
class ApiErrorResponse {
  /// 에러 코드
  final String errorCode;
  
  /// 에러 메시지
  final String message;
  
  /// 상세 정보 (선택적)
  final String? details;

  ApiErrorResponse({
    required this.errorCode,
    required this.message,
    this.details,
  });

  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApiErrorResponseToJson(this);
}
