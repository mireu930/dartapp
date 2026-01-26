import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';

/// 메인 화면 (홈)
/// 
/// [REQ-3.1] 레시피 리스트 표시 (최신순)
/// [REQ-3.2] 리스트 카드 UI
/// [REQ-3.3] 스와이프로 삭제
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RecipeService _recipeService = RecipeService();
  List<Recipe> _recipes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  /// 레시피 목록 로드
  Future<void> _loadRecipes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final recipes = await _recipeService.getAllRecipes();
      setState(() {
        _recipes = recipes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('레시피를 불러오는 중 오류가 발생했습니다: $e'),
            backgroundColor: AppConstants.errorColor,
          ),
        );
      }
    }
  }

  /// 레시피 삭제
  Future<void> _deleteRecipe(int id) async {
    final success = await _recipeService.deleteRecipe(id);
    if (success) {
      _loadRecipes();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('레시피가 삭제되었습니다.'),
            backgroundColor: AppConstants.successColor,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('레시피 삭제에 실패했습니다.'),
            backgroundColor: AppConstants.errorColor,
          ),
        );
      }
    }
  }

  /// 레시피 추가 모달 표시
  void _showAddRecipeDialog() {
    showDialog(
      context: context,
      builder: (context) => _AddRecipeDialog(
        onRecipeAdded: () {
          _loadRecipes();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _recipes.isEmpty
              ? _buildEmptyState()
              : _buildRecipeList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddRecipeDialog,
        backgroundColor: AppConstants.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  /// 빈 상태 UI
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 80,
            color: AppConstants.secondaryTextColor,
          ),
          const SizedBox(height: 16),
          Text(
            '아직 저장된 레시피가 없습니다',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppConstants.secondaryTextColor,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '하단의 + 버튼을 눌러\n유튜브 링크를 추가해보세요',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  /// 레시피 리스트 UI
  Widget _buildRecipeList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 헤더
        Padding(
          padding: const EdgeInsets.all(AppConstants.screenPadding),
          child: Text(
            '내가 만든 요리 기록',
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        // 리스트
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadRecipes,
            child: ListView.builder(
              itemCount: _recipes.length,
              itemBuilder: (context, index) {
                final recipe = _recipes[index];
                return Dismissible(
                  key: Key('recipe_${recipe.id}'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppConstants.screenPadding,
                      vertical: AppConstants.cardSpacing / 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppConstants.errorColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {
                    if (recipe.id != null) {
                      _deleteRecipe(recipe.id!);
                    }
                  },
                  child: RecipeCard(
                    recipe: recipe,
                    onTap: () {
                      if (recipe.id != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailScreen(
                              recipeId: recipe.id!,
                            ),
                          ),
                        ).then((_) => _loadRecipes());
                      }
                    },
                    onDelete: () {
                      if (recipe.id != null) {
                        _deleteRecipe(recipe.id!);
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// 레시피 추가 다이얼로그
class _AddRecipeDialog extends StatefulWidget {
  final VoidCallback onRecipeAdded;

  const _AddRecipeDialog({required this.onRecipeAdded});

  @override
  State<_AddRecipeDialog> createState() => _AddRecipeDialogState();
}

class _AddRecipeDialogState extends State<_AddRecipeDialog> {
  final _urlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isAnalyzing = false;
  final RecipeService _recipeService = RecipeService();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  /// 레시피 분석 및 저장
  Future<void> _analyzeRecipe() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isAnalyzing = true;
    });

    try {
      final url = _urlController.text.trim();
      
      // 중복 확인
      final exists = await _recipeService.recipeExistsByUrl(url);
      if (exists && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('이미 저장된 레시피입니다.'),
            backgroundColor: AppConstants.errorColor,
          ),
        );
        setState(() {
          _isAnalyzing = false;
        });
        return;
      }

      // 분석 및 저장
      final recipe = await _recipeService.analyzeAndSaveRecipe(url);

      if (mounted) {
        Navigator.pop(context);
        widget.onRecipeAdded();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${recipe.title} 레시피가 추가되었습니다!'),
            backgroundColor: AppConstants.successColor,
          ),
        );
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: AppConstants.errorColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('오류가 발생했습니다: $e'),
            backgroundColor: AppConstants.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
      }
    }
  }

  /// 클립보드에서 URL 붙여넣기
  Future<void> _pasteFromClipboard() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData?.text != null) {
      _urlController.text = clipboardData!.text!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('레시피 추가'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '유튜브 요리 영상 링크를 입력하세요',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'YouTube URL',
                hintText: 'https://www.youtube.com/watch?v=...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.paste),
                  onPressed: _pasteFromClipboard,
                  tooltip: '클립보드에서 붙여넣기',
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'URL을 입력해주세요.';
                }
                return null;
              },
              enabled: !_isAnalyzing,
            ),
            if (_isAnalyzing) ...[
              const SizedBox(height: 16),
              const CircularProgressIndicator(),
              const SizedBox(height: 8),
              Text(
                AppConstants.loadingAnalyzing,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isAnalyzing ? null : () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: _isAnalyzing ? null : _analyzeRecipe,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.primaryColor,
            foregroundColor: Colors.white,
          ),
          child: const Text('분석하기'),
        ),
      ],
    );
  }
}
