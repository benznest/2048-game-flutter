import 'dart:math';

import 'package:flutter/material.dart';

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

const int COUNT_BLOCK_TYPE = 12;
const int BLOCK_VALUE_NONE = 1;
const int BLOCK_VALUE_2 = 2;
const int BLOCK_VALUE_4 = 4;
const int BLOCK_VALUE_8 = 8;
const int BLOCK_VALUE_16 = 16;
const int BLOCK_VALUE_32 = 32;
const int BLOCK_VALUE_64 = 64;
const int BLOCK_VALUE_128 = 128;
const int BLOCK_VALUE_256 = 256;
const int BLOCK_VALUE_512 = 512;
const int BLOCK_VALUE_1024 = 1024;
const int BLOCK_VALUE_2048 = 2048;

const int DIRECTION_UP = 0;
const int DIRECTION_LEFT = 1;
const int DIRECTION_RIGHT = 2;
const int DIRECTION_DOWN = 3;

class BlockUnitManager {
  static BlockUnit randomBlock({int maxPow = COUNT_BLOCK_TYPE}) {
    Random random = Random();
    int value = pow(2, random.nextInt(maxPow)).toInt();
    return create(value);
  }

  static BlockUnit randomSimpleBlock() {
    Random random = Random();
    int value = random.nextInt(2);
    if (value == 0) {
      return create(BLOCK_VALUE_2);
    }
    return create(BLOCK_VALUE_4);
  }


  static BlockUnit create(int value) {
    if (value == BLOCK_VALUE_NONE) {
      return BlockUnit(
          value: value,
          colorBackground: Color(0xffccc0b3),
          colorText: Color(0x00ffffff),
          fontSize: 26);
    } else if (value == BLOCK_VALUE_2) {
      return BlockUnit(
          value: value,
          colorBackground: Color(0xffeee4d9),
          colorText: Color(0xff776e64));
    } else if (value == BLOCK_VALUE_4) {
      return BlockUnit(
          value: value,
          colorBackground: Color(0xffede0c8),
          colorText: Color(0xff776e64));
    } else if (value == BLOCK_VALUE_8) {
      return BlockUnit(
          value: value,
          colorBackground: Color(0xfff2b179),
          colorText: Color(0xffffffff));
    } else if (value == BLOCK_VALUE_16) {
      return BlockUnit(
          value: value,
          colorBackground: Color(0xfff49663),
          colorText: Color(0xffffffff));
    } else if (value == BLOCK_VALUE_32) {
      return BlockUnit(
          value: value,
          colorBackground: Color(0xfff77b63),
          colorText: Color(0xffffffff));
    } else if (value == BLOCK_VALUE_64) {
      return BlockUnit(
          value: value,
          colorBackground: Color(0xfff45639),
          colorText: Color(0xffffffff));
    } else if (value == BLOCK_VALUE_128) {
      return BlockUnit(
          value: value,
          colorBackground: Color(0xffedce71),
          colorText: Color(0xffffffff));
    } else if (value == BLOCK_VALUE_256) {
      return BlockUnit(
          value: value,
          colorBackground: Color(0xfff0cb63),
          colorText: Color(0xffffffff));
    } else if (value == BLOCK_VALUE_512) {
      return BlockUnit(
          value: value,
          colorBackground: Color(0xffecc752),
          colorText: Color(0xffffffff));
    } else if (value == BLOCK_VALUE_1024) {
      return BlockUnit(
          value: value,
          colorBackground: Color(0xffeec62c),
          colorText: Color(0xffffffff),
          fontSize: 26);
    } else if (value == BLOCK_VALUE_2048) {
      return BlockUnit(
          value: value,
          colorBackground: Color(0xffeec309),
          colorText: Color(0xffffffff),
          fontSize: 26);
    } else {
      return BlockUnit(
          value: value,
          colorBackground: Color(0xffeec309),
          colorText: Color(0xffffffff));
    }
  }
}

class Coordinate {
  int row;
  int col;

  Coordinate({this.row, this.col});
}

