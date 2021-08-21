import 'dart:async';
import 'dart:math';

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
    }
  ];

  final genGame = ["right", "left", "up", "down"];

  List<int> genedGame = [];
  // index ไว้ แสดง quiz ใน array
  int index = 0;
  String template = "";

  bool gameStart = false;
  bool onCheckPress = true;

  int characterPositionX = 0;
  int characterPositionY = 0;
  // เดินไปกี่ครั้ง
  int step = 0;

  final _stickyKey = GlobalKey();

  void startGame() {
    print("game start");
    setState(() {
      gameStart = true;
    });
    generateGame();
  }

  // สร้าง ด่าน
  void generateGame() async {
    // สุ่มว่าจะให้เดินไปทางไหนเก็บเข้าไปใน array
    for (var i = 0; i < 2; i++) {
      genedGame.add(Random().nextInt(genGame.length - 1));
    }
    print(genedGame);

    // ทำการบอก player ว่าให้เดินไปทางไหนแล้วจำเอา
    for (var i = 0; i < genedGame.length; i++) {
      await Future.delayed(Duration(seconds: 1));
      print(i);
      setState(() {
        template = genGame[genedGame[index]].toString();
        index += 1;
      });
      await Future.delayed(Duration(seconds: 2));
      setState(() {
        template = "";
      });
      if (index == genedGame.length) {
        template = "GOGOGO";
        startMove();
      }
    }
  }

  void startMove() {
    setState(() {
      onCheckPress = false;
    });
  }

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
        checkBomb("right");
      });
    } else if (detail.delta.dx < -sensitivity && characterPositionX > -162) {
      print("left");
      setState(() {
        characterPositionX -= 81;
        onCheckPress = true;
        checkBomb("left");
      });
    } else if (detail.delta.dy > sensitivity && characterPositionY < 162) {
      print("down");
      setState(() {
        characterPositionY += 81;
        onCheckPress = true;
        checkBomb("down");
      });
    } else if (detail.delta.dy < -sensitivity && characterPositionY > -162) {
      print("up");
      setState(() {
        characterPositionY -= 81;
        onCheckPress = true;
        checkBomb("up");
      });
    }
  }

  void checkBomb(move) async {
    await Future.delayed(Duration(seconds: 1));
    print(move);
    print(genGame[genedGame[step]]);
    if (move == genGame[genedGame[step]]) {
      setState(() {
        template = "nice";
        step += 1;
      });
      if (step == genedGame.length) {
        setState(() {
          template = "let go ";
        });
        return;
      }
      startMove();
    } else {
      gameOver();
      setState(() {
        template = "noob";
      });
    }
  }

  void gameOver() {
    setState(() {
      gameStart = false;
      genedGame = [];
      index = 0;
      template = "";
      onCheckPress = true;
      characterPositionX = 0;
      characterPositionY = 0;
      step = 0;
    });
    print("game over");
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
            Positioned(
              child: Container(
                  width: size.width,
                  child:
                      gameStart ? Center(child: Text("$template")) : Text("")),
              top: (size.height * 0.05),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                child: Container(
                  width: 400,
                  height: 400,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      GridView.count(
                        key: _stickyKey,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        crossAxisCount: 5,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          // ทำการ loop card ระเบิด
                          for (var item in data) cardBoom(item)
                        ],
                      ),
                      Positioned(
                        child: Container(
                            transform:
                                Matrix4.translationValues(-25.0, -18.0, 0.0),
                            decoration: BoxDecoration(color: Colors.red),
                            width: 50,
                            height: 50,
                            child: Text("")),
                        left: characterPositionX +
                            (double.parse(
                                    _stickyKey.currentContext!.size!.width.toString()) *
                                0.32),
                        top: characterPositionY + (size.height * 0.52),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Positioned(
            //   child: Container(
            //       transform: Matrix4.translationValues(-25.0, -18.0, 0.0),
            //       decoration: BoxDecoration(color: Colors.red),
            //       width: 50,
            //       height: 50,
            //       child: Text("")),
            //   left: characterPositionX + (size.width / 2),
            //   top: characterPositionY + (size.height * 0.45),
            // ),
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
        decoration: BoxDecoration(color: Colors.blue),
        child: Text("${item['index']}"));
  }
}
