import 'dart:math';
import 'package:advanced_widgets/render_object.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/*
2.Реализуйте виджет, который представляет собой иконку текущей погоды. 
Данный виджет имеет два крайних состояния: очень облачно с дождём и ясно. 
Виджет имеет один (или более) обязательный параметр, который отвечает за его состояние. 
К примеру, он может принимать число от 0 до 1 и, в зависимости от него, выводить соответствующую иконку, как в примере ниже (максимально похоже).
Когда значение облачности равно нулю, должно выводиться солнце. Если значение 0.5 — выводится облако, которое закрывает солнце. 
При значении 1 выводится сильная облачность и дождь. 
Картинки должны плавно перетекать одна в другую: если значение облачности равно 0.2, то облако начинает проявляться и обретать непрозрачность. 
Таким образом будет возможность добавить WeatherIndicator(0.8) в приложение, что и нужно сделать.

3. Реализуйте возможность масштабирования погоды. 
Когда пользователь нажимает на иконку погоды, она увеличивается и появляется больше текстовой информации.
*/

class WeatherNotifier with ChangeNotifier {
  double get weatherState => _weatherState;
  double _weatherState = 0.6;
  bool get miniWidget => _miniWidget;
  bool _miniWidget = true;

  void setWeatherState(double value) {
    _weatherState = value;
    notifyListeners();
  }

  void switchMiniWidget(bool? value) {
    _miniWidget = value ?? !_miniWidget;
    notifyListeners();
  }
}

class AnimatedCloudWidget extends StatefulWidget {
  final double weatherState;
  final bool miniWidget;

  const AnimatedCloudWidget(
      {Key? key, required this.weatherState, this.miniWidget = true})
      : super(key: key);

  @override
  _AnimatedCloudWidgetState createState() => _AnimatedCloudWidgetState();
}

class _AnimatedCloudWidgetState extends State<AnimatedCloudWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late ColorTween _colorTween;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _animation =
        Tween<double>(begin: 0.0, end: 1).animate(_animationController);
    _animationController.repeat(reverse: true);

    _colorTween = ColorTween(begin: Colors.white, end: Colors.black);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: widget.miniWidget ? 1 : 3.5,
      transformHitTests: true,
      alignment: Alignment.topCenter,
      child: GestureDetector(
        onTap: () {
          context.read<WeatherNotifier>().switchMiniWidget(null);
        },
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // SUN
                const Icon(
                  Icons.circle,
                  color: Colors.orangeAccent,
                  size: 40,
                ),
                // RAIN
                Visibility(
                  visible: widget.weatherState > 0.6,
                  child: Transform(
                    alignment: Alignment.center,
                    transformHitTests: true,
                    transform: Matrix4.identity()
                      ..rotateZ(1.7)
                      ..translate(28.0),
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Transform(
                          transform: Matrix4.identity()
                            ..translate(0.0, Random().nextDouble() * 40 - 25)
                            ..scale(Random().nextDouble(),
                                1 + _animation.value * 0.2),
                          transformHitTests: true,
                          alignment: Alignment.center,
                          child: child,
                        );
                      },
                      child: SizedBox(
                        width: 24,
                        child: Divider(
                          color: const Color.fromARGB(228, 0, 136, 255),
                          thickness: max(
                              widget.weatherState * widget.weatherState * 2 -
                                  0.25,
                              0.01),
                        ),
                      ),
                    ),
                  ),
                ),
                // CLOUD
                Transform(
                  alignment: Alignment.center,
                  transformHitTests: true,
                  transform: Matrix4.identity()
                    ..translate(0.0, 12 - widget.weatherState * 12)
                    ..scale(min(1.2, 1.8 * widget.weatherState)),
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform(
                        transform: Matrix4.identity()
                          ..translate(-_animation.value * 5 + 5)
                          ..scale(0.85 + 0.15 * _animation.value,
                              1 - 0.2 * _animation.value),
                        transformHitTests: true,
                        alignment: Alignment.center,
                        child: child,
                      );
                    },
                    child: Icon(
                      Icons.cloud,
                      color: _colorTween.lerp(max(0,
                          widget.weatherState * widget.weatherState * 2 - 1)),
                      size: 60,
                      shadows: const [
                        Shadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(2, 4))
                      ],
                    ),
                  ),
                ),
                // LIGHTING
                Visibility(
                  visible: widget.weatherState > 0.85,
                  child: Transform(
                    alignment: Alignment.center,
                    transformHitTests: true,
                    transform: Matrix4.identity()..translate(0.0, 15.0),
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Transform(
                          transform: Matrix4.identity()
                            ..translate(Random().nextDouble() * 20 - 20,
                                _animation.value * 15)
                            ..scale(_animation.value *
                                _animation.value *
                                _animation.value),
                          transformHitTests: true,
                          alignment: Alignment.center,
                          child: child,
                        );
                      },
                      child: const Icon(
                        Icons.flash_on,
                        size: 30,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: !widget.miniWidget,
              child: SizedBox(
                height: 300,
                child: Text2(widget.weatherState <= 0.3
                    ? 'Ясно'
                    : widget.weatherState <= 0.6
                        ? 'Облачно'
                        : widget.weatherState <= 0.85
                            ? 'Дождь'
                            : 'Сильный дождь'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
