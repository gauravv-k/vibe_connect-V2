import 'package:flutter/widgets.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;

  static double referenceWidth = 375.0; // e.g., iPhone X width
  static double referenceHeight = 812.0; // e.g., iPhone X height

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / referenceWidth;
    blockSizeVertical = screenHeight / referenceHeight;
  }

  static double scaleWidth(double width) => width * (screenWidth / referenceWidth);
  static double scaleHeight(double height) => height * (screenHeight / referenceHeight);
  static double scaleText(double fontSize) => fontSize * (screenWidth / referenceWidth);
}

extension SizeExtension on num {
  double get w => SizeConfig.scaleWidth(toDouble());
  double get h => SizeConfig.scaleHeight(toDouble());
  double get sp => SizeConfig.scaleText(toDouble());
} 