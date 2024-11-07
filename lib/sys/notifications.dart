import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mybookshelf/sys/extensions.util.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/timezone.dart' as tz;

final supabase = Supabase.instance.client;

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> onDidReceiveNotification(
      NotificationResponse notificationResponse) async {
    print(
        "Notification receive ${notificationResponse.actionId.toString()}, ${notificationResponse.payload.toString()}");

    if (notificationResponse.actionId.toString() == "post") {
      try {
        await Supabase.initialize(
          url: 'https://wmztgdkplkomzdwileqx.supabase.co',
          anonKey:
              'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndtenRnZGtwbGtvbXpkd2lsZXF4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjMwMzEzMzMsImV4cCI6MjAzODYwNzMzM30.eWwZMt4qe7JyuUMubB9gCxDQMKnKPGuQp-k1Y1U5NpI',
        );
      } catch (e) {
        print("object");
      }
      if (supabase.auth.currentUser?.id == null) {
        return;
      }

      try {
        final book = await supabase
            .from('lends')
            .select()
            .eq('id', notificationResponse.payload.toString())
            .single();
        final parsedDue = DateTime.now();
        final newParsedDue = parsedDue.add(const Duration(days: 30));
        final stringDue = newParsedDue.toShortString();
        print("actual due: ${book['due']}, new due: $stringDue");
        print(book.toString());
        print(book['id'].toString());
        await supabase.from('lends').upsert({
          'id': notificationResponse.payload.toString(),
          'due': stringDue
        }).select();
        showNotification("Scadenza cambiata con successo",
            "Abbiamo cambiato la scadenza del libro \"${book['title']}\", che ora scadrà il $stringDue");
      } catch (e) {
        print(e);
        showNotification("Errore", "Impossibile cambiare la scadenza");
      }
    }
  }

  static Future<void> init() async {
    print("init");
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotification,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveNotification,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> showLendNotification(
      String title, String body, String id, String bookID) async {
    NotificationDetails notificationDetails = const NotificationDetails(
      android: AndroidNotificationDetails(
        '1',
        "Libri scaduti",
        importance: Importance.max,
        priority: Priority.high,
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction('post', 'Posticipa'),
        ],
      ),
    );
    await flutterLocalNotificationsPlugin.show(
      Random().nextInt(5000) + 5000,
      title,
      body,
      notificationDetails,
      payload: bookID,
    );
  }

  static Future<void> showNotification(String title, String body) async {
    NotificationDetails notificationDetails = const NotificationDetails(
      android: AndroidNotificationDetails(
        '2',
        "Altro",
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
    await flutterLocalNotificationsPlugin.show(
      Random().nextInt(5000) + 5000,
      title,
      body,
      notificationDetails,
    );
  }

  static Future<void> scheduleNotification(
      int id, String title, String body, DateTime scheduledTime) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_channel',
          'Reminder Channel',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  static Future<void> showNotificationWithActions() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'Scaduti',
      'Libri scaduti',
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction('posticipate', 'Posticipa'),
      ],
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        0, 'Titolo', 'Contenuto', notificationDetails);
  }
}
