import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../models/recipe.dart';
import '../utils/constants.dart';

/// 레시피 리스트 카드 위젯
/// 
/// [REQ-3.2] 리스트 카드 UI
/// - 썸네일 이미지 (좌측)
/// - 요리 제목
/// - 채널명
/// - 등록 날짜 (YYYY-MM-DD 형식)
class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final formattedDate = dateFormat.format(recipe.createdAt);

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.screenPadding,
        vertical: AppConstants.cardSpacing / 2,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.cardPadding),
          child: Row(
            children: [
              // 썸네일 이미지
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: recipe.thumbnailUrl,
                  width: 100,
                  height: 75,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 100,
                    height: 75,
                    color: AppConstants.borderColor,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 100,
                    height: 75,
                    color: AppConstants.borderColor,
                    child: const Icon(
                      Icons.error_outline,
                      color: AppConstants.secondaryTextColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.cardPadding),
              // 텍스트 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 요리 제목
                    Text(
                      recipe.title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: AppConstants.bodyTextSize,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // 채널명
                    Text(
                      recipe.channelName,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // 등록 날짜
                    Text(
                      formattedDate,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppConstants.secondaryTextColor,
                          ),
                    ),
                  ],
                ),
              ),
              // 화살표 아이콘
              const Icon(
                Icons.chevron_right,
                color: AppConstants.secondaryTextColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
