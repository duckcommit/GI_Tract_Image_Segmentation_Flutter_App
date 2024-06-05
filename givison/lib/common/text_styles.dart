import 'package:flutter/material.dart';
import 'package:givison/common/colors.dart';

class TextStyles{
  static const TextStyle whiteTitle = TextStyle(
    color: primaryWhite,
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle whiteSubTitle = TextStyle(
    color: secondaryWhite,
    fontSize: 20.0,
  );

  static const TextStyle blackTitle = TextStyle(
    color: primaryBlack,
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle blackSubTitle = TextStyle(
    color: secondaryBlack,
    fontSize: 20.0,
  );

  static const TextStyle loginButton = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20.0,
  );

  static const TextStyle whiteloginLink = TextStyle(
    color: secondaryWhite,
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle blackloginLink = TextStyle(
    color:secondaryBlack,
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle whiteloginLinkHighlighted = TextStyle(
    fontSize: 15,
    color: primaryWhite,
    decoration: TextDecoration.underline,
    decorationColor: primaryWhite,
    decorationThickness: 2.0,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle blackloginLinkHighlighted = TextStyle(
    fontSize: 15,
    color: primaryBlack,
    decoration: TextDecoration.underline,
    decorationColor: primaryBlack,
    decorationThickness: 2.0,
    fontWeight: FontWeight.bold,
  );
}
