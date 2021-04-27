import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image/image.dart' as Img;
import 'dart:io';
import 'dart:math';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();



}



class _MyHomePageState extends State<MyHomePage> {

  final DatabaseReference DBRef=FirebaseDatabase.instance.reference();
  Position _currentPosition;
  var userName;
  Geolocator gg = Geolocator();
  var distanceInMeters;
  String sourceImage;

  var mapp;
  final picker = ImagePicker();
  var _image;
  var uLat=0.0,uLng=0.0;
  bool locationFetched;
  bool imagePicked = false;

  _getCurrentLocation() async {
    _currentPosition = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    //print(_currentPosition.longitude);
    //print(_currentPosition.latitude);

    setState(() {
      if (_currentPosition != null) {
        print(_currentPosition.longitude);
        print(_currentPosition.latitude);
        uLat = _currentPosition.latitude;
        uLng = _currentPosition.longitude;
        setState(() {
          distanceInMeters =  gg.distanceBetween(52.2165157, 6.9437819, 52.3546274, 4.8285838);
        });
        print(distanceInMeters);
      }

    });

  }
  void writeData () {
    DBRef.child("$userName").set({
      'long': _currentPosition.longitude,
      'lat': _currentPosition.latitude,
      'img': sourceImage
      // 'time': DateTime.now()
    });
  }

  void readData(){
    DBRef.once().then((DataSnapshot dataSnapshot){
      print(dataSnapshot.value);
      setState(() {
        mapp = dataSnapshot.value;
      });
      // List<Map<String,double>> lst = [];
      // dataSnapshot.value.entries.forEach((element){
      //   print(element.value);
      //   lst.add(element.value);
      // });

    });
  }
  //{Sangamithrai: {lat: 12.9335784, long: 80.1479173}, UserLocation: {lat: 13.0764511, long: 80.2096475}}
  initState(){
    super.initState();
    _getCurrentLocation();
        //.then((position) {
      //userLocation = position;
      // writeData();
    //});
  }


  num degreesToRads(num deg) {
    return (deg * pi) / 180.0;
  }
  num haversinedistance(num lat1,num lon1,num lat2,num lon2){
    num r = 6371;
    num phi1 = degreesToRads(lat1);
    num phi2 = degreesToRads(lat2);
    num deltaphi = degreesToRads(lat2 - lat1);
    num deltalambda = degreesToRads(lon2 - lon1);
    num a = pow(sin(deltaphi / 2),2) + cos(phi1) * cos(phi2) *   pow(sin(deltalambda / 2),2);
    num res = r * (2 * atan2(sqrt(a), sqrt(1 - a)));
    return res;
  }


  onClickImage() async{
    var pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if(pickedFile !=null){
        _image = File(pickedFile.path);
        imagePicked = true;
        sourceImage = base64Encode(_image.readAsBytesSync());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Social Distance check",style: TextStyle(color: Colors.white),),
        elevation: 40.0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: [
              TextField(
                onChanged: (value) {setState(() {
                  userName = value;
                });},
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(top: 30,left: 20),
                  hintText: "Name",
                  fillColor: Colors.orange.withOpacity(0.1),
                  filled: true,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Icon(Icons.account_circle,size: 20,),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    borderSide: BorderSide.none,
                  ),
                ),),
              SizedBox(height: 20,),
              Text("Photo",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              (!imagePicked)?Center(
                child: TextButton(onPressed: (){onClickImage();}, child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.photo),
                        Text("Select photo")
                      ],
                    ),
                    SizedBox(height: 200,)
                  ],
                ),),
              ): (_image!=null)?Container(width: 200,height: 200,decoration: BoxDecoration(shape: BoxShape.circle,),child: Image.file(File(_image.path),)):Container(),
              Text("Location",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              Text("Longitude: $uLng"),
              Text(" Lattitude: $uLat"),
              TextButton(onPressed: (){writeData();}, child: Text("Proceed")),
              TextButton(onPressed: (){readData();}, child: Text("get data")),
              (mapp!=[])?Text("$mapp"):Text("")
            ],
          ),
        ),
      ),
    );
  }
}