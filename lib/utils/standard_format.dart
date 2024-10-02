import 'dart:io';

import 'package:flutter/material.dart';

import '../design/colors.dart';

class StdFormat extends StatelessWidget {
  final Widget widget;
  final AppBar? appBar;
  final bool? showKeyboard;
  final FloatingActionButton? floatingActionButton;
  const StdFormat({super.key, required this.widget, this.appBar, this.showKeyboard, this.floatingActionButton});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Scaffold(
        resizeToAvoidBottomInset: showKeyboard,
        extendBodyBehindAppBar: true,
        floatingActionButton: floatingActionButton,
        backgroundColor: AppTheme.mainAppColor,
        appBar: appBar,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: AppTheme.mainAppColor,
          child: SafeArea(
            child: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                child: widget,
              ),
            ),
          ),
        ),
      );
    } else {
      return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: showKeyboard,
          backgroundColor: AppTheme.mainAppColor,
          floatingActionButton: floatingActionButton,
          appBar: appBar,
          body: Container(
            height: double.infinity,
            width: double.infinity,
            color: AppTheme.mainAppColor,
            child: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                child: widget,
              ),
            ),
          ),
        ),
      );
    }
  }
}
