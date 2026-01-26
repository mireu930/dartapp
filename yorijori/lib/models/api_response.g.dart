// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipeApiResponse _$RecipeApiResponseFromJson(Map<String, dynamic> json) =>
    RecipeApiResponse(
      youtubeId: json['youtubeId'] as String,
      title: json['title'] as String,
      channelName: json['channelName'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      steps: (json['steps'] as List<dynamic>)
          .map((e) => Step.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RecipeApiResponseToJson(RecipeApiResponse instance) =>
    <String, dynamic>{
      'youtubeId': instance.youtubeId,
      'title': instance.title,
      'channelName': instance.channelName,
      'thumbnailUrl': instance.thumbnailUrl,
      'ingredients': instance.ingredients,
      'steps': instance.steps,
    };

ApiErrorResponse _$ApiErrorResponseFromJson(Map<String, dynamic> json) =>
    ApiErrorResponse(
      errorCode: json['errorCode'] as String,
      message: json['message'] as String,
      details: json['details'] as String?,
    );

Map<String, dynamic> _$ApiErrorResponseToJson(ApiErrorResponse instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'message': instance.message,
      'details': instance.details,
    };
