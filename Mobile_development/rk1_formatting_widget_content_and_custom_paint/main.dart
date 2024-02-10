import 'package:flutter/material.dart';
import 'dart:ui' as ui;

void main() {
  runApp(MyApp());
}

class Vertex {
  double x;
  double y;
  double z;

  Vertex(this.x, this.y, this.z);
}

class TriangleProjection extends StatefulWidget {
  @override
  _TriangleProjectionState createState() => _TriangleProjectionState();
}

class _TriangleProjectionState extends State<TriangleProjection> {
  final vertex1Controller = TextEditingController();
  final vertex2Controller = TextEditingController();
  final vertex3Controller = TextEditingController();
  List<Vertex> vertices = [];

  @override
  void initState() {
    super.initState();
    vertex1Controller.text = "0,0,0";
    vertex2Controller.text = "100,0,0";
    vertex3Controller.text = "0,100,0";
    _updateVertices();
  }

  void _updateVertices() {
    vertices.clear();
    vertices.add(_parseVertex(vertex1Controller.text));
    vertices.add(_parseVertex(vertex2Controller.text));
    vertices.add(_parseVertex(vertex3Controller.text));
    setState(() {});
  }

  Vertex _parseVertex(String vertexString) {
    List<String> values = vertexString.split(",");
    double x = double.parse(values[0]);
    double y = double.parse(values[1]);
    double z = double.parse(values[2]);
    return Vertex(x, y, z);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Triangle Projection'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Vertex 1 (x,y,z)'),
                controller: vertex1Controller,
                onChanged: (_) => _updateVertices(),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Vertex 2 (x,y,z)'),
                controller: vertex2Controller,
                onChanged: (_) => _updateVertices(),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Vertex 3 (x,y,z)'),
                controller: vertex3Controller,
                onChanged: (_) => _updateVertices(),
              ),
              SizedBox(height: 16.0),
              Text(
                'Projected Triangle:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Container(
                width: 300,
                height: 300,
                child: CustomPaint(
                  painter: TrianglePainter(vertices),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  List<Vertex> vertices;

  TrianglePainter(this.vertices);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(vertices[0].x, vertices[0].y);
    path.lineTo(vertices[1].x, vertices[1].y);
    path.lineTo(vertices[2].x, vertices[2].y);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) => true;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TriangleProjection(),
    );
  }
}