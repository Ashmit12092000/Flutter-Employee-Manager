// ignore_for_file: use_function_type_syntax_for_parameters

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'AppColors.dart';

abstract class ActionsCallback {
  void onPressedPositiveButton(String text);
  void onPressedNegativeButton();
}

class WidgetHelper {
  ActionsCallback mCallback;
  WidgetHelper(this.mCallback);
  static showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
      
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.blueAppColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  SimpleCustomDialog(BuildContext context,titleMessage,description,positiveButtonName,negativeButtonName) {
    return showDialog(
        context: context,
        builder: (param) {
          return AlertDialog(
            title: Text(titleMessage,style: TextStyle(color:AppColors.loginButtonColor),),
            content: Text(
              description,
              // ignore: prefer_const_constructors
              style: TextStyle(
                color: Colors.teal, 
                fontSize: 20
                ),
              
            ),
            actions: [
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, // foreground
                      backgroundColor: Colors.red),
                  onPressed: () async {
                    mCallback.onPressedPositiveButton(description);
                  },
                  child: Text(positiveButtonName)),
              TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.white, // foreground
                      backgroundColor: Colors.teal),
                  onPressed: () {
                    mCallback.onPressedNegativeButton();
                  },
                  child: Text(negativeButtonName))
            ],
          );
        });
  }
}
