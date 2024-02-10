import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Custom Painter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyPainter(),
    );
  }
}

class MyPainter extends StatefulWidget {
  @override
  _MyPainterState createState() => _MyPainterState();
}

class _MyPainterState extends State<MyPainter> {
  var _catetA = 100.0;
  var _catetB = 100.0;
  Color selectedColor = Colors.teal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Triangle'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RadioListTile(
              title: Text('Red'),
              value: Colors.red,
              groupValue: selectedColor,
              onChanged: (value) {
                setState(() {
                  selectedColor = value!;
                });
              },
            ),
            RadioListTile(
              title: Text('Yellow'),
              value: Colors.yellow, //unique value
              groupValue: selectedColor ,
              onChanged: (value) {
                setState(() {
                  selectedColor = value!;
                });
              },
            ),
            RadioListTile(
              title: Text('Green'),
              value: Colors.green,
              groupValue: selectedColor,
              onChanged: (value) {
                setState(() {
                  selectedColor = value!;
                });
              },
            ),

            Expanded(
              child: CustomPaint(
                painter: ShapePainter(_catetA, _catetB, selectedColor),
                child: Container(),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text('Cathet A'),
            ),
            Slider(
              value: _catetA,
              min: - MediaQuery.of(context).size.height / 2,
              max: MediaQuery.of(context).size.height / 2,
              onChanged: (value) {
                setState(() {
                  _catetA = value;
                });
              },
            ),

            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text('Cathet B'),
            ),
            Slider(
              value: _catetB,
              min: - MediaQuery.of(context).size.width / 2,
              max: MediaQuery.of(context).size.width / 2,
              onChanged: (value) {
                setState(() {
                  _catetB = value;
                });
              },
            ),

          ],
        ),
      ),
    );
  }
}

// FOR PAINTING POLYGONS
class ShapePainter extends CustomPainter {

  final double catetA;
  final double catetB;
  final Color shapeColor;
  ShapePainter(this.catetA, this.catetB, this.shapeColor);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = shapeColor
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke; // добавил к окркжности

    var catA = catetA;
    var catB = catetB;
    var hypo = math.sqrt(math.pow(catA, 2) + math.pow(catB, 2));
    var rad = hypo / 2 ;

    var startAX = size.width / 2;
    var startAY = size.height / 2;
    Offset startA = Offset(startAX , startAY);
    var endAX = size.width / 2;
    var endAY = size.height / 2 - catA;
    Offset endA = Offset(endAX, endAY);
    canvas.drawLine(startA, endA, paint);

    var startBX = size.width / 2;
    var startBY = size.height / 2;
    Offset startB = Offset(startBX , startBY);
    var endBX = size.width / 2 + catB;
    var endBY = size.height / 2;
    Offset endB = Offset(endBX, endBY);
    canvas.drawLine(startB, endB, paint);

    canvas.drawLine(endA, endB, paint);

    Offset center = Offset((endAX + endBX) / 2, (endAY + endBY) / 2);
    canvas.drawCircle(center, rad, paint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
