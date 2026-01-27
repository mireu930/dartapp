import '../database/app_database.dart';
import '../models/recipe.dart';
import '../models/api_response.dart';
import '../services/api_service.dart';
import '../utils/validators.dart';

/// 레시피 서비스 클래스
class RecipeService {
  final ApiService _apiService;
  final AppDatabase _database;

  RecipeService({
    ApiService? apiService,
    AppDatabase? database,
  })  : _apiService = apiService ?? ApiService(),
        _database = database ?? AppDatabase();

  /// YouTube URL로 레시피 분석 및 저장
  Future<Recipe> analyzeAndSaveRecipe(String youtubeUrl) async {
    // 1. URL 유효성 검증
    if (!Validators.isValidYouTubeUrl(youtubeUrl)) {
      throw ApiException(
        message: '올바른 유튜브 링크를 입력해주세요.',
        errorCode: 'INVALID_URL',
      );
    }

    // 2. API 서버에 분석 요청
    print('🔍 API 분석 요청 중...');
    final apiResponse = await _apiService.analyzeRecipe(youtubeUrl);
    print('✅ API 응답 수신: ${apiResponse.title}, 재료: ${apiResponse.ingredients.length}개, 단계: ${apiResponse.steps.length}개');

    // 3. API 응답을 Recipe 객체로 변환
    final recipe = Recipe.fromApiResponse(apiResponse);
    print('📦 Recipe 객체 생성 완료: ${recipe.title}');

    // 4. 데이터베이스에 저장
    print('💾 데이터베이스에 저장 중...');
    final recipeId = await _database.insertRecipe(recipe);
    print('✅ 저장 완료! ID: $recipeId');

    // 5. 저장된 레시피 반환 (ID 포함)
    final savedRecipe = recipe.copyWith(id: recipeId);
    print('📤 반환할 레시피: ${savedRecipe.title} (ID: ${savedRecipe.id})');
    return savedRecipe;
  }

  /// 모든 레시피 조회 (최신순)
  Future<List<Recipe>> getAllRecipes() async {
    print('📖 데이터베이스에서 레시피 목록 조회 중...');
    final recipes = await _database.getAllRecipes();
    print('✅ 조회 완료: ${recipes.length}개의 레시피');
    for (var recipe in recipes) {
      print('   - ${recipe.title} (ID: ${recipe.id}, 재료: ${recipe.ingredients.length}개, 단계: ${recipe.steps.length}개)');
    }
    return recipes;
  }

  /// 레시피 조회 (ID로)
  Future<Recipe?> getRecipeById(int id) async {
    // [수정됨] DB가 이미 Recipe?를 반환하므로 추가 변환 필요 없음
    return await _database.getRecipeById(id);
  }

  /// 레시피 삭제
  Future<bool> deleteRecipe(int id) async {
    try {
      await _database.deleteRecipe(id);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 레시피 중복 확인 (YouTube ID 기준)
  Future<bool> recipeExists(String youtubeId) async {
    final allRecipes = await getAllRecipes();
    return allRecipes.any((recipe) => recipe.youtubeId == youtubeId);
  }

  /// URL로 중복 확인
  Future<bool> recipeExistsByUrl(String youtubeUrl) async {
    final videoId = Validators.extractVideoId(youtubeUrl);
    if (videoId == null) {
      return false;
    }
    return await recipeExists(videoId);
  }
}