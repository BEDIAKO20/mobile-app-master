import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class ReceivedNotification {
  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}


@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse,BuildContext context) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
     if (notificationResponse.input != null) {
        Navigator.of(context).pushNamed(notificationResponse.input);
      }
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String selectedNotificationPayload;

/// A notification action which triggers a url launch event
static const String urlLaunchActionId = 'id_1';

/// A notification action which triggers a App navigation event
static const String navigationActionId = 'id_3';

/// Defines a iOS/MacOS notification category for text input actions.
static const String darwinNotificationCategoryText = 'textCategory';

/// Defines a iOS/MacOS notification category for plain actions.
static const String darwinNotificationCategoryPlain = 'plainCategory';


      final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
    StreamController<ReceivedNotification>.broadcast();

   List<DarwinNotificationCategory> darwinNotificationCategories =
      <DarwinNotificationCategory>[
    DarwinNotificationCategory(
      darwinNotificationCategoryText,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.text(
          'text_1',
          'Action 1',
          buttonTitle: 'Send',
          placeholder: 'Placeholder',
        ),
      ],
    ),
    DarwinNotificationCategory(
      darwinNotificationCategoryPlain,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.plain('id_1', 'Action 1'),
        DarwinNotificationAction.plain(
          'id_2',
          'Action 2 (destructive)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.destructive,
          },
        ),
        DarwinNotificationAction.plain(
          navigationActionId,
          'Action 3 (foreground)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.foreground,
          },
        ),
        DarwinNotificationAction.plain(
          'id_4',
          'Action 4 (auth required)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.authenticationRequired,
          },
        ),
      ],
      options: <DarwinNotificationCategoryOption>{
        DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
      },
    )
  ];

final StreamController<String> selectNotificationStream =
    StreamController<String>.broadcast();

  static void initialize(BuildContext context) {
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
          // onDidReceiveLocalNotification:
          //     (int id, String title, String body, String payload) async {}
           )
    );

    _notificationsPlugin.initialize(initializationSettings,
    //     onSelectNotification: (String route) async {
    //   if (route != null) {
    //     Navigator.of(context).pushNamed(route);
    //   }
      
    // },
     onDidReceiveBackgroundNotificationResponse: (notificationResponse){
      if (notificationResponse.input != null) {
        Navigator.of(context).pushNamed(notificationResponse.payload);
      }
     },
    );
  }



  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
    onDidReceiveLocalNotification:
        (int id, String title, String body, String payload) async {
    
        ReceivedNotification(
          id: id,
          title: title,
          body: body,
          payload: payload,
        );
      
    },
    // notificationCategories: darwinNotificationCategories,
  );
  

  static void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      final NotificationDetails notificationDetails = NotificationDetails(
      //     android: AndroidNotificationDetails(
      //   'High_importance_channel',
      //   'High Importance Notificatoion',
      //   channelDescription: "this is our channel",
      //   importance: Importance.max,
      //   priority: Priority.high,
      //   playSound: true,
      // ),

      android: AndroidNotificationDetails(
        'High_importance_channel',
        'High Importance Notificatoion',
        channelDescription: 'High Importance Notificatoion',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true
        
      ),
      //  iOS: IOSNotificationDetails(
      //           presentAlert: true, presentBadge: true, presentSound: true),
      );

      await _notificationsPlugin.show(
        id,
        message.notification.title,
        message.notification.body,
        notificationDetails,
        payload: message.data["route"],
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}
