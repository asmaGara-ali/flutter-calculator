
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String display = '0';
  double firstNumber = 0;
  String operator = '';
  bool newNumber = false;

  // Ajouter un chiffre
  void press(String value) {
    setState(() {
      if (value == 'C') {
        display = '0';
        firstNumber = 0;
        operator = '';
        newNumber = false;
      } else if (value == '.') {
        if (newNumber) {
          display = '0.';
          newNumber = false;
        } else if (!display.contains('.')) {
          display += '.';
        }
      } else if ('+-×÷'.contains(value) && value.length == 1) {
        firstNumber = double.tryParse(display) ?? 0;
        operator = value;
        newNumber = true;
      } else if (value == '%') {
        double number = double.tryParse(display) ?? 0;
        display = (number / 100).toString();
        newNumber = true;
      } else if (value == '=') {
        double secondNumber = double.tryParse(display) ?? 0;
        double result = 0;

        switch (operator) {
          case '+':
            result = firstNumber + secondNumber;
            break;
          case '-':
            result = firstNumber - secondNumber;
            break;
          case '×':
            result = firstNumber * secondNumber;
            break;
          case '÷':
            if (secondNumber == 0) {
              display = 'Erreur';
              operator = '';
              newNumber = true;
              return;
            }
            result = firstNumber / secondNumber;
            break;
        }

        display = result % 1 == 0
            ? result.toInt().toString()
            : result.toString();

        operator = '';
        newNumber = true;
      } else {
        if (display == '0' || newNumber || display == 'Erreur') {
          display = value;
          newNumber = false;
        } else {
          display += value;
        }
      }
    });
  }

  // Créer un bouton
  Widget button(String text, {Color color = const Color(0xFF333333)}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
          height: 65,
          child: ElevatedButton(
            onPressed: () => press(text),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              text,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Zone d'affichage
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      operator.isEmpty
                          ? ''
                          : '$firstNumber $operator',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 10),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        display,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Clavier numérique
            Row(children: [
              button('C', color: Colors.blueGrey),
              button('%', color: Colors.blueGrey),
              button('.', color: Colors.blueGrey),
              button('÷', color: Colors.orange),
            ]),

            Row(children: [
              button('7'),
              button('8'),
              button('9'),
              button('×', color: Colors.orange),
            ]),

            Row(children: [
              button('4'),
              button('5'),
              button('6'),
              button('-', color: Colors.orange),
            ]),

            Row(children: [
              button('1'),
              button('2'),
              button('3'),
              button('+', color: Colors.orange),
            ]),

            Row(children: [
              button('0'),
              button('00'),
              button('=', color: Colors.orange),
            ]),
          ],
        ),
      ),
    );
  }
}
