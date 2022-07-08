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
      toolBar: ToolBar(
        title: const Text('Untitled Document'),
        titleWidth: 200.0,
        actions: [
          ToolBarIconButton(
            label: "Add",
            icon: const MacosIcon(
              CupertinoIcons.add_circled,
            ),
            onPressed: () => debugPrint("Add..."),
            showLabel: true,
          ),
          const ToolBarSpacer(),
          ToolBarIconButton(
            label: "Delete",
            icon: const MacosIcon(
              CupertinoIcons.trash,
            ),
            onPressed: () => debugPrint("Delete"),
            showLabel: false,
          ),
          ToolBarPullDownButton(
            label: "Actions",
            icon: CupertinoIcons.ellipsis_circle,
            items: [
              MacosPulldownMenuItem(
                label: "New Folder",
                title: const Text("New Folder"),
                onTap: () => debugPrint("Creating new folder..."),
              ),
              MacosPulldownMenuItem(
                label: "Open",
                title: const Text("Open"),
                onTap: () => debugPrint("Opening..."),
              ),
            ],
          ),
        ],
      ),
      children: [
        ContentArea(
          builder: ((context, scrollController) {
            return const Center(
              child: Text('Home'),
            );
          }),
        ),
      ],
    );
  }
}
