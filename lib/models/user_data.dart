import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

FirebaseAnalytics _analytics;

Future setUserProperties({@required String userId}) async{
  await _analytics.setUserId(userId);
}

Future logPosition({String userId, String lat, String long}) async {
  await _analytics.logEvent(
    name: "qr_scanned",
    parameters: {
      "userId": userId,
      "Latitude": lat,
      "Longitude": long,
    },
  );
}
