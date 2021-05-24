import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImage {
  File imageFile;
  Uint8List imgBytesData;

  final picker = ImagePicker();

  double maxWidth = 200;

  final VoidCallback updateFile;

  PickImage({this.updateFile, @required this.context});

  final BuildContext context;

  _selectFromCamera() async {

    try{
      final pickedFile = await picker.getImage(source: ImageSource.camera);
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        imgBytesData = await pickedFile.readAsBytes();
        if(updateFile != null){
          updateFile();
        }
      } else {
        print('No image selected.');
      }
    }catch(e){
      print('Error is $e');
    }
  }

  _selectFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      imgBytesData = await pickedFile.readAsBytes();
      if(updateFile != null){
        updateFile();
      }
    } else {
      print('No image selected.');
    }
  }

  selectImage() {
    if (Platform.isIOS) {
      CupertinoAlertDialog alert = CupertinoAlertDialog(
        title: Text("Pic Profile Image"),
        content: Text("Please select an option to pic your image."),
        actions: [
          CupertinoDialogAction(
            child: Text("Gallery"),
            onPressed: () {
              Navigator.pop(context);
              _selectFromGallery();
            },
          ),
          CupertinoDialogAction(
            child: Text("Camera"),
            onPressed: () {
              Navigator.pop(context);
              _selectFromCamera();
            },
          ),
          CupertinoDialogAction(
            child: Text("Cancel", style: TextStyle(color: Colors.red),),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );

      showCupertinoDialog(context: context, builder: (context) {
        return alert;
      },);
    } else {
      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Pic Profile Image"),
        content: Text("Please select an option to pic your image."),
        actions: [
          TextButton(
            child: Text("Camera"),
            onPressed: () {
              Navigator.pop(context);
              _selectFromCamera();
            },
          ),
          TextButton(
            child: Text("Gallery"),
            onPressed: () {
              Navigator.pop(context);
              _selectFromGallery();
            },
          ),
          TextButton(
            child: Text("Cancel", style: TextStyle(color: Colors.red),),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  selectImageFromCamera() {
    if (Platform.isIOS) {
      CupertinoAlertDialog alert = CupertinoAlertDialog(
        title: Text("Pic Profile Image"),
        content: Text("Please select an option to pic your image."),
        actions: [
          CupertinoDialogAction(
            child: Text("Camera"),
            onPressed: () {
              Navigator.pop(context);
              _selectFromCamera();
            },
          ),
          CupertinoDialogAction(
            child: Text("Cancel", style: TextStyle(color: Colors.red),),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );

      showCupertinoDialog(context: context, builder: (context) {
        return alert;
      },);
    } else {
      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Pic Profile Image"),
        content: Text("Please select an option to pic your image."),
        actions: [
          TextButton(
            child: Text("Camera"),
            onPressed: () {
              Navigator.pop(context);
              _selectFromCamera();
            },
          ),
          TextButton(
            child: Text("Cancel", style: TextStyle(color: Colors.red),),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }
}