import 'package:flutter/material.dart';
import 'package:investtech_app/const/colors.dart';

getSmallTextStyle() {
  return const TextStyle(fontSize: 12, color: Color(ColorHex.DARK_GREY));
}

getSmallestTextStyle() {
  return const TextStyle(fontSize: 10, color: Color(ColorHex.DARK_GREY));
}

getSmallBoldTextStyle() {
  return const TextStyle(
      fontSize: 12,
      color: Color(ColorHex.DARK_GREY),
      fontWeight: FontWeight.bold);
}

getHomePageHeadingTextStyle() {
  return const TextStyle(
      color: Color(ColorHex.GREY), fontSize: 20, fontWeight: FontWeight.bold);
}

getEvaluationTextStyle() {
  return const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Color(ColorHex.DARK_GREY));
}

getHomePageSeeAllTextStyle() {
  return const TextStyle(
      color: Color(ColorHex.ACCENT_COLOR),
      fontSize: 13,
      fontWeight: FontWeight.bold);
}

getBoldTextStyle() {
  return const TextStyle(
      fontWeight: FontWeight.bold, color: Color(ColorHex.DARK_GREY));
}

getDescriptionTextStyle() {
  return const TextStyle(fontSize: 13, color: Color(ColorHex.DARK_GREY));
}

getNameAndTickerTextStyle() {
  return const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: Color(ColorHex.DARK_GREY));
}
