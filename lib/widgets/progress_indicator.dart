
import 'package:flutter/material.dart';

Widget buildProgressIndicator() {
  return const Align(
      alignment: Alignment.topCenter,
      child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.orange)));
}