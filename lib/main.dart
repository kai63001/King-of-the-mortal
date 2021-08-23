import 'dart:async';
import 'dart:math';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:math' as Math;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'King of the mortal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: ''),
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

  final genGame = ["right", "left", "up", "down"];

  // quiz
  List<int> genedGame = [];
  List<int> positionGreen = []; //ตำแหน่งที่ไม่มีระเบิด
  int nowPositon = 12;
  // index ไว้ แสดง quiz ใน array
  int index = 0;
  String template = "";

  bool gameStart = false;
  bool onCheckPress = true;
  // เมื่อแพ้เกม
  bool checkGameOver = false;

  double characterPositionX = 0;
  double characterPositionY = 0;
  // เดินไปกี่ครั้ง
  int step = 0;

  //ระดับ
  int level = 1;

  // resiponsive
  final _stickyKey = GlobalKey();
  late final RenderBox sizeGrid;
  double staticMoveX = 0.0;
  double staticMoveY = 0.0;

  //flip card
  var cardKeys = Map<int, GlobalKey<FlipCardState>>();
  GlobalKey<FlipCardState>? lastFlipped;

  //แก้ bug แกน x y
  int x = 0;
  int y = 0;

  void startGame() {
    print("game start");
    setState(() {
      gameStart = true;
      genedGame = [];
      positionGreen = [];
      index = 0;
      step = 0;
      level += 1;
      checkGameOver = false;
    });
    generateGame();
  }

  //check it
  void checkOutOfCard() {
    // 0 = ขวา
    // 1 = ซ้าย
    // 2 = ขึ้น
    // 3 = ลง
    int random = Random().nextInt(genGame.length);
    // แก้บัคโดยการ ถ้า แกน x หรือ แกน y ออกนอกที่กำหนดแล้วจะให้ทำตรงกันข้าม
    switch (random) {
      //ขวา
      case 0:
        setState(() {
          x += 1;
          //  กำหนดตำแหน่ง
          nowPositon += 1;
          positionGreen.add(nowPositon);
        });
        if (x > 2) {
          setState(() {
            random = 1;
            x -= 2;
            //กำหนดต่ำแหน่ง
            positionGreen.removeLast();
            nowPositon -= 2;
            positionGreen.add(nowPositon);
          });
        }
        break;
      // ซ้าย
      case 1:
        setState(() {
          x -= 1;
          //  กำหนดตำแหน่ง
          nowPositon -= 1;
          positionGreen.add(nowPositon);
        });
        if (x < -2) {
          setState(() {
            random = 0;
            x += 2;
            //กำหนดต่ำแหน่ง
            positionGreen.removeLast();
            nowPositon += 2;
            positionGreen.add(nowPositon);
          });
        }
        break;
      // ขึ้น
      case 2:
        setState(() {
          y -= 1;
          //  กำหนดตำแหน่ง
          nowPositon -= 5;
          positionGreen.add(nowPositon);
        });
        if (y < -2) {
          setState(() {
            random = 3;
            y += 2;
            //กำหนดต่ำแหน่ง
            positionGreen.removeLast();
            nowPositon += 10;
            positionGreen.add(nowPositon);
          });
        }
        break;
      case 3:
        setState(() {
          y += 1;
          //  กำหนดตำแหน่ง
          nowPositon += 5;
          positionGreen.add(nowPositon);
        });
        if (y > 2) {
          setState(() {
            random = 2;
            y -= 2;
            //กำหนดต่ำแหน่ง
            positionGreen.removeLast();
            nowPositon -= 10;
            positionGreen.add(nowPositon);
          });
        }
        break;
    }
    print("x = $x");
    print("y = $y");
    genedGame.add(random);
    return;
  }

  // สร้าง ด่าน
  void generateGame() async {
    // สุ่มว่าจะให้เดินไปทางไหนเก็บเข้าไปใน array + level
    for (var i = 0; i < level; i++) {
      checkOutOfCard();
    }
    print("quiz game : $genedGame");
    print("position : $positionGreen");

    // ทำการบอก player ว่าให้เดินไปทางไหนแล้วจำเอา
    for (var i = 0; i < genedGame.length; i++) {
      await Future.delayed(Duration(seconds: 1));
      print(genGame[genedGame[i]]);
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
    // print(detail.delta.dy);
    if (detail.delta.dx > sensitivity &&
        characterPositionX < (staticMoveX * 2)) {
      // print("right");
      setState(() {
        characterPositionX += staticMoveX;
        onCheckPress = true;
        checkBomb("right");
      });
    } else if (detail.delta.dx < -sensitivity &&
        characterPositionX > -(staticMoveX * 2)) {
      // print("left");
      setState(() {
        characterPositionX -= staticMoveX;
        onCheckPress = true;
        checkBomb("left");
      });
    } else if (detail.delta.dy > sensitivity &&
        characterPositionY < (staticMoveY * 2)) {
      print("down");
      setState(() {
        characterPositionY += staticMoveY;
        onCheckPress = true;
        checkBomb("down");
      });
    } else if (detail.delta.dy < -sensitivity &&
        characterPositionY > -(staticMoveY * 2)) {
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
      });
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        template = "";
        step += 1;
      });
      if (step == genedGame.length) {
        setState(() {
          template = "letgo";
        });
        startGame();
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
    await Future.delayed(Duration(seconds: 1));
    for (int i = 0; i < data.length; i++) {
      cardKeys[i]?.currentState?.toggleCard();
    }
    await Future.delayed(Duration(seconds: 1));
    for (int i = 0; i < data.length; i++) {
      cardKeys[i]?.currentState?.toggleCard();
    }
    return;
  }

  //แพ้
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
      x = 0;
      y = 0;
      level = 1;
      nowPositon = 12;
      positionGreen = [];
      checkGameOver = true;
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
      //resiponsive
      staticMoveX = sizeGrid.size.width == 400
          ? sizeGrid.size.width * 0.2
          : sizeGrid.size.width * 0.199;
      staticMoveY = sizeGrid.size.width == 400
          ? sizeGrid.size.width * 0.2
          : sizeGrid.size.width * 0.199;
    });
    print(sizeGrid.size);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: SafeArea(
        child: GestureDetector(
          onPanUpdate: (detail) {
            playerMovement(detail);
          },
          child: Stack(
            children: [
              arrowQuiz(size),
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
                        cardBoomm(),
                        _stickyKey.currentContext != null
                            ? playerGame()
                            : Text("")
                      ],
                    ),
                  ),
                ),
              ),
              !gameStart ? menuGame(size) : Text(""),
            ],
          ),
        ),
      ),
    );
  }

  // Player
  Positioned playerGame() {
    return Positioned(
      child: Container(
          transform: Matrix4.translationValues(-(sizeGrid.size.width * 0.05),
              -(sizeGrid.size.height * 0.04), 0.0),
          decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(3))),
          width: sizeGrid.size.width * 0.1,
          height: sizeGrid.size.width * 0.1,
          child: Text("")),
      left: characterPositionX + (sizeGrid.size.width * 0.5),
      top: characterPositionY + (sizeGrid.size.width * 0.49),
    );
  }

  // ลูกศร และ ui ต่างๆบนหัว
  Positioned arrowQuiz(Size size) {
    double calAnge = template == "right"
        ? Math.pi / 2
        : template == "left"
            ? Math.pi / -2
            : template == "up"
                ? 0
                : template == "down"
                    ? -Math.pi
                    : Math.pi * 1;
    return Positioned(
      child: Container(
          width: size.width,
          child: gameStart
              ? Center(
                  child: template == "up" ||
                          template == "down" ||
                          template == "left" ||
                          template == "right"
                      ? Transform.rotate(
                          angle: calAnge,
                          child: Image.asset(
                            "assets/images/up-arrow.png",
                            width: 50,
                          ))
                      : template == "nice"
                          ? Image.asset(
                              "assets/images/like.png",
                              width: 50,
                            )
                          : template == "GOGOGO"
                              ? Image.asset("assets/images/start-button.png",
                                  width: size.height * 0.1)
                              : template == "letgo"
                                  ? Image.asset(
                                      "assets/images/crown.png",
                                      width: size.height * 0.1,
                                    )
                                  : Text("$template"))
              : Text("")),
      top: (size.height * 0.05),
    );
  }

  // Card แสดง ระเบิด
  GridView cardBoomm() {
    return GridView.builder(
      // แก้ grid ไม่ให้มัน scroll ซึงมันไม่ scroll อยู่แล้ว แกน y เลยไม่ทำงาน เห้อออ
      physics: NeverScrollableScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (context, indexCard) {
        cardKeys.putIfAbsent(indexCard, () => GlobalKey<FlipCardState>());
        GlobalKey<FlipCardState>? thisCard = cardKeys[indexCard];
        return FlipCard(
          flipOnTouch: false,
          direction: FlipDirection.HORIZONTAL,
          key: thisCard,
          front: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.blue,
                  width: 5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 0), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(3))),
            child: Center(
              child: Image.asset(
                "assets/images/question-mark.png",
                color: Colors.blue,
                width: 25,
              ),
            ),
          ),
          back: positionGreen.length > 0
              ? Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: positionGreen[step] == indexCard
                            ? Colors.yellow
                            : Colors.red,
                        width: 5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(0, 0),
                        ),
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(3))),
                  child: Center(
                    child: Image.asset(
                      positionGreen[step] == indexCard
                          ? "assets/images/c.png"
                          : "assets/images/round-bomb.png",
                      color: positionGreen[step] == indexCard
                          ? Colors.yellow
                          : Colors.red,
                      width: 25,
                    ),
                  ),
                )
              : Text(''),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5, crossAxisSpacing: 5, mainAxisSpacing: 5),
    );
  }

  Container menuGame(Size size) {
    return Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.lightBlueAccent,
            Colors.blue,
          ],
        )),
        child: ListView(
          children: [
            Container(
              height: size.height * 0.1,
            ),
            Container(
              height: size.height * 0.3,
              child: Image.asset(
                'assets/images/king.png',
              ),
            ),
            Container(
              height: size.height * 0.1,
            ),
            Center(
              child: Container(
                width: size.width * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    checkGameOver?Text(
                      "GAME OVER",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.fredokaOne(
                          textStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 35)),
                    ):
                    Text(
                      "King of the mortal",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.fredokaOne(
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 35)),
                    ),
                    Text(
                      "Memorise the arrows shown each round and move to dodge the explosions",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.fredokaOne(
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 15)),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: size.height * 0.05,
            ),
            Center(
                child: GestureDetector(
              onTap: () {
                startGame();
              },
              child: Container(
                  width: size.width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      checkGameOver ? "TRY AGAIN":
                      "START GAME",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.fredokaOne(
                          textStyle: TextStyle(color: Colors.blue)),
                    ),
                  )),
            )),
          ],
        ));
  }
}
