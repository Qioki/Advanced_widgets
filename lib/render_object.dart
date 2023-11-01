import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/*
4. Используя renderObject, создайте виджет, который каким-либо образом декорирует текст 
(добавляет к нему тень, эффекты). 
Используйте такой текст в приложении.
*/

class Text2 extends SingleChildRenderObjectWidget {
  const Text2(
    this.text, {
    super.key,
    super.child,
  });

  final String text;

  @override
  RenderText createRenderObject(BuildContext context) {
    return RenderText(text: text);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderText renderObject) {
    renderObject.text = text;
  }
}

class RenderText extends RenderProxyBox {
  String text;

  RenderText({required this.text, RenderBox? child}) : super(child);

  @override
  void paint(PaintingContext context, Offset offset) {
    TextPainter(
      text: TextSpan(
          text: text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 8,
          )),
      textDirection: TextDirection.ltr,
    )
      ..layout(maxWidth: 200)
      ..paint(context.canvas, offset.translate(-25, 0));

    TextPainter(
      text: TextSpan(
          text: text,
          style: const TextStyle(
            color: Color.fromARGB(100, 62, 36, 209),
            fontSize: 8,
          )),
      textDirection: TextDirection.ltr,
    )
      ..layout(maxWidth: 200)
      ..paint(context.canvas, offset.translate(-24, 1));
  }
}
