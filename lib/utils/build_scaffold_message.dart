// ignore_for_file: file_names

import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> buildScaffoldMessage(BuildContext context, message){
  return   ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.black),),
      backgroundColor: Colors.greenAccent,
    )
  );
}