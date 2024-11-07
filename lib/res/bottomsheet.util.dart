import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void showAdaptiveSheet(BuildContext context, {required Widget child}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    elevation: 0,
    constraints: BoxConstraints(maxWidth: 600, minWidth: 600),
    builder: (context) => Container(
        height: MediaQuery.of(context).size.height * (!kIsWeb ? 0.75 : 0.5),
        child: Padding(
          padding: EdgeInsets.only(
              bottom: !kIsWeb ? MediaQuery.of(context).viewInsets.bottom : 0),
          child: child,
        )),
  );
}
