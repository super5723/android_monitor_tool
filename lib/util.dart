/// @Author wangyang
/// @Description 
/// @Date 2022/6/28
class Util{
  static int parseInt(dynamic value, [int defaultValue = 0]) {
    if (value == null) return defaultValue;
    if (value is String) {
      try {
        return int.parse(value);
      } catch (e) {
        return defaultValue;
      }
    }
    if (value is int) return value;
    if (value is double) return value.toInt();
    return defaultValue;
  }

}