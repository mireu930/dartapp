// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Step _$StepFromJson(Map<String, dynamic> json) =>
    Step(time: (json['time'] as num).toInt(), desc: json['desc'] as String);

Map<String, dynamic> _$StepToJson(Step instance) => <String, dynamic>{
  'time': instance.time,
  'desc': instance.desc,
};
