import 'package:flutter/material.dart';
import 'package:givison/src/constants/colors.dart';
import 'package:givison/src/constants/size.dart';

class TOutlinedButtonTheme{
    TOutlinedButtonTheme._();

    static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
      style:OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(),
                  foregroundColor: tSecondaryColor,
                  side: BorderSide(color: tSecondaryColor),
                  padding: EdgeInsets.symmetric(vertical: tButtonHeight)
                ),
    );

    static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
      style:OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(),
                  foregroundColor: tWhiteColor,
                  side: BorderSide(color: tWhiteColor),
                  padding: EdgeInsets.symmetric(vertical: tButtonHeight)
                ),
    );
}