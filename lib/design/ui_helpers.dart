import 'dart:math';

import 'package:flutter/material.dart';

import 'app_font.dart';
import 'colors.dart';

Widget verticalSpace(double height) => SizedBox(height: height);

double screenWidth(BuildContext context) => MediaQuery.sizeOf(context).width;
double screenHeight(BuildContext context) => MediaQuery.sizeOf(context).height;

double screenHeightFraction(BuildContext context,
        {int dividedBy = 1, double offsetBy = 0, double max = 3000}) =>
    min((screenHeight(context) - offsetBy) / dividedBy, max);

double screenWidthFraction(BuildContext context,
        {int dividedBy = 1, double offsetBy = 0, double max = 3000}) =>
    min((screenWidth(context) - offsetBy) / dividedBy, max);

double halfScreenWidth(BuildContext context) =>
    screenWidthFraction(context, dividedBy: 2);

double thirdScreenWidth(BuildContext context) =>
    screenWidthFraction(context, dividedBy: 3);

double getResponsiveHorizontalSpaceMedium(BuildContext context) =>
    screenWidthFraction(context, dividedBy: 10);

// TODO: Move this into the responsive builder package as responsive font size helpers
double getResponsiveSmallFontSize(BuildContext context) =>
    getResponsiveFontSize(context, fontSize: 12, max: 14);

double getResponsiveMediumFontSize(BuildContext context) =>
    getResponsiveFontSize(context, fontSize: 17, max: 18);

double getResponsiveLargeFontSize(BuildContext context) =>
    getResponsiveFontSize(context, fontSize: 21, max: 31);

double getResponsiveExtraLargeFontSize(BuildContext context) =>
    getResponsiveFontSize(context, fontSize: 25);

double getResponsiveMassiveFontSize(BuildContext context) =>
    getResponsiveFontSize(context, fontSize: 178);

double getResponsiveFontSize(
  BuildContext context, {
  required double fontSize,
  double? max,
}) {
  max ??= 100;
  var responsiveSize =
      min(screenWidthFraction(context, dividedBy: 10) * (fontSize / 100), max);
  // print(
  //     '*********** RESPONSIVE SIZE: fontSize:$fontSize responsiveSize$responsiveSize max:$max');
  return responsiveSize;
}

final kDecor = InputDecoration(
  counterStyle: const TextStyle(
    color: AppTheme.textSecColor,
  ),
  errorStyle: const TextStyle(
    fontSize: AppFont.caption,
  ),
  filled: true,
  fillColor: AppTheme.mainAppColor,
  contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(14.0),
  ),
  focusedBorder: const OutlineInputBorder(
    borderSide: BorderSide(color: AppTheme.primaryAppColor, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(14.0)),
  ),
  hintStyle: const TextStyle(
    fontSize: AppFont.body,
    fontWeight: FontWeight.w400,
    color: AppTheme.textSecColor,
  ),
);
