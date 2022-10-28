// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh';

  static String m0(msg) => "导出失败:${msg}";

  static String m1(file) => "导出成功:${file}";

  static String m2(process) => "进程名:${process}";

  static String m3(usage) => "当前使用率:${usage}%";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "cancel": MessageLookupByLibrary.simpleMessage("取消"),
        "clear": MessageLookupByLibrary.simpleMessage("清空数据"),
        "confirm": MessageLookupByLibrary.simpleMessage("确认"),
        "control": MessageLookupByLibrary.simpleMessage("控制"),
        "cpu_page_title": MessageLookupByLibrary.simpleMessage("Cpu使用率"),
        "export": MessageLookupByLibrary.simpleMessage("导出"),
        "exporting_fail": m0,
        "exporting_success": m1,
        "file": MessageLookupByLibrary.simpleMessage("文件"),
        "hint_input_interval":
            MessageLookupByLibrary.simpleMessage("请输入毫秒时间,必须超过1000"),
        "hint_input_process_name":
            MessageLookupByLibrary.simpleMessage("请输入进程名"),
        "import": MessageLookupByLibrary.simpleMessage("导入"),
        "input_interval_not_valid":
            MessageLookupByLibrary.simpleMessage("时间输入错误,必须超过1000"),
        "memory_page_title_common": m2,
        "memory_page_title_default": MessageLookupByLibrary.simpleMessage("内存"),
        "realtime_cpu_usage": m3,
        "select_export_path": MessageLookupByLibrary.simpleMessage("选择导出路径"),
        "select_import_file": MessageLookupByLibrary.simpleMessage("选择文件"),
        "set_command_interval":
            MessageLookupByLibrary.simpleMessage("shell时间间隔"),
        "set_process_name": MessageLookupByLibrary.simpleMessage("设置进程"),
        "setting": MessageLookupByLibrary.simpleMessage("设置"),
        "sidebar_name_cpu": MessageLookupByLibrary.simpleMessage("CPU"),
        "sidebar_name_memory": MessageLookupByLibrary.simpleMessage("Memory"),
        "start": MessageLookupByLibrary.simpleMessage("开始"),
        "status_error_process_name_empty":
            MessageLookupByLibrary.simpleMessage("进程名为空"),
        "stop": MessageLookupByLibrary.simpleMessage("停止"),
        "submit": MessageLookupByLibrary.simpleMessage("提交"),
        "success": MessageLookupByLibrary.simpleMessage("成功")
      };
}
