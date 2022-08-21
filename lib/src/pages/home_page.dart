import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../widgets/button_widget.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<int> fibs = [0, 0, 0, 0, 0, 0, 0, 0, 0];
  List<List<int>> matrix = <List<int>>[];

  TextEditingController maxController = TextEditingController();
  TextEditingController initialController = TextEditingController();

  _generateFibs(max, initial) {
    int fibonacci(int n) =>
        n <= initial ? initial + 1 : fibonacci(n - 1) + fibonacci(n - 2);
    String output = "";
    fibs = [];
    for (int i = initial; i <= max; ++i) {
      print(i);
      print(max);

      fibs.add(fibonacci(i));

      output += fibonacci(i).toString() + ", ";
    }

    if (fibs.length > 9) {
      showToas('Sobrepaso el limite de la matriz');
      print('Sobrepaso el limite de la matriz');
      _resetMatrix();
    }

    setState(() {});

    print(output + "...");
    print(output + "...");
    print(fibs);
  }

  makeMatrix(rows, cols, function) => Iterable<List<num>>.generate(rows,
          (i) => Iterable<num>.generate(cols, (j) => function(i, j)).toList())
      .toList();

  _resetMatrix() {
    fibs = [0, 0, 0, 0, 0, 0, 0, 0, 0];
    if (initialController.text.isNotEmpty || maxController.text.isNotEmpty) {
      FocusScope.of(context).unfocus();
      initialController.clear();
      maxController.clear();
    }

    setState(() {});
  }

  _rotateMatrix() {
    fibs.shuffle();
    setState(() {});
  }

  @override
  void initState() {
    _resetMatrix();
    // print(makeMatrix(3, 3, (i, j) => i == j ? fibs[i] : fibs[j]));

    // TODO: implement initState
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
        padding: EdgeInsets.all(10), textStyle: const TextStyle(fontSize: 20));
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            height: size.height * 0.5,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: GridView.count(
              // Create a grid with 2 columns. If you change the scrollDirection to
              // horizontal, this produces 2 rows.
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              semanticChildCount: 3,

              // Generate 100 widgets that display their index in the List.
              children: List.generate(fibs.length, (index) {
                return Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(
                        100,
                      )),
                  child: Center(
                    child: Text(
                      fibs[index].toString(),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                FilteringTextInputFormatter.digitsOnly
              ],
              style: TextStyle(color: Colors.white),
              controller: initialController,
              decoration: InputDecoration(
                fillColor: Colors.black,
                filled: true,
                labelText: "Inicio",
                labelStyle:
                    TextStyle(fontSize: 14, color: Colors.grey.shade400),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                FilteringTextInputFormatter.digitsOnly
              ],
              style: TextStyle(color: Colors.white),
              controller: maxController,
              decoration: InputDecoration(
                fillColor: Colors.black,
                filled: true,
                labelText: "Final",
                labelStyle:
                    TextStyle(fontSize: 14, color: Colors.grey.shade400),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: FormButton(
                text: 'Generar Matriz',
                onPressed: () {
                  if (!initialController.text.isEmpty &&
                      !maxController.text.isEmpty) {
                    _generateFibs(int.parse(maxController.text),
                        int.parse(initialController.text));
                  } else {
                    showToas('Inicio y Final son requeridos');
                  }
                },
              )),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: double.infinity,
              child: FormButton(
                text: 'Rotar matriz',
                onPressed: _rotateMatrix,
              )),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: FormButton(
              text: 'Limpiar matriz',
              onPressed: _resetMatrix,
            ),
            width: double.infinity,
          )
        ]),
      ),
    );
  }

  showToas(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: Text(message),
    ));
  }
}
