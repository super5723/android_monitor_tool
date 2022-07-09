import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';

/// @Author wangyang
/// @Description
/// @Date 2022/7/7
class CpuInfoPage extends StatefulWidget {
  const CpuInfoPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CpuInfoPageState();
  }
}

class _CpuInfoPageState extends State<CpuInfoPage> {
  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      children: [
        ContentArea(
          builder: ((context, scrollController) {
            return const Center(
              child: Text('cpu'),
            );
          }),
        ),
      ],
    );
  }
}
