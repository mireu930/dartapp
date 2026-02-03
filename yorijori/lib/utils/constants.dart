import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 요리조리 앱의 상수 및 설정 값들
class AppConstants {
  // 앱 정보
  static const String appName = '요리조리';
  static const String appSlogan = '영상은 한 번만, 요리는 편하게.';

  // API 설정
  /// 개발 환경 API Base URL (로컬 ngrok 등)
  static const String devApiBaseUrl =
      'https://usuriously-litten-deneen.ngrok-free.dev';

  /// 프로덕션 API Base URL (앱 스토어 심사·배포용, 클라우드 배포 후 여기 넣기)
  /// 예: Render 배포 후 https://yorijori-api.onrender.com
  static const String prodApiBaseUrl = 'https://api.yorijori.com';

  /// 현재 사용할 API Base URL (릴리스 빌드 = 프로덕션, 디버그 = 개발)
  static String get apiBaseUrl => kReleaseMode ? prodApiBaseUrl : devApiBaseUrl;

  /// API 엔드포인트
  static const String analyzeEndpoint = '/api/v1/analyze';

  /// API 타임아웃 (초)
  static const Duration apiTimeout = Duration(seconds: 60);

  // 색상 팔레트 (기획안 반영)
  /// Primary Color - Burnt Orange (#E65100)
  static const Color primaryColor = Color(0xFFE65100);

  /// Background Color - Cream White (#FDFBF7)
  static const Color backgroundColor = Color(0xFFFDFBF7);

  /// Text Color - Dark Gray (#333333)
  static const Color textColor = Color(0xFF333333);

  /// Secondary Text Color (옅은 회색)
  static const Color secondaryTextColor = Color(0xFF666666);

  /// Border Color
  static const Color borderColor = Color(0xFFE0E0E0);

  /// Success Color (체크 완료 등)
  static const Color successColor = Color(0xFF4CAF50);

  /// Error Color
  static const Color errorColor = Color(0xFFE53935);

  // 타이포그래피
  /// 조리법 텍스트 크기 (NFR-2: 가독성 향상 - 18sp 이상)
  static const double recipeTextSize = 18.0;

  /// 제목 텍스트 크기
  static const double titleTextSize = 24.0;

  /// 본문 텍스트 크기
  static const double bodyTextSize = 16.0;

  /// 작은 텍스트 크기
  static const double smallTextSize = 14.0;

  // 레이아웃
  /// 카드 패딩
  static const double cardPadding = 16.0;

  /// 화면 패딩
  static const double screenPadding = 20.0;

  /// 카드 간격
  static const double cardSpacing = 12.0;

  /// YouTube 플레이어 비율 (16:9)
  static const double playerAspectRatio = 16 / 9;

  // 유효성 검증
  /// YouTube URL 정규식 패턴
  static final RegExp youtubeUrlPattern = RegExp(
    r'^(https?:\/\/)?(www\.)?(youtube\.com|youtu\.be)\/.+$',
    caseSensitive: false,
  );

  /// YouTube Video ID 추출 정규식
  static final RegExp youtubeVideoIdPattern = RegExp(
    r'(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/\s]{11})',
    caseSensitive: false,
  );

  // 에러 메시지
  static const String errorInvalidUrl = '올바른 유튜브 링크를 입력해주세요.';
  static const String errorNoTranscript = '자막이 없어 AI가 분석할 수 없는 영상입니다.';
  static const String errorNotCooking = '요리 레시피를 찾을 수 없습니다.';
  static const String errorNetwork = '네트워크 연결을 확인해주세요.';
  static const String errorUnknown = '알 수 없는 오류가 발생했습니다.';

  // 로딩 메시지
  static const String loadingAnalyzing = 'AI가 영상을 맛보는 중입니다...';
  static const String loadingExtracting = '자막을 추출하는 중...';
  static const String loadingProcessing = '레시피를 분석하는 중...';

  // 데이터베이스
  /// 데이터베이스 파일명
  static const String databaseName = 'yorijori.db';

  /// 데이터베이스 버전
  static const int databaseVersion = 1;

  // 기타 설정
  /// 햅틱 피드백 사용 여부
  static const bool enableHapticFeedback = true;

  /// 로딩 애니메이션 지속 시간 (초)
  static const int loadingAnimationDuration = 2;
}

/// 앱 테마 설정
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppConstants.primaryColor,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppConstants.backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: AppConstants.titleTextSize,
          fontWeight: FontWeight.bold,
          color: AppConstants.textColor,
        ),
        bodyLarge: TextStyle(
          fontSize: AppConstants.recipeTextSize,
          color: AppConstants.textColor,
        ),
        bodyMedium: TextStyle(
          fontSize: AppConstants.bodyTextSize,
          color: AppConstants.textColor,
        ),
        bodySmall: TextStyle(
          fontSize: AppConstants.smallTextSize,
          color: AppConstants.secondaryTextColor,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppConstants.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppConstants.primaryColor,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
