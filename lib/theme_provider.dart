// we use provider to manage the app state

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:productivity_app/helpers/custom_colors.dart';

class ThemeProvider with ChangeNotifier {
  bool isLightTheme;

  ThemeProvider({required this.isLightTheme});

  // the code below is to manage the status bar color when the theme changes
  getCurrentStatusNavigationBarColor() {
    if (isLightTheme) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: primaryColor,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFFFFFFFF),
        systemNavigationBarIconBrightness: Brightness.dark,
      ));
    } else {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFF26242e),
        systemNavigationBarIconBrightness: Brightness.light,
      ));
    }
  }

  // use to toggle the theme
  toggleThemeData() async {
    final settings = await Hive.openBox('settings');
    settings.put('isLightTheme', !isLightTheme);
    isLightTheme = !isLightTheme;
    getCurrentStatusNavigationBarColor();
    notifyListeners();
  }

  // Global theme data we are always check if the light theme is enabled #isLightTheme
  ThemeData themeData() {
    Map<int, Color> colorCodes = {
      50: const Color.fromRGBO(147, 205, 72, .1),
      100: const Color.fromRGBO(147, 205, 72, .2),
      200: const Color.fromRGBO(147, 205, 72, .3),
      300: const Color.fromRGBO(147, 205, 72, .4),
      400: const Color.fromRGBO(147, 205, 72, .5),
      500: const Color.fromRGBO(147, 205, 72, .6),
      600: const Color.fromRGBO(147, 205, 72, .7),
      700: const Color.fromRGBO(147, 205, 72, .8),
      800: const Color.fromRGBO(147, 205, 72, .9),
      900: const Color.fromRGBO(147, 205, 72, 1),
    };

    MaterialColor primaryColor =
        MaterialColor(0xFF148F77, colorCodes); //primaryColor
    MaterialColor secondaryColor =
        MaterialColor(0x117A65, colorCodes); //secondary light shade
    MaterialColor darkColor =
        MaterialColor(0xFF283747, colorCodes); //secondary light shade
    MaterialColor redColor = MaterialColor(0xFFC70039, colorCodes);
    return ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primarySwatch: primaryColor,
      primaryColor: primaryColor,
      brightness: isLightTheme ? Brightness.light : Brightness.dark,
      backgroundColor:
          isLightTheme ? const Color(0xFFFFFFFF) : const Color(0xFF26242e),
      scaffoldBackgroundColor:
          isLightTheme ? const Color(0xFFFFFFFF) : const Color(0xFF212227),
    );
  }

  // Theme mode to display unique properties not cover in theme data
  ThemeColor themeMode() {
    return ThemeColor(
      gradient: [
        if (isLightTheme) ...[const Color(0xDDFF0080), const Color(0xDDFF8C00)],
        if (!isLightTheme) ...[const Color(0xFF8983F7), const Color(0xFFA3DAFB)]
      ],
      iconColor: isLightTheme ? Color(0xFF000000) : Color(0xFFFFFFFF),
      textColor: isLightTheme ? Color(0xFF000000) : Color(0xFFFFFFFF),
      toggleButtonColor: isLightTheme ? Color(0xFFFFFFFF) : Color(0xFf34323d),
      toggleBackgroundColor:
          isLightTheme ? Color(0xFFe7e7e8) : Color(0xFF222029),
      shadow: [
        if (isLightTheme)
          const BoxShadow(
              color: Color(0xFFd8d7da),
              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(0, 5)),
        if (!isLightTheme)
          const BoxShadow(
              color: Color(0x66000000),
              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(0, 5))
      ],
    );
  }
}

// A class to manage specify colors and styles in the app not supported by theme data
class ThemeColor {
  List<Color> gradient;
  Color? backgroundColor;
  Color toggleButtonColor;
  Color toggleBackgroundColor;
  Color textColor;
  Color iconColor;
  List<BoxShadow> shadow;

  ThemeColor({
    required this.gradient,
    this.backgroundColor,
    required this.toggleBackgroundColor,
    required this.toggleButtonColor,
    required this.textColor,
    required this.shadow,
    required this.iconColor,
  });
}
