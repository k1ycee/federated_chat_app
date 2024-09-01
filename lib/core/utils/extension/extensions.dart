import 'dart:math';
import 'package:dartx/dartx.dart';
import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:matrix_project/core/services/navigation_service.dart';

extension CustomContext on BuildContext {
  double screenHeight([double percent = 1]) =>
      MediaQuery.of(this).size.height * percent;

  double screenWidth([double percent = 1]) =>
      MediaQuery.of(this).size.width * percent;
}

extension StringExtensions on String {
  String get allInCaps => toUpperCase();
  String get capitalizeFirstofEach =>
      length > 1 ? split(' ').map((str) => str.capitalize).join(' ') : this;

  void showInfo({
    FlashPosition? position,
    Color? color,
    Color? textColor,
  }) async =>
      await navigator.context.showFlash(
        duration: const Duration(seconds: 3),
        builder: (context, _) {
          return showFlashBar(
            str: this,
            controller: _,
            textColor: textColor ?? Colors.black,
            position: position ?? FlashPosition.top,
            backgroundColor: color ?? Colors.orangeAccent,
          );
        },
      );

  void showError({
    FlashPosition? position,
    Duration? duration,
  }) async {
    // if (contains('Unauthenticated') || toLowerCase().contains('not found')) {
    //   return;
    // }

    await navigator.context.showFlash(
      duration: duration ?? const Duration(seconds: 5),
      builder: (context, _) {
        return showFlashBar(
          str: this,
          controller: _,
          textColor: Colors.white,
          position: position ?? FlashPosition.top,
          backgroundColor: Colors.red,
        );
      },
    );
  }

  FlashBar showFlashBar({
    required FlashController<dynamic> controller,
    required String str,
    Color? textColor,
    Color? backgroundColor,
    Curve? forwardAnimationCurve,
    Curve? reverseAnimationCurve,
    FlashPosition? position,
  }) {
    return FlashBar(
      controller: controller,
      position: position ?? FlashPosition.bottom,
      backgroundColor: backgroundColor ?? Colors.deepOrange,
      behavior: FlashBehavior.floating,
      forwardAnimationCurve:
          forwardAnimationCurve ?? Curves.fastLinearToSlowEaseIn,
      reverseAnimationCurve: reverseAnimationCurve ?? Curves.fastOutSlowIn,
      margin: const EdgeInsets.all(12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      content: Text(
        str,
        style: GoogleFonts.lato(
          fontSize: 16,
          color: textColor ?? Colors.white,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

extension TimeTransformation on DateTime {
  String get timeOfDay {
    String formattedTime = DateFormat('HH:mm').format(toUtc());
    return formattedTime;
  }
}

extension Validator on String {
  bool get isValidEmail {
    return isNotEmpty &&
        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9-]+\.[a-zA-Z]+")
            .hasMatch(this);
  }

  bool get isValidPassword {
    return isNotEmpty && RegExp(r"^.{8,}$").hasMatch(this);
  }
}

extension WidgetUtilitiesX on Widget {
  /// Animated show/hide based on a test, with overrideable duration and curve.
  ///
  /// Applies [IgnorePointer] when hidden.
  Widget showIf(
    bool test, {
    Duration duration = const Duration(milliseconds: 350),
    Curve curve = Curves.easeInOut,
  }) =>
      AnimatedOpacity(
        opacity: test ? 1.0 : 0.0,
        duration: duration,
        curve: curve,
        child: IgnorePointer(
          ignoring: test == false,
          child: this,
        ),
      );

  /// Scale this widget by `scale` pixels.
  Widget scale([
    double scale = 0.0,
  ]) =>
      Transform.scale(
        scale: scale,
        child: this,
      );

  /// Transform this widget `x` or `y` pixels.
  Widget nudge({
    double x = 0.0,
    double y = 0.0,
  }) =>
      Transform.translate(
        offset: Offset(x, y),
        child: this,
      );

  /// Transform this widget `x` or `y` pixels.
  Widget rotate2({
    double angle = 0.0,
  }) =>
      Transform.rotate(
        angle: angle * pi / 180,
        child: this,
      );

  /// Rotate this widget by `x` `turns`
  Widget rotate({
    int turns = 0,
  }) =>
      RotatedBox(
        quarterTurns: turns,
        child: this,
      );

  /// Wrap this widget in a [SliverToBoxAdapter]
  ///
  /// If you need access to `key`, do not use this extension method.
  Widget get asSliver => SliverToBoxAdapter(child: this);

  /// Return this widget with a given [Brightness] applied to [CupertinoTheme]
  Widget withBrightness(
    BuildContext context, [
    Brightness? _brightness = Brightness.dark,
  ]) =>
      CupertinoTheme(
        data: CupertinoTheme.of(context).copyWith(
          brightness: _brightness,
        ),
        child: this,
      );

  /// Wraps this widget in [Padding]
  /// that matches [MediaQueryData.viewInsets.bottom]
  ///
  /// This makes the widget avoid the software keyboard.
  Widget withKeyboardAvoidance(BuildContext context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: this,
      );
}
