import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;
  static BuildContext context;
  SharedPreferences sharedPreferences;

  NotificationHelper() {
    initializedNotification();
  }

  initializedNotification() async {
    androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    iosInitializationSettings = IOSInitializationSettings(
    );
    initializationSettings = InitializationSettings(android:
        androidInitializationSettings,iOS: iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

 
  Future<void> showNotificationBtweenInterval() async {
 

   

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channel_Id',
      'Channel Name',
      'Channel Description',
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: true,
      enableLights: true,
      ticker: 'test ticker',
      playSound: true,
    );

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails,iOS: iosNotificationDetails);

  

  
      print('play notification');
      await flutterLocalNotificationsPlugin.show(0,  'הצב"ר אוטומטית',
          "הדיווח נשלח בהצלחה", notificationDetails);
    
  }
Future<void> showNotificationActivated(String token,bool failed) async {
 

   

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      '0',
      'דיווח',
      'דיווח הושלם',
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: true,
      enableLights: true,
      ticker: 'test ticker',
      playSound: true,
    );

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails,iOS: iosNotificationDetails);

  

  
      print('play notification');
      await flutterLocalNotificationsPlugin.show(0,  'הצב"ר אוטומטית',
          "הדיווח בבדיקה" + token + failed.toString(), notificationDetails);
    
  }
}
