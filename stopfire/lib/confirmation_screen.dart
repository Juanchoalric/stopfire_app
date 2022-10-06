import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import  'package:intl/intl.dart';

import 'camera_screen.dart';

class ConfirmationScreen extends StatefulWidget {
  final XFile? pictureFile;
  final String uri = 'http://127.0.0.1:5000/analyze';
  final Position? position;
  const ConfirmationScreen({this.pictureFile, this.position, Key? key}) : super(key: key);

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {

  createAlertDialog(BuildContext context){
    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: const Text("Tu imagen fue enviada!"),
        content: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.red,
              textStyle: const TextStyle(color: Colors.white)
          ),
          onPressed: (){
            Navigator.pop(context);
          },
          child: const Text("VOLVER"),),
      );
    });
  }
  
  Future<void> uploadImage ()async{

    var stream  = http.ByteStream(widget.pictureFile!.openRead());
    stream.cast();

    var length = await widget.pictureFile!.length();

    //var uri = Uri.parse('http://10.0.2.2:5000/analyze');
    var uri = Uri.parse("http://192.168.1.9:5000/analyze");
    var request = http.MultipartRequest('POST', uri);

    request.files.add(
        http.MultipartFile(
            'file',
            File(widget.pictureFile!.path).readAsBytes().asStream(),
            File(widget.pictureFile!.path).lengthSync(),
            filename: widget.pictureFile!.path.split("/").last
        )
    );

    String date = DateFormat("dd/MM/yy HH:mm:ss").format(DateTime.now());

    request.fields['taken_at'] = date ;
    request.fields['latitude'] = widget.position!.latitude.toString();
    request.fields['longitude'] = widget.position!.longitude.toString();
    request.fields['id_camera'] = "5" ;
    request.fields['camera_type'] = "Punto movil" ;
    request.fields['zone'] = '5' ;

    await request.send();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Confirmation")),
      body: Column(
        children: [
          Image.file(File(widget.pictureFile!.path)),
          Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red, 
                textStyle: const TextStyle(color: Colors.white)
                ),
              onPressed: (){
                Navigator.pop(context);
              },
              child: const Text("BACK"),),
            const Padding(
              padding: EdgeInsets.fromLTRB(30.0,0,0,0)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                textStyle: const TextStyle(color: Colors.white)
                ),
              // Image.file(File(widget.pictureFile!.path))
              onPressed: () async {
                uploadImage();
                createAlertDialog(context);
              }, 
              child: const Text("SEND"))
          ],
          ),
        ],
      ),
    );
  }
}