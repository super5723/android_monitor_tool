// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(usage) => "Cpu Usage:${usage}%";

  static String m1(msg) => "export fail:${msg}";

  static String m2(file) => "export success:${file}";

  static String m3(process) => "Process:${process}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "clear": MessageLookupByLibrary.simpleMessage("clear data"),
        "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "control": MessageLookupByLibrary.simpleMessage("Control"),
        "cpu_page_title": m0,
        "cpu_page_title_default":
            MessageLookupByLibrary.simpleMessage("Cpu Usage"),
        "export": MessageLookupByLibrary.simpleMessage("Export"),
        "exporting_fail": m1,
        "exporting_success": m2,
        "file": MessageLookupByLibrary.simpleMessage("File"),
        "hint_input_interval": MessageLookupByLibrary.simpleMessage(
            "input interval,must greater than 1000"),
        "hint_input_process_name":
            MessageLookupByLibrary.simpleMessage("input process name"),
        "import": MessageLookupByLibrary.simpleMessage("Import"),
        "input_interval_not_valid": MessageLookupByLibrary.simpleMessage(
            "interval not valid,must greater than 1000"),
        "memory_page_title_common": m3,
        "memory_page_title_default": MessageLookupByLibrary.simpleMessage(
            "please input processName by setting"),
        "select_export_path":
            MessageLookupByLibrary.simpleMessage("Select path"),
        "select_import_file":
            MessageLookupByLibrary.simpleMessage("Select file"),
        "set_command_interval":
            MessageLookupByLibrary.simpleMessage("Shell interval"),
        "set_process_name": MessageLookupByLibrary.simpleMessage("set Process"),
        "setting": MessageLookupByLibrary.simpleMessage("Setting"),
        "sidebar_name_cpu": MessageLookupByLibrary.simpleMessage("CPU"),
        "sidebar_name_memory": MessageLookupByLibrary.simpleMessage("Memory"),
        "start": MessageLookupByLibrary.simpleMessage("Start"),
        "status_error_process_name_empty":
            MessageLookupByLibrary.simpleMessage("process is empty"),
        "stop": MessageLookupByLibrary.simpleMessage("Stop"),
        "submit": MessageLookupByLibrary.simpleMessage("Submit"),
        "success": MessageLookupByLibrary.simpleMessage("success")
      };
}
