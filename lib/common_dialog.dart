import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

/// @Author wangyang
/// @Description
/// @Date 2022/7/8
const _kBorderRadius = BorderRadius.all(Radius.circular(12.0));

class CommonDialog extends StatefulWidget {
  final Builder content;
  const CommonDialog({Key? key, required this.content}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CommonDialogState();
  }
}

class _CommonDialogState extends State<CommonDialog> {
  @override
  Widget build(BuildContext context) {
    final iconTheme = MacosIconTheme.of(context);
    final brightness = MacosTheme.brightnessOf(context);
    final outerBorderColor = brightness.resolve(
      Colors.black.withOpacity(0.23),
      Colors.black.withOpacity(0.76),
    );
    final innerBorderColor = brightness.resolve(
      Colors.white.withOpacity(0.45),
      Colors.white.withOpacity(0.15),
    );

    return Material(
      type: MaterialType.transparency,
      child: Center(
          child: ClipRRect(
        borderRadius: _kBorderRadius,
        child: Container(
          decoration: BoxDecoration(
            color: brightness.resolve(
              CupertinoColors.systemGrey6.color,
              MacosColors.controlBackgroundColor.darkColor,
            ),
            borderRadius: _kBorderRadius,
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: innerBorderColor,
              ),
              borderRadius: _kBorderRadius,
            ),
            foregroundDecoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: outerBorderColor,
              ),
              borderRadius: _kBorderRadius,
            ),
            child: Stack(
              children: [
                widget.content,
                PositionedDirectional(
                  end: 5,
                  top: 5,
                  child: GestureDetector(
                    child: Icon(
                      CupertinoIcons.clear_circled,
                      color: iconTheme.color,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
