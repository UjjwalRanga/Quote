import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'main.dart';

// Method 1 for push Notification
/*
void sendNotification({String? title, String? body}) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  ////Set the settings for various platform
  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const IOSInitializationSettings initializationSettingsIOS =
  IOSInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );
  const LinuxInitializationSettings initializationSettingsLinux =
  LinuxInitializationSettings(
    defaultActionName: 'hello',
  );
  const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      linux: initializationSettingsLinux);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_channel',
      'High Importance Notification',
      description: "This channel is for important notification",
      importance: Importance.max);

  flutterLocalNotificationsPlugin.show(
    0,
    title,
    body,
    NotificationDetails(
          android: AndroidNotificationDetails(channel.id, channel.name,
          channelDescription: channel.description),
    ),
  );
}
*/

// Method 2 for push Notification

class PushNotification{

  static FlutterLocalNotificationsPlugin LocalNotifications =
  FlutterLocalNotificationsPlugin();
  static final onNotification = BehaviorSubject<String?>();

  static Future notificationDetails() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
            'channel_id',
            'channel_name',
           channelDescription: 'channel_description',
          importance: Importance.max,
        ),
    );
  }
  static Future init(bool intilize)async{
    const  android =  AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = IOSInitializationSettings();

    const settings = InitializationSettings(iOS: ios,android: android);

    await LocalNotifications.initialize(
        settings,
      onSelectNotification: (payload) async {
          onNotification.add(payload);
      },
    );

  }
  static tz.TZDateTime dailySch(){

      final now  = tz.TZDateTime.now(tz.local);
      final here = DateTime.now();
      var schDate;

      int hourDifference = now.hour-DateTime.now().hour;
      int minuteDifference = now.minute-DateTime.now().minute;


      if(minuteDifference<0){
        schDate = tz.TZDateTime(tz.local,now.year,now.month,now.day,
            (int.parse(MyApp.Tnow.substring(0,2))-5)%60,
            (int.parse(MyApp.Tnow.substring(3,5))-30)%60,00);
      }else{
        schDate = tz.TZDateTime(tz.local,now.year,now.month,now.day,
            (int.parse(MyApp.Tnow.substring(0,2))-6)%60,
            (int.parse(MyApp.Tnow.substring(3,5))+30)%60,00);
      }


      /*
      print('');
      print(hourDifference);
      print(minuteDifference);
      print(now);
      print(schDate);
      */
      return schDate.isBefore(now) ? schDate.add(const Duration(days: 1)) : schDate;
  }
  static Future showNotification({
     int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime schedule
}) async {

      tz.initializeTimeZones();
    LocalNotifications.zonedSchedule(
        id,
        title,
        body,
      dailySch(),
        await notificationDetails(),
      payload: payload,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
    );

  }


}