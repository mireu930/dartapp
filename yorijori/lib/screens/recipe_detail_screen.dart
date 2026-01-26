import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';
import '../utils/constants.dart';

/// 레시피 상세 화면 (임시 구현)
/// 
/// TODO: [REQ-2.1] 고정형 영상 플레이어
/// TODO: [REQ-2.2] 재료 체크리스트
/// TODO: [REQ-2.3] 인터랙티브 조리 단계
class RecipeDetailScreen extends StatefulWidget {
  final int recipeId;

  const RecipeDetailScreen({
    super.key,
    required this.recipeId,
  });

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final RecipeService _recipeService = RecipeService();
  Recipe? _recipe;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecipe();
  }

  Future<void> _loadRecipe() async {
    try {
      final recipe = await _recipeService.getRecipeById(widget.recipeId);
      setState(() {
        _recipe = recipe;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('레시피 상세'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _recipe == null
              ? const Center(child: Text('레시피를 찾을 수 없습니다.'))
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _recipe!.title,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: 8),
          Text(
            _recipe!.channelName,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 24),
          const Text(
            '재료',
            style: TextStyle(
              fontSize: AppConstants.titleTextSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ..._recipe!.ingredients.map(
            (ingredient) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline,
                      color: AppConstants.primaryColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      ingredient,
                      style: const TextStyle(fontSize: AppConstants.bodyTextSize),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            '조리법',
            style: TextStyle(
              fontSize: AppConstants.titleTextSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ..._recipe!.steps.asMap().entries.map(
            (entry) {
              final index = entry.key;
              final step = entry.value;
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.cardPadding),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppConstants.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              step.desc,
                              style: const TextStyle(
                                fontSize: AppConstants.recipeTextSize,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${step.time}초',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
