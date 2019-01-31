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

const double BOX_SIZE = 80;

class BoxUnit {
  int value;
  Color colorBackground;
  Color colorText;

  BoxUnit({this.value = 0, this.colorBackground, this.colorText});
}

class _MyHomePageState extends State<MyHomePage> {
  List<List<BoxUnit>> table;

  @override
  void initState() {
    initTable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Color(0xfffbf9f3),
          child: Center(
            child: Container(
                decoration: BoxDecoration(
                    color: Color(0xffbaad9e),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 6, color: Color(0xffbaad9e))),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: buildTable())),
          )),
    );
  }

  List<Row> buildTable() {
    List<Row> listRow = List();
    for (int row = 0; row < 4; row++) {
      listRow.add(
          Row(mainAxisSize: MainAxisSize.min, children: buildRowBoxUnit(row)));
    }
    return listRow;
  }

  Container buildBoxUnit(int row, int col) {
    return Container(
      decoration: BoxDecoration(
        color: table[row][col].colorBackground,
        borderRadius: BorderRadius.circular(4),
      ),
      width: BOX_SIZE,
      height: BOX_SIZE,
      margin: EdgeInsets.all(3),
      child: Center(child: Text("" + table[row][col].value.toString(),style: TextStyle(fontSize: 18, color:table[row][col].colorText
      ),)),
    );
  }

  void initTable() {
    table = List();
    for (int row = 0; row < 4; row++) {
      List<BoxUnit> list = List();
      for (int col = 0; col < 4; col++) {
        list.add(BoxUnit(
            value: 2,
            colorBackground: Color(0xffeee4d9),
            colorText: Color(0xff776e64)));
      }
      table.add(list);
    }
  }

  List<Widget> buildRowBoxUnit(int row) {
    List<Widget> list = List();
    for (int col = 0; col < 4; col++) {
      list.add(buildBoxUnit(row, col));
    }
    return list;
  }
}
