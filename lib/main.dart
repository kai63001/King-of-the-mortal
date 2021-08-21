import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Motal Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Motal Game'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final data = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GestureDetector(
        onPanUpdate: (detail) {
          int sensitivity = 8;
          print(detail.delta.dy);
          if (detail.delta.dx > sensitivity) {
            print("right");
          } else if (detail.delta.dx < -sensitivity) {
            print("left");
          }
          if (detail.delta.dy > sensitivity ) {
            print("down");
          }else  if (detail.delta.dy < -sensitivity){
            print("up");
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Center(
            child: GridView.count(
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              crossAxisCount: 5,
              physics: NeverScrollableScrollPhysics(),
              children: [for (var item in data) cardBoom()],
            ),
          ),
        ),
      ),
    );
  }

  Container cardBoom() {
    return Container(
        decoration: BoxDecoration(color: Colors.blue), child: Text("romeo"));
  }
}
