import 'package:json_annotation/json_annotation.dart';

/// @Author wangyang
/// @Description
/// @Date 2022/6/30
part 'mem_info.g.dart';

@JsonSerializable()
class MemoryInfo {
  int javaHeapSize; //KB
  int nativeHeapSize;
  int graphicSize;
  int totalSize;
  int time;

  MemoryInfo(this.javaHeapSize, this.nativeHeapSize, this.graphicSize, this.totalSize, this.time);

  factory MemoryInfo.fromJson(Map<String, dynamic> json) => _$MemoryInfoFromJson(json);

  Map<String, dynamic> toJson() => _$MemoryInfoToJson(this);

  @override
  String toString() {
    return 'MemoryInfo{javaHeapSize: $javaHeapSize, nativeHeapSize: $nativeHeapSize, graphicSize: $graphicSize, totalSize: $totalSize, time: $time}';
  }
}
