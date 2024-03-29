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

  static String m0(usage) => "Cpu使用率:${usage}%";

  static String m1(msg) => "导出失败:${msg}";

  static String m2(file) => "导出成功:${file}";

  static String m3(address) => "http日志服务已连接:${address}";

  static String m4(process) => "进程名:${process}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "cancel": MessageLookupByLibrary.simpleMessage("取消"),
        "clear": MessageLookupByLibrary.simpleMessage("清空数据"),
        "confirm": MessageLookupByLibrary.simpleMessage("确认"),
        "control": MessageLookupByLibrary.simpleMessage("控制"),
        "cpu_page_title": m0,
        "cpu_page_title_default":
            MessageLookupByLibrary.simpleMessage("Cpu使用率"),
        "export": MessageLookupByLibrary.simpleMessage("导出"),
        "exporting_fail": m1,
        "exporting_success": m2,
        "file": MessageLookupByLibrary.simpleMessage("文件"),
        "hint_input_interval":
            MessageLookupByLibrary.simpleMessage("请输入毫秒时间,必须超过1000"),
        "hint_input_process_name":
            MessageLookupByLibrary.simpleMessage("请输入进程名"),
        "http_log_server_connected": m3,
        "http_log_server_disconnected":
            MessageLookupByLibrary.simpleMessage("http日志服务未连接"),
        "import": MessageLookupByLibrary.simpleMessage("导入"),
        "input_http_log_filter_keyword":
            MessageLookupByLibrary.simpleMessage("输入过滤关键字"),
        "input_http_log_server_host":
            MessageLookupByLibrary.simpleMessage("输入日志服务IP"),
        "input_interval_not_valid":
            MessageLookupByLibrary.simpleMessage("时间输入错误,必须超过1000"),
        "memory_page_title_common": m4,
        "memory_page_title_default":
            MessageLookupByLibrary.simpleMessage("请在设置中输入进程名"),
        "select_export_path": MessageLookupByLibrary.simpleMessage("选择导出路径"),
        "select_import_file": MessageLookupByLibrary.simpleMessage("选择文件"),
        "set_clipboard_success":
            MessageLookupByLibrary.simpleMessage("已保存到剪贴板"),
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
