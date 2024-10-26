import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
            child: const Text("Test #2: Push Notif with actions"))
      ],
    );
  }
}

void sendNotificationForExpiredLend() async {
  print("object");
  final books = await supabase.from('lends').select() as List;
  print(books.toString());
  for (var i = 0; i < books.length; i++) {
    final bookdata = books[i];
    final title = bookdata['title'];
    print(title);
    try {
      final unpDue = bookdata['due'];
      final due = DateTime.tryParse(unpDue) ?? DateTime.timestamp();
      print(
          "year: ${due.year.toString()}, month: ${due.month.toString()}, day: ${due.day.toString()}");
      final time = due.difference(DateTime.timestamp()).inDays;
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
              "Il libro $title è scaduto da ${((time + 1) * (-1)).toString()} giorni",
              bookdata['id'],
              bookdata['id']);
        }
      } else {
        print("ok");
      }
    } catch (e) {}
  }
}
/*
class PlaygroundPage extends StatefulWidget {
  const PlaygroundPage({super.key});

  @override
  State<PlaygroundPage> createState() => _PlaygroundPageState();
}

class _PlaygroundPageState extends State<PlaygroundPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                NotificationService.init();
              },
              child: const Text('Init Notification'),
            ),
            const SizedBox(height: 12),ElevatedButton(
              onPressed: () {
                NotificationService.showInstantNotification(
                    "Instant Notification", "This shows an instant notifications");
              },
              child: const Text('Show Notification'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                DateTime scheduledDate = DateTime.now().add( const Duration(seconds: 5));
                NotificationService.scheduleNotification(
                  0,
                  "Scheduled Notification",
                  "This notification is scheduled to appear after 5 seconds",
                  scheduledDate,
                );
              },
              child: const Text('Schedule Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
*/
