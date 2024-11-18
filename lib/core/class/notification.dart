import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;


class MyNotification{

  getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print(token);
  }

  myPermission()async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  getInitialMessage(context)async{
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if(initialMessage != null && initialMessage.notification != null ){
      if(initialMessage.data['type'] == 'none'){
        print("========================================================> Text Message");
        //Navigator.of(context).push(MaterialPageRoute(builder:(context)=> ChatPage(body: "$body",), ));
        print("========================================================> Text Message Done");
      }
    }

  }


  sendNotificationWithTopic({required String title,required String message,required String topic,required Map data})async{
    var headersList = {
      'Accept': '*/*',
      'Content-Type': 'application/json',
      'Authorization': 'key=AAAAbE_V9as:APA91bGiSQ_dE_Pq8JR16u13CsYRHp_vpABLYT8EHGqvzg1NwbE1xnTk9Kqa0Cyd-Z0FnNMe-m-fG3tTOgavimPJb-qQiUaAats80wQtrPzGOUp1ssPBiKRMV_P15pSNbL3QIEyOM-gh'
    };
    var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    var body = {
      "to": "/topics/$topic",
      "notification": {
        "title": title,
        "body": message,

      },
      'data': data

    };

    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);


    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      print(resBody);
    }
    else {
      print(res.reasonPhrase);
    }
  }

  sendNotification(String title,String message,data)async{
    var headersList = {
      'Accept': '*/*',
      'Content-Type': 'application/json',
      'Authorization': 'key=AAAAbE_V9as:APA91bGiSQ_dE_Pq8JR16u13CsYRHp_vpABLYT8EHGqvzg1NwbE1xnTk9Kqa0Cyd-Z0FnNMe-m-fG3tTOgavimPJb-qQiUaAats80wQtrPzGOUp1ssPBiKRMV_P15pSNbL3QIEyOM-gh'
    };
    var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    var body = {
      "to": "e33W324OTSCm_StRRtkYWO:APA91bEykBBqNkj_Ls5JG5trRyzneOfqwywzQMI_rLujqHyOfQTiDdQq0pqNdqVaWxs-Jq09_V0QD4ATbUmiU4MA8TSFQcTpdGR0Vh2BfEU9J52wmothj8cZXHl2LfLvJHM0CJDrtJsu",
      "notification": {
        "title": title,
        "body": message,

      },
      'data': data

    };

    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);


    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      print(resBody);
    }
    else {
      print(res.reasonPhrase);
    }
  }


}