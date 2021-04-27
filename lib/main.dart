
import 'package:myapp/screens/LoginScreen.dart';
import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';

// Future<double> distanceInMeters = Geolocator.distanceBetween(52.2165157, 6.9437819, 52.3546274, 4.8285838);


void main() {
  runApp(MyApp());
  // Geolocator gg = Geolocator();
  // var distanceInMeters;
  // distanceInMeters = gg.distanceBetween(52.2165157, 6.9437819, 52.3546274, 4.8285838);
  // print(distanceInMeters.toString());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
        //home: LoginScreen()
      home: LoginScreen(),
    );
  }
}

