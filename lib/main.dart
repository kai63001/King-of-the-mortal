import 'dart:async';

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
    {
      "index": 0,
      "boom": false,
    },
    {
      "index": 1,
      "boom": false,
    },
    {
      "index": 2,
      "boom": false,
    },
    {
      "index": 3,
      "boom": false,
    },
    {
      "index": 4,
      "boom": false,
    },
    {
      "index": 5,
      "boom": false,
    },
    {
      "index": 6,
      "boom": false,
    },
    {
      "index": 7,
      "boom": false,
    },
    {
      "index": 8,
      "boom": false,
    },
    {
      "index": 9,
      "boom": false,
    },
    {
      "index": 10,
      "boom": false,
    },
    {
      "index": 11,
      "boom": false,
    },
    {
      "index": 12,
      "boom": false,
    },
    {
      "index": 13,
      "boom": false,
    },
    {
      "index": 14,
      "boom": false,
    },
    {
      "index": 15,
      "boom": false,
    },
    {
      "index": 16,
      "boom": false,
    },
    {
      "index": 17,
      "boom": false,
    },
    {
      "index": 18,
      "boom": false,
    },
    {
      "index": 19,
      "boom": false,
    },
    {
      "index": 20,
      "boom": false,
    },
    {
      "index": 21,
      "boom": false,
    },
    {
      "index": 22,
      "boom": false,
    },
    {
      "index": 23,
      "boom": false,
    },
    {
      "index": 24,
      "boom": false,
    },
    {
      "index": 25,
      "boom": false,
    },
    {
      "index": 26,
      "boom": false,
    },
    {
      "index": 27,
      "boom": false,
    },
    {
      "index": 28,
      "boom": false,
    },
    {
      "index": 29,
      "boom": false,
    },
  ];
  
  void startGame() {
    print("game start");
    setState(() {
      gameStart = true;
    });
    Timer.periodic(new Duration(seconds: 1), (timer) {
      // debugPrint(timer.tick.toString());
      setState(() {
        onCheckPress = false;
      });
    });
  }

  bool gameStart = false;

  bool onCheckPress = true;
  int characterPositionX = 0;
  int characterPositionY = 0;

  // การขยับของผู้เล่น
  void playerMovement(detail) {
    int sensitivity = 8;
    print(onCheckPress);
    if (onCheckPress == true) {
      return;
    }
    print(characterPositionX);
    if (detail.delta.dx > sensitivity && characterPositionX < 162) {
      print("right");
      setState(() {
        characterPositionX += 81;
        onCheckPress = true;
      });
    } else if (detail.delta.dx < -sensitivity && characterPositionX > -162) {
      print("left");
      setState(() {
        characterPositionX -= 81;
        onCheckPress = true;
      });
    } else if (detail.delta.dy > sensitivity && characterPositionY < 162) {
      setState(() {
        characterPositionY += 81;
        onCheckPress = true;
      });
      print("down");
    } else if (detail.delta.dy < -sensitivity && characterPositionY > -162) {
      print("up");
      setState(() {
        characterPositionY -= 81;
        onCheckPress = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("MOTAL GAME"),
        elevation: 0,
      ),
      body: GestureDetector(
        onPanUpdate: (detail) {
          playerMovement(detail);
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                child: Container(
                  width: 400,
                  height: 400,
                  child: GridView.count(
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    crossAxisCount: 5,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      // ทำการ loop card ระเบิด
                      for (var item in data) cardBoom(item)
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              child: Container(
                  transform: Matrix4.translationValues(-25.0, -18.0, 0.0),
                  decoration: BoxDecoration(color: Colors.red),
                  width: 50,
                  height: 50,
                  child: Text("")),
              left: characterPositionX + (size.width / 2),
              top: characterPositionY + (size.height * 0.45),
            ),
            !gameStart
                ? Container(
                    width: size.width,
                    height: size.height,
                    decoration: BoxDecoration(color: Colors.black),
                    child: Center(
                        child: GestureDetector(
                      onTap: () {
                        startGame();
                      },
                      child: Container(
                          decoration: BoxDecoration(color: Colors.red),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "START GAME",
                              style: TextStyle(color: Colors.white),
                            ),
                          )),
                    )))
                : Text(""),
          ],
        ),
      ),
    );
  }

  // widget card ระเบิด
  Container cardBoom(item) {
    return Container(
        decoration: BoxDecoration(color: Colors.blue), child: Text("${item['index']}"));
  }
}
