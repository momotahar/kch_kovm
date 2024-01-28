// ignore: file_names
import 'package:flutter/material.dart';

buildStyle(Color col, double width, double height) {
  return ElevatedButton.styleFrom(
      backgroundColor: col,
      fixedSize:  Size(width, height),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)));
}
