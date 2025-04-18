// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mytomes/sys/extensions.util.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../res/bottomsheet.util.dart';
import '../../sys/notifications.dart';

final supabase = Supabase.instance.client;

class PlaygroundPage extends StatelessWidget {
  const PlaygroundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const FilledButton(
            onPressed: sendNotificationForExpiredLend,
            child: Text("Test #1: Push Notif for all EXPIRED books")),
        FilledButton(
            onPressed: () async {
              NotificationService.showNotificationWithActions();
            },
            child: const Text("Test #2: Push Notif with actions")),
        FilledButton(
            onPressed: () {
              showAdaptiveSheet(context, child: const Text("Test"));
            },
            child: const Text("Test #3 - Adaptive bottom sheet"))
      ],
    );
  }
}

void sendNotificationForExpiredLend() async {
  final books = await supabase
      .from('lends')
      .select()
      .lte('due', DateTime.now().add(const Duration(days: 3)).toShortString())
      .order('due', ascending: true);
  print(books.toString());
  for (var index = 0; index < books.length; index++) {
    final bookdata = books[index];
    final title = bookdata['title'];
    print("Libro #$index: " + title);
    try {
      final due = bookdata['due'].toString().toDateTime();
      final time = due.difference(DateTime.now()).inDays;
      if (time < 4 && time >= 0) {
        print("expiring");
        if (!kIsWeb && Platform.isAndroid) {
          NotificationService.showLendNotification(
              "🗓️ Hai un libro in scadenza",
              "Il libro $title scadrà tra ${(time + 1).toString()} giorni",
              bookdata['id'],
              bookdata['id']);
        }
      } else if (time < 0) {
        if (!kIsWeb && Platform.isAndroid) {
          NotificationService.showLendNotification(
              "⚠️ Hai un libro scaduto",
              "Il libro $title è scaduto da ${(-(time + 1)).toString()} giorni",
              bookdata['id'],
              bookdata['id']);
        }
      }
    } catch (e) {
      print("error: $e");
    }
  }
}

@pragma('vm:entry-point')
void myCallback(int id) {
  print("helloworld");
  if (!kIsWeb && Platform.isAndroid) {
    NotificationService.showNotification(
      "Test Notif",
      "...",
    );
  }
}
