import 'package:flutter/material.dart';
import 'package:kch_kovm/tap_bar.dart';


Widget homeButton(context, String text) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Text(text),
      IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const TapBar()),
                (route) => false);
          },
          icon: const Icon(Icons.home, color: Colors.white,))
    ],
  );
}
