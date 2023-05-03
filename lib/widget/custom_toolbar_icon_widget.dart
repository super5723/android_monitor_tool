//@dart=2.12
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

/// @Author wangyang
/// @Description
/// @Date 2023/4/20
class CustomToolbarIconWidget extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  const CustomToolbarIconWidget({Key? key, required this.icon, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = MacosTheme.of(context).brightness;
    return MacosIconButton(
      disabledColor: Colors.transparent,
      icon: MacosIconTheme(
        data: MacosTheme.of(context).iconTheme.copyWith(
              color: brightness.resolve(
                const Color.fromRGBO(0, 0, 0, 0.5),
                const Color.fromRGBO(255, 255, 255, 0.5),
              ),
              size: 20.0,
            ),
        child: icon,
      ),
      onPressed: onPressed,
      boxConstraints: const BoxConstraints(
        minHeight: 26,
        minWidth: 20,
        maxWidth: 48,
        maxHeight: 38,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
    );
  }
}
