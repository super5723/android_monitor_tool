import 'package:json_annotation/json_annotation.dart';

/// @Author wangyang
/// @Description
/// @Date 2022/10/27
part 'cpu_info.g.dart';

@JsonSerializable()
class CpuInfo {
  int time;
  double usage;

  CpuInfo(this.time, this.usage);

  factory CpuInfo.fromJson(Map<String, dynamic> json) => _$CpuInfoFromJson(json);

  Map<String, dynamic> toJson() => _$CpuInfoToJson(this);

  @override
  String toString() {
    return 'CpuInfo{time: $time, usage: $usage}';
  }
}
