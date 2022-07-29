import 'package:flutter/material.dart';
import 'package:investtech_app/const/colors.dart';

getSmallTextStyle() {
  return const TextStyle(
    fontSize: 12,
  );
}

getSmallestTextStyle() {
  return const TextStyle(
    fontSize: 10,
  );
}

getSmallBoldTextStyle() {
  return const TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
}

getHomePageHeadingTextStyle() {
  return const TextStyle(
      fontSize: 25, fontWeight: FontWeight.bold, color: Color(ColorHex.GREY));
}

getEvaluationTextStyle() {
  return const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
}

getHomePageSeeAllTextStyle() {
  return const TextStyle(
      color: Color(ColorHex.ACCENT_COLOR),
      fontSize: 13,
      fontWeight: FontWeight.bold);
}

getBoldTextStyle() {
  return const TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
}

getDescriptionTextStyle() {
  return const TextStyle(
    fontSize: 14,
  );
}

getNameAndTickerTextStyle() {
  return const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );
}
