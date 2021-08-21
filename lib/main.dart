import 'dart:async';
import 'dart:math';

import 'package:flip_card/flip_card.dart';
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

  double characterPositionX = 0;
  double characterPositionY = 0;
  // เดินไปกี่ครั้ง
  int step = 0;

  // resiponsive
  final _stickyKey = GlobalKey();
  late final RenderBox sizeGrid;
  double staticMoveX = 0.0;
  double staticMoveY = 0.0;

  //flip card
  var cardKeys = Map<int, GlobalKey<FlipCardState>>();
  GlobalKey<FlipCardState>? lastFlipped;

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
      genedGame.add(Random().nextInt(genGame.length));
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

  // การขยับของผู้เล่น โดยการสบัดนิ้ว (swipe)
  void playerMovement(detail) {
    int sensitivity = 6;
    // print(onCheckPress);
    if (onCheckPress == true) {
      return;
    }
    print(detail.delta.dy);
    if (detail.delta.dx > sensitivity && characterPositionX < 162) {
      // print("right");
      setState(() {
        characterPositionX += staticMoveX;
        onCheckPress = true;
        checkBomb("right");
      });
    } else if (detail.delta.dx < -sensitivity && characterPositionX > -162) {
      // print("left");
      setState(() {
        characterPositionX -= staticMoveX;
        onCheckPress = true;
        checkBomb("left");
      });
    } else if (detail.delta.dy > sensitivity && characterPositionY < 162) {
      print("down");
      setState(() {
        characterPositionY += staticMoveY;
        onCheckPress = true;
        checkBomb("down");
      });
    } else if (detail.delta.dy < -sensitivity && characterPositionY > -162) {
      print("up");
      setState(() {
        characterPositionY -= staticMoveY;
        onCheckPress = true;
        checkBomb("up");
      });
    }
  }

  void checkBomb(move) async {
    flipCard();
    await Future.delayed(Duration(seconds: 2));
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

  void flipCard() async {
    for (int i = 0; i < data.length; i++) {
      cardKeys[i]?.currentState?.toggleCard();
    }
    await Future.delayed(Duration(seconds: 1));
    for (int i = 0; i < data.length; i++) {
      cardKeys[i]?.currentState?.toggleCard();
    }
    return;
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
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  _afterLayout(_) {
    setState(() {
      sizeGrid = _stickyKey.currentContext!.findRenderObject() as RenderBox;
      staticMoveX = sizeGrid.size.width * 0.2;
      staticMoveY = sizeGrid.size.width * 0.2;
    });
    print(sizeGrid.size);
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
        onTap: () {
          print("tappp");
        },
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
                  key: _stickyKey,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      GridView.builder(
                        // แก้ grid ไม่ให้มัน scroll ซึงมันไม่ scroll อยู่แล้ว แกน y เลยไม่ทำงาน เห้อออ
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          cardKeys.putIfAbsent(
                              index, () => GlobalKey<FlipCardState>());
                          GlobalKey<FlipCardState>? thisCard = cardKeys[index];
                          return FlipCard(
                            flipOnTouch: false,
                            direction: FlipDirection.HORIZONTAL,
                            key: thisCard,
                            front: Container(
                              decoration:
                                  BoxDecoration(color: Colors.blueAccent),
                              child: Text('Front'),
                            ),
                            back: Container(
                              decoration: BoxDecoration(color: Colors.red),
                              child: Text('Back'),
                            ),
                          );
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5),
                      ),
                      _stickyKey.currentContext != null
                          ? Positioned(
                              child: Container(
                                  transform: Matrix4.translationValues(
                                      -(sizeGrid.size.width * 0.05),
                                      -(sizeGrid.size.height * 0.04),
                                      0.0),
                                  decoration: BoxDecoration(color: Colors.red),
                                  width: sizeGrid.size.width * 0.1,
                                  height: sizeGrid.size.width * 0.1,
                                  child: Text("")),
                              left: characterPositionX +
                                  (sizeGrid.size.width * 0.5),
                              top: characterPositionY +
                                  (sizeGrid.size.width * 0.49),
                            )
                          : Text("")
                    ],
                  ),
                ),
              ),
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
}
