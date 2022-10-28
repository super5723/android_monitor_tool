// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cpu_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CpuInfo _$CpuInfoFromJson(Map<String, dynamic> json) => CpuInfo(
      json['time'] as int,
      (json['usage'] as num).toDouble(),
    );

Map<String, dynamic> _$CpuInfoToJson(CpuInfo instance) => <String, dynamic>{
      'time': instance.time,
      'usage': instance.usage,
    };
