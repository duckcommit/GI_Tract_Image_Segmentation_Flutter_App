import 'package:flutter/material.dart';
import 'package:givison/src/constants/colors.dart';
import 'package:givison/src/constants/size.dart';

class TElevatedButtonTheme{
    TElevatedButtonTheme._();

    static final lightElevatedButtonTheme = ElevatedButtonThemeData(
      style:OutlinedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(),
                  foregroundColor: tWhiteColor,
                  backgroundColor: tSecondaryColor,
                  side: BorderSide(color: tSecondaryColor),
                  padding: EdgeInsets.symmetric(vertical: tButtonHeight)
                ),
    );

    static final darkElevatedButtonTheme = ElevatedButtonThemeData(
      style:OutlinedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(),
                  foregroundColor: tSecondaryColor,
                  backgroundColor: tWhiteColor,
                  side: BorderSide(color: tSecondaryColor),
                  padding: EdgeInsets.symmetric(vertical: tButtonHeight)
                ),
    );
}