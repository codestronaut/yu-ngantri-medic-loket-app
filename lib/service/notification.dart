import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotificationService {
  Future sendNotification(String receiver, String title, String body) async {
    var token = await getToken(receiver);
    print('token: $token'); // LOG

    final postUrl = 'https://fcm.googleapis.com/fcm/send';

    final data = {
      "notification": {"body": "$body", "title": "$title"},
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "sound": "default",
        "id": "1",
        "status": "done"
      },
      "to": "$token"
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAAMgYluFA:APA91bHk2SY73dYjx2IybXhksXszB3dmFjQZIFaspLqFvt4S0B80St2Wdd8t6JxmpWYf6w1PtXMKFQFaA-PH3NjkYHspPxPugPi7-l89Pms1dPB6V3iPCRWfW_dTPf0Pjbx0fxJVnMkz'
    };

    BaseOptions options = new BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 3000,
      headers: headers,
    );

    try {
      final response = await Dio(options).post(postUrl, data: data);
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Notifikasi terkirim');
      } else {
        print('notification sending failed');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future getToken(String uid) async {
    final Firestore _db = Firestore.instance;

    var token;
    await _db.collection('users').document(uid).get().then((value) {
      token = value.data['device_token'];
    });

    return token;
  }
}
