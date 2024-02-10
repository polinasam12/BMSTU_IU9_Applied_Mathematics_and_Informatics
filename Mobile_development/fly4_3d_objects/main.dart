import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Cube',
      theme: ThemeData.dark(),
      home: MyHomePage(title: 'Flutter Cube Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  var _catetA = 100.0;
  var _catetB = 100.0;
  Color selectedColor = Colors.teal;
  double r1 = 4.0;
  double r2 = 4.0;
  double r3 = 10000;

  late Scene _scene;
  Object? _cube;
  late AnimationController _controller;


  final Object cube1 = Object(
    scale: Vector3(3.0, 3.0, 3.0),
    position: Vector3(5.0, 0.0, 0.0)..scale(3),
    fileName: 'assets/stone/stone.obj',
  );

  final Object cube2 = Object(
    scale: Vector3(3.0, 3.0, 3.0),
    position: Vector3(-5.0, 0.0, 0.0)..scale(3),
    fileName: 'assets/stone/stone.obj',
  );

  // double _xSliderValue = 0;  // Initial value of slider

  void _onSceneCreated(Scene scene) {
    _scene = scene;
    scene.camera.position.z = 50;

    _cube = Object(
        // scale: Vector3(3.0, 3.0, 3.0),
        // position: Vector3(0.0, 0.0, 0.0)..scale(3),
        // fileName: 'assets/stone/stone.obj',
        // backfaceCulling: false
        );
    final int samples = 2;
    final double radius = 3;
    final double offset = 2 / samples;
    final double increment = 3;

    _cube!.add(cube1);

    _cube!.add(cube2);

    scene.world.add(_cube!);
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: Duration(milliseconds: r3.toInt()), vsync: this)
      ..addListener(() {
        if (_cube != null) {
          _cube!.rotation.y = _controller.value * 360;
          _cube!.updateTransform();
          _scene.update();
        }
      })
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Cube(
              onSceneCreated: _onSceneCreated,
            ),
          ),
          Slider(
            min: 1.0,
            max: 10.0,
            label: 'Scale: ${r1.toStringAsFixed(2)}',  // Display scale value on the slider
            value: r1,
            onChanged: (value) {
              setState(() {
                r1 = value;
                cube1.scale.setValues(r1, r1, r1);  // Update scale of each cube
                cube1.updateTransform();
              });
            },
          ),
          Slider(
            min: 1.0,
            max: 10.0,
            label: 'Scale: ${r2.toStringAsFixed(2)}',  // Display scale value on the slider
            value: r2,
            onChanged: (value) {
              setState(() {
                r2 = value;
                cube2.scale.setValues(r2, r2, r2);  // Update scale of each cube
                cube2.updateTransform();
              });
            },
          ),

          Slider(
            min: 100,
            max: 10000,
            label: 'Rotation Speed',
            value: r3,
            onChanged: (value) {
              setState(() {
                r3 = value;
                _controller.duration = Duration(milliseconds: r3.toInt());
                _controller.reset();
                _controller.repeat();
              });
            },
          ),

        ],
      ),
    );
  }
}
