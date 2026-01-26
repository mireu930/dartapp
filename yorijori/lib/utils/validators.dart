import 'constants.dart';

/// 유효성 검증 유틸리티 클래스
class Validators {
  /// YouTube URL 유효성 검증
  /// 
  /// [REQ-1.1] URL 유효성 검증 (Client)
  /// 정규식을 사용하여 유효성을 검사한다.
  /// 
  /// Returns:
  /// - `true`: 유효한 YouTube URL
  /// - `false`: 유효하지 않은 URL
  static bool isValidYouTubeUrl(String? url) {
    if (url == null || url.trim().isEmpty) {
      return false;
    }
    
    return AppConstants.youtubeUrlPattern.hasMatch(url.trim());
  }

  /// YouTube URL에서 Video ID 추출
  /// 
  /// Returns:
  /// - Video ID 문자열 (성공 시)
  /// - `null` (실패 시)
  static String? extractVideoId(String url) {
    final match = AppConstants.youtubeVideoIdPattern.firstMatch(url);
    return match?.group(1);
  }

  /// YouTube URL 정규화
  /// 다양한 형식의 YouTube URL을 표준 형식으로 변환
  /// 
  /// Examples:
  /// - `youtu.be/abc123` -> `https://www.youtube.com/watch?v=abc123`
  /// - `youtube.com/watch?v=abc123` -> `https://www.youtube.com/watch?v=abc123`
  static String? normalizeYouTubeUrl(String url) {
    if (!isValidYouTubeUrl(url)) {
      return null;
    }

    final videoId = extractVideoId(url);
    if (videoId == null) {
      return null;
    }

    return 'https://www.youtube.com/watch?v=$videoId';
  }

  /// YouTube 썸네일 URL 생성
  /// 
  /// Quality options:
  /// - `default`: 120x90
  /// - `mqdefault`: 320x180
  /// - `hqdefault`: 480x360
  /// - `sddefault`: 640x480
  /// - `maxresdefault`: 1280x720 (가능한 경우)
  static String getThumbnailUrl(String videoId, {String quality = 'hqdefault'}) {
    return 'https://img.youtube.com/vi/$videoId/$quality.jpg';
  }
}
