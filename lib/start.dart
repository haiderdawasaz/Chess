import 'package:flutter/material.dart';
import 'package:chess/game.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});
  @override
  FirstPageState createState() => FirstPageState();
}

class FirstPageState extends State<FirstPage> {
  final player1 = TextEditingController();
  final player2 = TextEditingController();
  bool player1valid = true;
  bool player2valid = true;
  String time = '1';
  String increment = '0';
  static const TextStyle _textFieldStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w400,
    fontSize: 19,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Player Info'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 36, 35, 39),
        ),
        child: Center(
          child: DefaultTextStyle(
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      Row(
                        children: <Widget>[
                          const Text("Player 1: "),
                          Flexible(
                            child: TextField(
                              controller: player1,
                              style: _textFieldStyle,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 6),
                                labelText: 'Enter Name',
                                labelStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Offstage(offstage: player1valid, child: const Text('Minimum 3 characters required', style: TextStyle(fontSize: 15, color: Colors.red))),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 32),
                    child: Column(
                      children: [
                        Row(
                          children: <Widget>[
                            const Text("Player 2: "),
                            Flexible(
                              child: TextField(
                                style: _textFieldStyle,
                                controller: player2,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 6),
                                  labelText: 'Enter Name',
                                  labelStyle: TextStyle(color: Colors.white),
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Offstage(offstage: player2valid, child: const Text('Minimum 3 characters required', style: TextStyle(fontSize: 15, color: Colors.red))),
                      ],
                    )),
                const Text(
                  'Time Settings',
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Colors.green,
                              shadowColor: const Color.fromARGB(255, 255, 255, 255)),
                          onPressed: () {
                            setState(() {
                              if (int.parse(time) > 1) time = (int.parse(time) - 1).toString();
                            });
                          },
                          child: const Icon(
                            Icons.exposure_minus_1,
                            color: Colors.white,
                          ),
                        ),
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Text('$time Minutes')),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: Colors.green,
                                shadowColor: const Color.fromARGB(255, 255, 255, 255)),
                            onPressed: () {
                              setState(() {
                                if (int.parse(time) < 10) time = (int.parse(time) + 1).toString();
                              });
                            },
                            child: const Icon(
                              Icons.plus_one,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.green,
                          shadowColor: const Color.fromARGB(255, 255, 255, 255)),
                      onPressed: () {
                        setState(() {
                          player1valid = (player1.text.length >= 3) ? true : false;
                          player2valid = (player2.text.length >= 3) ? true : false;
                          if (player1valid && player2valid) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Game(
                                  player1: player1.text,
                                  player2: player2.text,
                                  time: int.parse(time) * 60,
                                ),
                              ),
                            );
                          }
                        });
                      },
                      child: const Padding(padding: EdgeInsets.all(10), child: Text('Play', style: TextStyle(fontSize: 23, color: Colors.white))),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
