import "dart:math";

import "package:flutter/material.dart";

//ignore: must_be_immutable
class SettingsSharingPage extends StatefulWidget {
  final chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789';
  late String sharingcode = "";

  SettingsSharingPage({super.key});

  @override
  State<SettingsSharingPage> createState() => _SettingsSharingPageState();
}

class _SettingsSharingPageState extends State<SettingsSharingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Condivisione"),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          ListTile(
            title: SelectableText(widget.sharingcode.toString()),
          ),
          ListTile(
            title: ElevatedButton(
              child: const Text("genera"),
              onPressed: () {
                setState(() {
                  widget.sharingcode = String.fromCharCodes(List.generate(
                      32,
                      (index) => widget.chars.codeUnitAt(
                          Random.secure().nextInt(widget.chars.length))));
                });
              },
            ),
          )
        ]),
      ),
    );
  }
}
