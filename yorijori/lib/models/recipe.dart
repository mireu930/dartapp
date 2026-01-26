import 'package:drift/drift.dart';
import 'dart:convert';
import 'step.dart';
import 'api_response.dart';

// [중요] 이 코드가 있어야 나중에 app_database.dart에서 모델 파일을 인식합니다.
// 파일명은 본인의 프로젝트 구조에 맞게 수정하세요.
//part 'recipe.g.dart'; // (선택사항: 만약 이 파일에서 바로 Dao를 쓴다면 필요하지만, 지금은 모델 정의만 하므로 주석 처리하거나 없어도 됩니다)

/// 레시피 테이블 (Drift Table)
/// 
/// [REQ-3.1] 로컬 데이터베이스 스키마
/// [중요] @DataClassName을 써서 자동 생성되는 클래스 이름을 'RecipeEntity'로 변경합니다.
@DataClassName('RecipeEntity') 
class Recipes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get youtubeId => text()();
  TextColumn get title => text()();
  TextColumn get channelName => text()();
  TextColumn get thumbnailUrl => text()();
  
  // JSON String으로 저장
  TextColumn get ingredients => text()();
  TextColumn get steps => text()();
  
  TextColumn get createdAt => text()();
}

/// 레시피 도메인 모델 (우리가 앱에서 쓸 클래스)
class Recipe {
  final int? id;
  final String youtubeId;
  final String title;
  final String channelName;
  final String thumbnailUrl;
  final List<String> ingredients;
  final List<Step> steps;
  final DateTime createdAt;

  Recipe({
    this.id,
    required this.youtubeId,
    required this.title,
    required this.channelName,
    required this.thumbnailUrl,
    required this.ingredients,
    required this.steps,
    required this.createdAt,
  });

  // --- [Helper Methods] ---

  /// DB 저장을 위한 재료 인코딩
  String encodeIngredients() => jsonEncode(ingredients);

  /// DB 저장을 위한 조리 단계 인코딩
  String encodeSteps() => jsonEncode(steps.map((s) => s.toJson()).toList());

  /// API 응답 -> 도메인 모델 변환
  factory Recipe.fromApiResponse(RecipeApiResponse apiResponse) {
    return Recipe(
      youtubeId: apiResponse.youtubeId,
      title: apiResponse.title,
      channelName: apiResponse.channelName,
      thumbnailUrl: apiResponse.thumbnailUrl,
      ingredients: apiResponse.ingredients,
      steps: apiResponse.steps,
      createdAt: DateTime.now(),
    );
  }

  /// DB Entity(RecipeEntity) -> 도메인 모델(Recipe) 변환
  /// app_database.dart에서 데이터를 불러올 때 사용합니다.
  // factory Recipe.fromEntity(RecipeEntity entity) {
  //   return Recipe(
  //     id: entity.id,
  //     youtubeId: entity.youtubeId,
  //     title: entity.title,
  //     channelName: entity.channelName,
  //     thumbnailUrl: entity.thumbnailUrl,
  //     ingredients: List<String>.from(jsonDecode(entity.ingredients)),
  //     steps: (jsonDecode(entity.steps) as List)
  //         .map((e) => Step.fromJson(e))
  //         .toList(),
  //     createdAt: DateTime.parse(entity.createdAt),
  //   );
  // }

  /// 도메인 모델 복사 (수정 시 사용)
  Recipe copyWith({
    int? id,
    String? youtubeId,
    String? title,
    String? channelName,
    String? thumbnailUrl,
    List<String>? ingredients,
    List<Step>? steps,
    DateTime? createdAt,
  }) {
    return Recipe(
      id: id ?? this.id,
      youtubeId: youtubeId ?? this.youtubeId,
      title: title ?? this.title,
      channelName: channelName ?? this.channelName,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}