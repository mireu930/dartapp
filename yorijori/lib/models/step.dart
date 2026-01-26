import 'package:json_annotation/json_annotation.dart';

part 'step.g.dart';

/// 조리 단계 모델
/// 
/// [REQ-1.2] LLM이 반환하는 조리 단계 구조
@JsonSerializable()
class Step {
  /// 해당 단계의 시작 시간 (초 단위)
  final int time;
  
  /// 조리 설명
  final String desc;

  Step({
    required this.time,
    required this.desc,
  });

  /// JSON에서 Step 객체 생성
  factory Step.fromJson(Map<String, dynamic> json) => _$StepFromJson(json);

  /// Step 객체를 JSON으로 변환
  Map<String, dynamic> toJson() => _$StepToJson(this);

  /// Duration 객체로 변환 (플레이어 seekTo에 사용)
  Duration get duration => Duration(seconds: time);

  @override
  String toString() => 'Step(time: $time, desc: $desc)';
}
