import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String a = '';
  String b = '';
  String sign = '';
  bool finish = false;
  bool dotEntered = false;

  void clearAll() {
    setState(() {
      a = '';
      b = '';
      sign = '';
      finish = false;
      dotEntered = false;
    });
  }

  void onButtonPressed(String key) {
    setState(() {
      if (key == 'C') {
        clearAll();
      } else if (key == '+/-') {
        if (a.isNotEmpty && b.isEmpty && !finish) {
          a = (double.parse(a) * -1).toString();
        } else if (b.isNotEmpty && !finish) {
          b = (double.parse(b) * -1).toString();
        }
      } else if (key == '%') {
        if (a.isNotEmpty && !finish) {
          a = (double.parse(a) / 100).toString();
        } else if (b.isNotEmpty && !finish) {
          b = (double.parse(b) / 100).toString();
        }
      } else if (['+', '-', '*', '/'].contains(key)) {
        if (b.isNotEmpty && !finish) {
          calculate();
        }
        sign = key;
        finish = false;
        dotEntered = false;
      } else if (key == '=') {
        calculate();
      } else if (key == '.' && !dotEntered) {
        if (finish) {
          clearAll();
        }
        if (b.isEmpty && sign.isEmpty) {
          a += key;
        } else {
          b += key;
        }
        dotEntered = true;
      } else if (RegExp(r'^\d$').hasMatch(key)) {
        if (finish) {
          clearAll();
        }
        if (b.isEmpty && sign.isEmpty) {
          a += key;
        } else {
          b += key;
        }
      }
    });
  }

  void calculate() {
    if (b.isEmpty) {
      b = a;
    }
    switch (sign) {
      case '+':
        a = (double.parse(a) + double.parse(b)).toString();
        break;
      case '-':
        a = (double.parse(a) - double.parse(b)).toString();
        break;
      case '*':
        a = (double.parse(a) * double.parse(b)).toString();
        break;
      case '/':
        if (double.parse(b) == 0) {
          a = 'Ошибка';
        } else {
          a = (double.parse(a) / double.parse(b)).toString();
        }
        break;
    }
    finish = true;
    b = '';
    sign = '';
    dotEntered = false;
  }

  Widget buildButton(String value,
      {bool isDouble = false, double width = 60.0, double height = 60.0}) {
    Color buttonColor;
    Color splashColor;

    if (['C', '+/-', '%'].contains(value)) {
      buttonColor = Color(0xFFCFCFCF);
      splashColor = Color(0xFF9C9C9C);
    } else if (['+', '-', '*', '/', '='].contains(value)) {
      buttonColor = Color(0xFFB6E4F1);
      splashColor = Color(0xAE4DCAFC);
    } else {
      buttonColor = Color(0xFFDDF8FC);
      splashColor = Color(0xFFFFFFFF);
    }

    return Expanded(
      flex: isDouble ? 2 : 1,
      child: Container(
        height: 50,
        margin: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onButtonPressed(value),
            borderRadius: BorderRadius.circular(8.0),
            splashColor: splashColor,
            child: Center(
              child: Text(
                value,
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Калькулятор'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(16.0),
              child: Text(
                b.isEmpty && sign.isEmpty
                    ? (a.isEmpty ? '0' : a)
                    : (b.isEmpty ? '$a $sign' : '$b'),
                style: TextStyle(fontSize: 30.0),
              ),
            ),
          ),
          Row(
            children: [
              buildButton('C'),
              buildButton('+/-'),
              buildButton('%'),
              buildButton(
                '/',
              ),
            ],
          ),
          Row(
            children: [
              buildButton('7'),
              buildButton('8'),
              buildButton('9'),
              buildButton('*'),
            ],
          ),
          Row(
            children: [
              buildButton('4'),
              buildButton('5'),
              buildButton('6'),
              buildButton('-'),
            ],
          ),
          Row(
            children: [
              buildButton('1'),
              buildButton('2'),
              buildButton('3'),
              buildButton('+'),
            ],
          ),
          Row(
            children: [
              buildButton('0'),
              buildButton('.'),
              buildButton('='),
            ],
          ),
        ],
      ),
    );
  }
}