class BlockUnit {
  int value;
  Color colorBackground;
  Color colorText;
  double fontSize;

  BlockUnit({this.value = 0,
    this.colorBackground,
    this.colorText,
    this.fontSize = 32});
}

class _MyHomePageState extends State<MyHomePage> {
  List<List<BlockUnit>> table;
  bool delayMode = false;

  @override
  void initState() {
    initTable();
    super.initState();
  }

  void initTable() {
    table = List();
    for (int row = 0; row < 4; row++) {
      List<BlockUnit> list = List();
      for (int col = 0; col < 4; col++) {
        list.add(BlockUnitManager.randomBlock(maxPow: 2));
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
          if(!delayMode) {
            delayMode = true;
            if (direction == DIRECTION_LEFT) {
              moveLeft();
            } else if (direction == DIRECTION_RIGHT) {
              moveRight();
            } else if (direction == DIRECTION_DOWN) {
              moveDown();
            } else if (direction == DIRECTION_UP) {
              moveUp();
            }


            Future.delayed(const Duration(milliseconds: 200), () {
              setState(() {
                delayMode = false;
                randomSimpleBlockToTable();
              });
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

  moveLeft() {
    setState(() {
      for (int row = 0; row < 4; row++) {
        moveAllBlockToLeft(row);
        combineAllBlockToLeft(row);
        moveAllBlockToLeft(row);
      }
    });
  }

  void combineAllBlockToLeft(int row) {
    if (table[row][0].value == table[row][1].value &&
        table[row][0].value != BLOCK_VALUE_NONE) {
      table[row][0] = BlockUnitManager.create(table[row][0].value * 2);
      table[row][1] = BlockUnitManager.create(BLOCK_VALUE_NONE);
    }
    if (table[row][1].value == table[row][2].value &&
        table[row][1].value != BLOCK_VALUE_NONE) {
      table[row][1] = BlockUnitManager.create(table[row][1].value * 2);
      table[row][2] = BlockUnitManager.create(BLOCK_VALUE_NONE);
    }
    if (table[row][2].value == table[row][3].value &&
        table[row][2].value != BLOCK_VALUE_NONE) {
      table[row][2] = BlockUnitManager.create(table[row][2].value * 2);
      table[row][3] = BlockUnitManager.create(BLOCK_VALUE_NONE);
    }
  }

  void moveAllBlockToLeft(int row) {
    int col = 0;
    int count = 0;
    // move all BLOCK in row to left
    while (count < 4 && col < 4) {
      if (table[row][col].value == BLOCK_VALUE_NONE) {
        BlockUnit blockEmpty = table[row][col];
        table[row].removeAt(col);
        table[row].add(blockEmpty);
        count++;
      } else {
        col++;
      }
    }
  }

  moveRight() {
    setState(() {
      for (int row = 0; row < 4; row++) {
        moveAllBlockToRight(row);
        combineAllBlockToRight(row);
        moveAllBlockToRight(row);
      }
    });
  }

  void moveAllBlockToRight(int row) {
    int col = 3;
    int count = 0;
    while (count < 4 && col >= 0) {
      if (table[row][col].value == BLOCK_VALUE_NONE) {
        BlockUnit blockEmpty = table[row][col];
        table[row].removeAt(col);
        table[row].insert(0, blockEmpty);
        count++;
      } else {
        col--;
      }
    }
  }

  void combineAllBlockToRight(int row) {
    if (table[row][3].value == table[row][2].value &&
        table[row][3].value != BLOCK_VALUE_NONE) {
      table[row][3] = BlockUnitManager.create(table[row][3].value * 2);
      table[row][2] = BlockUnitManager.create(BLOCK_VALUE_NONE);
    }
    if (table[row][2].value == table[row][1].value &&
        table[row][2].value != BLOCK_VALUE_NONE) {
      table[row][2] = BlockUnitManager.create(table[row][2].value * 2);
      table[row][1] = BlockUnitManager.create(BLOCK_VALUE_NONE);
    }
    if (table[row][1].value == table[row][0].value &&
        table[row][1].value != BLOCK_VALUE_NONE) {
      table[row][1] = BlockUnitManager.create(table[row][1].value * 2);
      table[row][0] = BlockUnitManager.create(BLOCK_VALUE_NONE);
    }
  }

  moveDown() {
    setState(() {
      for (int col = 0; col < 4; col++) {
        moveAllBlockToDown(col);
        combineAllBlockToDown(col);
        moveAllBlockToDown(col);
      }
    });
  }

  void moveAllBlockToDown(int col) {
    int row = 3;
    int count = 0;

    List<BlockUnit> listVertical = List();
    listVertical.add(table[0][col]);
    listVertical.add(table[1][col]);
    listVertical.add(table[2][col]);
    listVertical.add(table[3][col]);

    while (count < 4 && row >= 0) {
      if (listVertical[row].value == BLOCK_VALUE_NONE) {
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
  }

  void combineAllBlockToDown(int col) {
    if (table[3][col].value == table[2][col].value &&
        table[3][col].value != BLOCK_VALUE_NONE) {
      table[3][col] = BlockUnitManager.create(table[3][col].value * 2);
      table[2][col] = BlockUnitManager.create(BLOCK_VALUE_NONE);
    }
    if (table[2][col].value == table[1][col].value &&
        table[2][col].value != BLOCK_VALUE_NONE) {
      table[2][col] = BlockUnitManager.create(table[2][col].value * 2);
      table[1][col] = BlockUnitManager.create(BLOCK_VALUE_NONE);
    }
    if (table[1][col].value == table[0][col].value &&
        table[1][col].value != BLOCK_VALUE_NONE) {
      table[1][col] = BlockUnitManager.create(table[1][col].value * 2);
      table[0][col] = BlockUnitManager.create(BLOCK_VALUE_NONE);
    }
  }

  moveUp() {
    setState(() {
      for (int col = 0; col < 4; col++) {
        moveAllBlockToUp(col);
        combineAllBlockToUp(col);
        moveAllBlockToUp(col);
      }
    });
  }

  void moveAllBlockToUp(int col) {
    int row = 0;
    int count = 0;

    List<BlockUnit> listVertical = List();
    listVertical.add(table[0][col]);
    listVertical.add(table[1][col]);
    listVertical.add(table[2][col]);
    listVertical.add(table[3][col]);

    while (count < 4 && row < 4) {
      if (listVertical[row].value == BLOCK_VALUE_NONE) {
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
  }

  void combineAllBlockToUp(int col) {
    if (table[0][col].value == table[1][col].value &&
        table[0][col].value != BLOCK_VALUE_NONE) {
      table[0][col] = BlockUnitManager.create(table[0][col].value * 2);
      table[1][col] = BlockUnitManager.create(BLOCK_VALUE_NONE);
    }
    if (table[1][col].value == table[2][col].value &&
        table[1][col].value != BLOCK_VALUE_NONE) {
      table[1][col] = BlockUnitManager.create(table[1][col].value * 2);
      table[2][col] = BlockUnitManager.create(BLOCK_VALUE_NONE);
    }
    if (table[2][col].value == table[3][col].value &&
        table[2][col].value != BLOCK_VALUE_NONE) {
      table[2][col] = BlockUnitManager.create(table[2][col].value * 2);
      table[3][col] = BlockUnitManager.create(BLOCK_VALUE_NONE);
    }
  }

  randomSimpleBlockToTable() {
    List<Coordinate> listBlockUnitEmpty = List();
    for (int row = 0; row < 4; row++) {
      for (int col = 0; col < 4; col++) {
        if (table[row][col].value == BLOCK_VALUE_NONE) {
          listBlockUnitEmpty.add(Coordinate(row: row, col: col));
        }
      }
    }

    Random random = Random();
    int index = random.nextInt(listBlockUnitEmpty.length);
    int row = listBlockUnitEmpty[index].row;
    int col = listBlockUnitEmpty[index].col;

    table[row][col] = BlockUnitManager.randomSimpleBlock();
  }
}
