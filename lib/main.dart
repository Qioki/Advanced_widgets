import 'package:advanced_widgets/theme.dart';
import 'package:advanced_widgets/weather_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

final themeModel = ThemeModel();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      themeModel: themeModel,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => WeatherNotifier(),
          )
        ],
        child: Builder(builder: (context) {
          return MaterialApp(
            theme: ThemeProvider.of(context)!.themeModel.currentTheme,
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              appBar: AppBar(
                title: const Text('My App'),
                actions: [
                  Switch(
                    value: ThemeProvider.of(context)!.themeModel.isLightTheme,
                    onChanged: (v) => setState(
                      () => ThemeProvider.of(context)!.themeModel.toggleTheme(),
                    ),
                  ),
                ],
              ),
              body: const Center(
                child: HomePage(),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        children: [
          Text(
            '${ThemeProvider.of(context)!.themeModel.isLightTheme ? 'Light' : 'Dark'} Theme',
          ),
          Slider(
              value: context.watch<WeatherNotifier>().weatherState,
              onChanged: context.read<WeatherNotifier>().setWeatherState),
          Row(
            children: [
              const Text('Mini widget: '),
              Switch(
                  value: context.watch<WeatherNotifier>().miniWidget,
                  onChanged: context.read<WeatherNotifier>().switchMiniWidget),
            ],
          ),
          AnimatedCloudWidget(
              weatherState: context.watch<WeatherNotifier>().weatherState,
              miniWidget: context.watch<WeatherNotifier>().miniWidget),
        ],
      ),
    );
  }
}
