import 'dart:io';
import 'dart:convert'; // 👈 jsonDecode를 위해 필수!
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../models/recipe.dart'; 
import '../models/step.dart'; // 👈 Step 클래스 인식을 위해 import 필요

part 'app_database.g.dart';

@DriftDatabase(tables: [Recipes])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // ------------------------------------------------------------------
  // [Helper] RecipeEntity(DB용) -> Recipe(앱용) 변환 함수 (새로 추가됨)
  // ------------------------------------------------------------------
  Recipe _convertEntityToRecipe(RecipeEntity entity) {
    return Recipe(
      id: entity.id,
      youtubeId: entity.youtubeId,
      title: entity.title,
      channelName: entity.channelName,
      thumbnailUrl: entity.thumbnailUrl,
      // JSON String -> List 변환
      ingredients: List<String>.from(jsonDecode(entity.ingredients)),
      steps: (jsonDecode(entity.steps) as List)
          .map((item) => Step.fromJson(item))
          .toList(),
      createdAt: DateTime.parse(entity.createdAt),
    );
  }

  /// [READ] 모든 레시피 조회 (최신순)
  Future<List<Recipe>> getAllRecipes() async {
    final entities = await (select(recipes)
      ..orderBy([
        (t) => OrderingTerm.desc(t.createdAt),
      ])).get();

    // fromEntity 대신 위에서 만든 헬퍼 함수 사용
    return entities.map((e) => _convertEntityToRecipe(e)).toList();
  }

  /// [READ] 특정 레시피 조회 (ID로)
  Future<Recipe?> getRecipeById(int id) async {
    final entity = await (select(recipes)..where((r) => r.id.equals(id))).getSingleOrNull();
    
    if (entity == null) return null;
    
    // fromEntity 대신 위에서 만든 헬퍼 함수 사용
    return _convertEntityToRecipe(entity);
  }

  /// [CREATE] 레시피 추가
  Future<int> insertRecipe(Recipe recipe) async {
    final companion = RecipesCompanion.insert(
      youtubeId: recipe.youtubeId,
      title: recipe.title,
      channelName: recipe.channelName,
      thumbnailUrl: recipe.thumbnailUrl,
      ingredients: recipe.encodeIngredients(), 
      steps: recipe.encodeSteps(),
      createdAt: recipe.createdAt.toIso8601String(),
    );

    return await into(recipes).insert(companion);
  }

  /// [DELETE] 레시피 삭제
  Future<int> deleteRecipe(int id) async {
    return await (delete(recipes)..where((r) => r.id.equals(id))).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.sqlite'));
    return NativeDatabase(file);
  });
}