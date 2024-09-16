import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ButtonsCard extends StatelessWidget {
  const ButtonsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors =
        WindowButtonColors(iconNormal: Theme.of(context).iconTheme.color);
    final closeApp = WindowButtonColors(
        iconNormal: Theme.of(context).iconTheme.color,
        mouseOver: Colors.red[800]);

    return Card.filled(
      clipBehavior: Clip.hardEdge,
      child: (!kIsWeb && Platform.isWindows)
          ? Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                  MoveWindow(
                    child: AspectRatio(
                        aspectRatio: 1,
                        child: Icon(Icons.drag_indicator_rounded)),
                  ),
                  MinimizeWindowButton(
                    colors: colors,
                  ),
                  MaximizeWindowButton(
                    colors: colors,
                  ),
                  CloseWindowButton(
                    colors: closeApp,
                  )
                ])
          : null,
    );
  }
}
