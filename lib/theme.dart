import 'package:flutter/material.dart';

/*
1. Главный цвет приложения должен зависеть от текущего профиля (Цвет header, кнопок, заголовков и так далее). 
Реализовать эту возможность нужно с помощью Inherited Widget. 
Реализуйте возможность смены профиля с мгновенной сменой основного цвета приложения. Количество цветов — на ваш выбор.
*/

final lightTheme = ThemeData.light().copyWith(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light().copyWith(
    primary: Colors.red,
  ),
);

final darkTheme = ThemeData.dark().copyWith(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark().copyWith(
    primary: Colors.blue,
  ),
);

class ThemeModel {
  bool isLightTheme = true;
  ThemeData currentTheme = lightTheme;

  void toggleTheme() {
    isLightTheme = !isLightTheme;
    currentTheme = isLightTheme ? lightTheme : darkTheme;
  }
}

class ThemeProvider extends InheritedWidget {
  final ThemeModel themeModel;

  const ThemeProvider({
    Key? key,
    required this.themeModel,
    required Widget child,
  }) : super(key: key, child: child);

  static ThemeProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeProvider>();
  }

  @override
  bool updateShouldNotify(ThemeProvider oldWidget) {
    return true;
    // return oldWidget.themeModel.currentTheme != themeModel.currentTheme;
  }
}
