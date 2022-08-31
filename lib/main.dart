import 'package:flutter/material.dart';
import 'dart:math';
import 'package:confetti/confetti.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ConfettiController _confettiController;
  Random random = Random();
  int x = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 10));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _confettiController.dispose();
  }

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);
    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);
    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Lottery App'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ConfettiWidget(
              confettiController: _confettiController,
              shouldLoop: false,
              blastDirection: -3.14 / 2,
              colors: [Colors.orange, Colors.blue, Colors.green],
              gravity: 0.3,
              numberOfParticles: 10,
              createParticlePath: drawStar,
            ),
            Center(
              child: Text(
                'Lottery Winning number is 4',
                style: TextStyle(color: Colors.blue, fontSize: 20),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              height: 250,
              decoration: BoxDecoration(
                  color: x == 4
                      ? Colors.green.withOpacity(0.3)
                      : Colors.blueGrey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: x == 4
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.done,
                            color: Colors.green,
                            size: 30,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            'Congratulations You have won the lottery, \n Your number is $x ',
                            textAlign: TextAlign.center,
                          )
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error,
                            color: Colors.red,
                            size: 30,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            ' Better Luck next Time , your number is $x \n Try again',
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (x == 4) {
              _confettiController.play();
            } else {
              x = random.nextInt(10);
              print(x);
              print('tap');
            }
            setState(() {});
          },
          child: Icon(Icons.refresh),
          // child: Icon(x>8 ? Icons.multiple_stop : Icons.refresh),
        ),
      ),
    );
  }
}
