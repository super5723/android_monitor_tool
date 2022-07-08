import 'dart:io';

/// @Author wangyang
/// @Description
/// @Date 2022/7/7
class ShellCommand {
  String executable;
  List<String> arguments;
  ShellCommand(this.executable, this.arguments);

  Future<CommandResult> run() async {
    bool success = false;
    String? result, errorMsg;
    try {
      ProcessResult processResult = await Process.run(executable, arguments);
      // print('ProcessResult-->stdout=${processResult.stdout} stderr=${processResult.stderr}');
      if (processResult.stderr != null &&
          processResult.stderr is String &&
          (processResult.stderr as String).isNotEmpty) {
        success = false;
        errorMsg = processResult.stderr;
      } else if (processResult.stdout != null &&
          processResult.stdout is String &&
          (processResult.stdout as String).isNotEmpty) {
        success = true;
        if (processResult.stdout is String) {
          result = processResult.stdout;
        } else {
          result = processResult.stdout.toString();
        }
      }
    } catch (e) {
      success = false;
      errorMsg = e.toString();
    }

    return CommandResult(success, result: result, errorMsg: errorMsg);
  }
}

class CommandResult {
  bool success;
  String? result;
  String? errorMsg;

  CommandResult(this.success, {this.result, this.errorMsg});
}
