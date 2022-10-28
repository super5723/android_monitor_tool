// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mem_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemoryInfo _$MemoryInfoFromJson(Map<String, dynamic> json) => MemoryInfo(
      json['javaHeapSize'] as int,
      json['nativeHeapSize'] as int,
      json['graphicSize'] as int,
      json['totalSize'] as int,
      json['time'] as int,
    );

Map<String, dynamic> _$MemoryInfoToJson(MemoryInfo instance) => <String, dynamic>{
      'javaHeapSize': instance.javaHeapSize,
      'nativeHeapSize': instance.nativeHeapSize,
      'graphicSize': instance.graphicSize,
      'totalSize': instance.totalSize,
      'time': instance.time,
    };
