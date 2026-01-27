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
  static final AppDatabase _instance = AppDatabase._internal();

  factory AppDatabase() => _instance;

  AppDatabase._internal() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // ------------------------------------------------------------------
  // [Helper] RecipeEntity(DB용) -> Recipe(앱용) 변환 함수 (새로 추가됨)
  // ------------------------------------------------------------------
  Recipe _convertEntityToRecipe(RecipeEntity entity) {
    try {
      // JSON String -> List 변환
      final ingredientsJson = entity.ingredients;
      final stepsJson = entity.steps;
      
      print('   [변환] 재료 JSON: ${ingredientsJson.substring(0, ingredientsJson.length > 50 ? 50 : ingredientsJson.length)}...');
      print('   [변환] 단계 JSON: ${stepsJson.substring(0, stepsJson.length > 100 ? 100 : stepsJson.length)}...');
      
      final ingredients = List<String>.from(jsonDecode(ingredientsJson));
      final stepsList = jsonDecode(stepsJson) as List;
      final steps = stepsList.map((item) {
        if (item is Map<String, dynamic>) {
          return Step.fromJson(item);
        } else {
          print('   ⚠️ [변환] 잘못된 step 형식: $item');
          throw FormatException('Step 형식이 올바르지 않습니다: $item');
        }
      }).toList();
      
      return Recipe(
        id: entity.id,
        youtubeId: entity.youtubeId,
        title: entity.title,
        channelName: entity.channelName,
        thumbnailUrl: entity.thumbnailUrl,
        ingredients: ingredients,
        steps: steps,
        createdAt: DateTime.parse(entity.createdAt),
      );
    } catch (e, stackTrace) {
      print('   ❌ [변환] Recipe 변환 실패: $e');
      print('   📋 스택: $stackTrace');
      print('   📦 엔티티 데이터: id=${entity.id}, title=${entity.title}');
      rethrow;
    }
  }

  /// [READ] 모든 레시피 조회 (최신순)
  Future<List<Recipe>> getAllRecipes() async {
    print('📖 [DB] 레시피 목록 조회 시작...');
    final entities = await (select(recipes)
      ..orderBy([
        (t) => OrderingTerm.desc(t.createdAt),
      ])).get();

    print('   - DB에서 ${entities.length}개의 엔티티 조회됨');
    
    // fromEntity 대신 위에서 만든 헬퍼 함수 사용
    final recipeList = <Recipe>[];
    for (final entity in entities) {
      try {
        final recipe = _convertEntityToRecipe(entity);
        print('   - 변환 성공: ${recipe.title} (ID: ${recipe.id})');
        recipeList.add(recipe);
      } catch (e, stackTrace) {
        print('   ❌ 변환 실패 (ID: ${entity.id}): $e');
        print('   📋 스택: $stackTrace');
        rethrow;
      }
    }
    
    print('✅ [DB] 총 ${recipeList.length}개의 레시피 반환');
    return recipeList;
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
    print('💾 [DB] 레시피 저장 시작: ${recipe.title}');
    print('   - 재료 수: ${recipe.ingredients.length}');
    print('   - 단계 수: ${recipe.steps.length}');
    
    final ingredientsJson = recipe.encodeIngredients();
    final stepsJson = recipe.encodeSteps();
    print('   - 재료 JSON: $ingredientsJson');
    print('   - 단계 JSON: ${stepsJson.substring(0, stepsJson.length > 100 ? 100 : stepsJson.length)}...');
    
    final companion = RecipesCompanion.insert(
      youtubeId: recipe.youtubeId,
      title: recipe.title,
      channelName: recipe.channelName,
      thumbnailUrl: recipe.thumbnailUrl,
      ingredients: ingredientsJson, 
      steps: stepsJson,
      createdAt: recipe.createdAt.toIso8601String(),
    );

    final id = await into(recipes).insert(companion);
    print('✅ [DB] 저장 완료! ID: $id');
    return id;
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