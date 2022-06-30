/// @Author wangyang
/// @Description 
/// @Date 2022/6/30
class MemoryInfo {
  int javaHeapSize; //KB
  int nativeHeapSize;
  int graphicSize;
  int totalSize;
  int time;

  MemoryInfo(this.javaHeapSize, this.nativeHeapSize, this.graphicSize, this.totalSize, this.time);

  @override
  String toString() {
    return 'MemoryInfo{javaHeapSize: $javaHeapSize, nativeHeapSize: $nativeHeapSize, graphicSize: $graphicSize, totalSize: $totalSize, time: $time}';
  }
}