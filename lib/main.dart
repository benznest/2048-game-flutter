import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game_2048_flutter/block_unit.dart';
import 'package:game_2048_flutter/coordinate.dart';
import 'package:game_2048_flutter/block_unit_manager.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2048',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '2048'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

const double BLOCK_SIZE = 80;



const int DIRECTION_UP = 0;
const int DIRECTION_LEFT = 1;
const int DIRECTION_RIGHT = 2;
const int DIRECTION_DOWN = 3;




class _MyHomePageState extends State<MyHomePage> {
  List<List<BlockUnit>> table;
  bool delayMode = false;
  int score = 0;

  @override
  void initState() {
    initGame();
    super.initState();
  }

  void initGame() {
    score = 0;
    initTable();
    randomSimpleBlockToTable();
    randomSimpleBlockToTable();
  }

  void initTable() {
    table = List();
    for (int row = 0; row < 4; row++) {
      List<BlockUnit> list = List();
      for (int col = 0; col < 4; col++) {
        list.add(BlockUnitManager.create(BLOCK_VALUE_NONE));
      }
      table.add(list);
    }
  }

  void initTestTable() {
    table = List();
    int value = 2;
    for (int row = 0; row < 4; row++) {
      List<BlockUnit> list = List();
      for (int col = 0; col < 4; col++) {
        list.add(BlockUnitManager.create(value));
        value *= 2;
      }
      table.add(list);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Color(0xfffbf9f3),
          child: Column(children: <Widget>[
            buildMenu(),
            Expanded(
                child: Center(
                  child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xffbaad9e),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              width: 6, color: Color(0xffbaad9e))),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: buildTable())),
                )),
            buildControlButton()
          ])),
    );
  }

  List<Row> buildTable() {
    List<Row> listRow = List();
    for (int row = 0; row < 4; row++) {
      listRow.add(
          Row(mainAxisSize: MainAxisSize.min,
              children: buildRowBlockUnit(row)));
    }
    return listRow;
  }

  Container buildBlockUnit(int row, int col) {
    return Container(
      decoration: BoxDecoration(
        color: table[row][col].colorBackground,
        borderRadius: BorderRadius.circular(4),
      ),
      width: BLOCK_SIZE,
      height: BLOCK_SIZE,
      margin: EdgeInsets.all(3),
      child: Center(
          child: Text(
            "" + table[row][col].value.toString(),
            style: TextStyle(
                fontSize: table[row][col].fontSize,
                fontWeight: FontWeight.bold,
                color: table[row][col].colorText),
          )),
    );
  }

  List<Widget> buildRowBlockUnit(int row) {
    List<Widget> list = List();
    for (int col = 0; col < 4; col++) {
      list.add(buildBlockUnit(row, col));
    }
    return list;
  }

  Container buildMenu() {
    return Container(
      padding: EdgeInsets.only(top: 36, bottom: 12, left: 16, right: 16),
      color: Color(0xffede0c8),
      child:
      Row(mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(onTap: () {
              restart();
            },
                child: Container(constraints: BoxConstraints(minWidth: 120),
                    decoration: BoxDecoration(color: Color(0xff8f7a66),
                        borderRadius: BorderRadius.circular(4)),
                    padding: EdgeInsets.all(12),
                    child: Column(children: <Widget>[
                      Text("New Game", style: TextStyle(fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white))
                    ]))),
            Expanded(child: Container()),
            Container(constraints: BoxConstraints(minWidth: 120),
                decoration: BoxDecoration(color: Color(0xffbbada0),
                    borderRadius: BorderRadius.circular(4)),
                padding: EdgeInsets.all(4),
                child: Column(children: <Widget>[
                  Text("SCORE", style: TextStyle(fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
                  Text("$score", style: TextStyle(fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white))
                ]))
          ]),
    );
  }

  Container buildControlButton() {
    return Container(
      padding: EdgeInsets.all(8),
      color: Color(0xffede0c8),
      child:
      Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        buildControlDirectionButton(Icons.keyboard_arrow_left, DIRECTION_LEFT),
        Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                buildControlDirectionButton(
                    Icons.keyboard_arrow_up, DIRECTION_UP),
                buildControlDirectionButton(
                    Icons.keyboard_arrow_down, DIRECTION_DOWN),
              ],
            )),
        buildControlDirectionButton(
            Icons.keyboard_arrow_right, DIRECTION_RIGHT),
      ]),
    );
  }

  GestureDetector buildControlDirectionButton(IconData icon, int direction) {
    return GestureDetector(
        onTap: () {
          if (!delayMode) {
            delayMode = true;
            bool move = true;
            if (direction == DIRECTION_LEFT) {
              move = moveLeft();
            } else if (direction == DIRECTION_RIGHT) {
              move = moveRight();
            } else if (direction == DIRECTION_DOWN) {
              move = moveDown();
            } else if (direction == DIRECTION_UP) {
              move = moveUp();
            }


            Future.delayed(const Duration(milliseconds: 200), () {
              if (move) {
                delayMode = false;
                setState(() {
                  randomSimpleBlockToTable();
                  if (isGameOver()) {
                    showGameOverDialog();
                  }
                });
              } else {
                delayMode = false;
                if (isGameOver()) {
                  showGameOverDialog();
                }
              }
            });
          }
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft:
                  direction == DIRECTION_UP || direction == DIRECTION_LEFT
                      ? Radius.circular(8)
                      : Radius.circular(0),
                  topRight:
                  direction == DIRECTION_UP || direction == DIRECTION_RIGHT
                      ? Radius.circular(8)
                      : Radius.circular(0),
                  bottomLeft:
                  direction == DIRECTION_LEFT || direction == DIRECTION_DOWN
                      ? Radius.circular(8)
                      : Radius.circular(0),
                  bottomRight: direction == DIRECTION_RIGHT ||
                      direction == DIRECTION_DOWN
                      ? Radius.circular(8)
                      : Radius.circular(0))),
          child: Icon(icon, size: 48),
        ));
  }

  bool moveLeft() {
    bool move = false;
    setState(() {
      for (int row = 0; row < 4; row++) {
        bool moveByNormal = moveAllBlockToLeft(row);
        bool moveByCombine = combineAllBlockToLeft(row);
        moveAllBlockToLeft(row);
        move = move || moveByNormal || moveByCombine;
      }
    });
    return move;
  }

  bool combineAllBlockToLeft(int row) {
    bool move = false;
    if (table[row][0].value == table[row][1].value &&
        table[row][0].value != BLOCK_VALUE_NONE) {
      table[row][0] = BlockUnitManager.create(table[row][0].value * 2);
      table[row][1] = BlockUnitManager.create(BLOCK_VALUE_NONE);
      score += table[row][0].value;
      move = true;
    }
    if (table[row][1].value == table[row][2].value &&
        table[row][1].value != BLOCK_VALUE_NONE) {
      table[row][1] = BlockUnitManager.create(table[row][1].value * 2);
      table[row][2] = BlockUnitManager.create(BLOCK_VALUE_NONE);
      score += table[row][1].value;
      move = true;
    }
    if (table[row][2].value == table[row][3].value &&
        table[row][2].value != BLOCK_VALUE_NONE) {
      table[row][2] = BlockUnitManager.create(table[row][2].value * 2);
      table[row][3] = BlockUnitManager.create(BLOCK_VALUE_NONE);
      score += table[row][2].value;
      move = true;
    }
    return move;
  }

  bool moveAllBlockToLeft(int row) {
    bool move = false;

    int col = 0;
    int count = 0;
    // move all BLOCK in row to left
    while (count < 4 && col < 4) {
      if (table[row][col].value == BLOCK_VALUE_NONE) {
        if (col < 4 - 1) {
          if (table[row][col + 1].value != BLOCK_VALUE_NONE) {
            move = true;
          }
        }

        BlockUnit blockEmpty = table[row][col];
        table[row].removeAt(col);
        table[row].add(blockEmpty);
        count++;
      } else {
        col++;
      }
    }
    return move;
  }

  bool moveRight() {
    print("move right");
    bool move = false;
    setState(() {
      for (int row = 0; row < 4; row++) {
        bool moveByNormal = moveAllBlockToRight(row);
        bool moveByCombine = combineAllBlockToRight(row);
        moveAllBlockToRight(row);
        move = move || moveByNormal || moveByCombine;
      }
    });
    return move;
  }

  bool moveAllBlockToRight(int row) {
    bool move = false;
    int col = 3;
    int count = 0;
    while (count < 4 && col >= 0) {
      if (table[row][col].value == BLOCK_VALUE_NONE) {
        if (col > 0) {
          if (table[row][col - 1].value != BLOCK_VALUE_NONE) {
            move = true;
          }
        }

        BlockUnit blockEmpty = table[row][col];
        table[row].removeAt(col);
        table[row].insert(0, blockEmpty);
        count++;
      } else {
        col--;
      }
    }
    return move;
  }

  bool combineAllBlockToRight(int row) {
    bool move = false;
    if (table[row][3].value == table[row][2].value &&
        table[row][3].value != BLOCK_VALUE_NONE) {
      table[row][3] = BlockUnitManager.create(table[row][3].value * 2);
      table[row][2] = BlockUnitManager.create(BLOCK_VALUE_NONE);
      score += table[row][3].value;
      move = true;
    }
    if (table[row][2].value == table[row][1].value &&
        table[row][2].value != BLOCK_VALUE_NONE) {
      table[row][2] = BlockUnitManager.create(table[row][2].value * 2);
      table[row][1] = BlockUnitManager.create(BLOCK_VALUE_NONE);
      score += table[row][2].value;
      move = true;
    }
    if (table[row][1].value == table[row][0].value &&
        table[row][1].value != BLOCK_VALUE_NONE) {
      table[row][1] = BlockUnitManager.create(table[row][1].value * 2);
      table[row][0] = BlockUnitManager.create(BLOCK_VALUE_NONE);
      score += table[row][1].value;
      move = true;
    }
    return move;
  }

  bool moveDown() {
    bool move = false;
    setState(() {
      for (int col = 0; col < 4; col++) {
        bool moveByNormal = moveAllBlockToDown(col);
        bool moveByCombine = combineAllBlockToDown(col);
        moveAllBlockToDown(col);
        move = move || moveByNormal || moveByCombine;
      }
    });
    return move;
  }

  bool moveAllBlockToDown(int col) {
    bool move = false;
    int row = 3;
    int count = 0;

    List<BlockUnit> listVertical = List();
    listVertical.add(table[0][col]);
    listVertical.add(table[1][col]);
    listVertical.add(table[2][col]);
    listVertical.add(table[3][col]);

    while (count < 4 && row >= 0) {
      if (listVertical[row].value == BLOCK_VALUE_NONE) {
        if (row > 0) {
          if (listVertical[row - 1].value != BLOCK_VALUE_NONE) {
            move = true;
          }
        }

        BlockUnit blockEmpty = listVertical[row];
        listVertical.removeAt(row);
        listVertical.insert(0, blockEmpty);
        count++;
      } else {
        row--;
      }
    }

    for (int row = 0; row < 4; row++) {
      table[row][col] = listVertical[row];
    }
    return move;
  }

  bool combineAllBlockToDown(int col) {
    bool move = false;
    if (table[3][col].value == table[2][col].value &&
        table[3][col].value != BLOCK_VALUE_NONE) {
      table[3][col] = BlockUnitManager.create(table[3][col].value * 2);
      table[2][col] = BlockUnitManager.create(BLOCK_VALUE_NONE);
      score += table[3][col].value;
      move = true;
    }
    if (table[2][col].value == table[1][col].value &&
        table[2][col].value != BLOCK_VALUE_NONE) {
      table[2][col] = BlockUnitManager.create(table[2][col].value * 2);
      table[1][col] = BlockUnitManager.create(BLOCK_VALUE_NONE);
      score += table[2][col].value;
      move = true;
    }
    if (table[1][col].value == table[0][col].value &&
        table[1][col].value != BLOCK_VALUE_NONE) {
      table[1][col] = BlockUnitManager.create(table[1][col].value * 2);
      table[0][col] = BlockUnitManager.create(BLOCK_VALUE_NONE);
      score += table[1][col].value;
      move = true;
    }
    return move;
  }

  bool moveUp() {
    bool move = false;
    setState(() {
      for (int col = 0; col < 4; col++) {
        bool moveByNormal = moveAllBlockToUp(col);
        bool moveByCombine = combineAllBlockToUp(col);
        moveAllBlockToUp(col);
        move = move || moveByNormal || moveByCombine;
      }
    });
    return move;
  }

  bool moveAllBlockToUp(int col) {
    bool move = false;
    int row = 0;
    int count = 0;

    List<BlockUnit> listVertical = List();
    listVertical.add(table[0][col]);
    listVertical.add(table[1][col]);
    listVertical.add(table[2][col]);
    listVertical.add(table[3][col]);

    while (count < 4 && row < 4) {
      if (listVertical[row].value == BLOCK_VALUE_NONE) {
        if (row < 4 - 1) {
          if (listVertical[row + 1].value != BLOCK_VALUE_NONE) {
            move = true;
          }
        }

        BlockUnit blockEmpty = listVertical[row];
        listVertical.removeAt(row);
        listVertical.add(blockEmpty);
        count++;
      } else {
        row++;
      }
    }

    for (int row = 0; row < 4; row++) {
      table[row][col] = listVertical[row];
    }
    return move;
  }

  bool combineAllBlockToUp(int col) {
    bool move = false;
    if (table[0][col].value == table[1][col].value &&
        table[0][col].value != BLOCK_VALUE_NONE) {
      table[0][col] = BlockUnitManager.create(table[0][col].value * 2);
      table[1][col] = BlockUnitManager.create(BLOCK_VALUE_NONE);
      score += table[0][col].value;
      move = true;
    }
    if (table[1][col].value == table[2][col].value &&
        table[1][col].value != BLOCK_VALUE_NONE) {
      table[1][col] = BlockUnitManager.create(table[1][col].value * 2);
      table[2][col] = BlockUnitManager.create(BLOCK_VALUE_NONE);
      score += table[1][col].value;
      move = true;
    }
    if (table[2][col].value == table[3][col].value &&
        table[2][col].value != BLOCK_VALUE_NONE) {
      table[2][col] = BlockUnitManager.create(table[2][col].value * 2);
      table[3][col] = BlockUnitManager.create(BLOCK_VALUE_NONE);
      score += table[2][col].value;
      move = true;
    }
    return move;
  }

  bool randomSimpleBlockToTable() {
    List<Coordinate> listBlockUnitEmpty = getBlockEmptyList();
    if (listBlockUnitEmpty.isNotEmpty) {
      Random random = Random();
      int index = random.nextInt(listBlockUnitEmpty.length);
      int row = listBlockUnitEmpty[index].row;
      int col = listBlockUnitEmpty[index].col;

      table[row][col] = BlockUnitManager.randomSimpleBlock();
      return true;
    }
    return false;
  }

  List<Coordinate> getBlockEmptyList() {
    List<Coordinate> listBlockUnitEmpty = List();
    for (int row = 0; row < 4; row++) {
      for (int col = 0; col < 4; col++) {
        if (table[row][col].value == BLOCK_VALUE_NONE) {
          listBlockUnitEmpty.add(Coordinate(row: row, col: col));
        }
      }
    }
    return listBlockUnitEmpty;
  }

  void restart() {
    setState(() {
      initGame();
    });
  }

  bool isGameOver() {
    for (int row = 0; row < 4; row++) {
      for (int col = 0; col < 4; col++) {
        if (table[row][col].value == BLOCK_VALUE_NONE) {
          return false;
        }
        if (col < 4 - 1) {
          if (table[row][col].value == table[row][col + 1].value) {
            return false;
          }
        }
      }
    }

    for (int col = 0; col < 4; col++) {
      for (int row = 0; row < 4; row++) {
        if (table[row][col].value == BLOCK_VALUE_NONE) {
          return false;
        }
        if (row < 4 - 1) {
          if (table[row][col].value == table[row + 1][col].value) {
            return false;
          }
        }
      }
    }

    return true;
  }

  void showGameOverDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Text("Game Over ):",
                  style: TextStyle(
                      fontSize: 32,
                      color: Colors.pink[800],
                      fontWeight: FontWeight.bold)),
              RaisedButton(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                color: Color(0xff8f7a66),
                child: Text("Play again",
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.of(context).pop();
                  restart();
                },
              )
            ]));
      },
    );
  }
}
