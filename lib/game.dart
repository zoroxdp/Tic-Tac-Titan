import 'dart:async';
import 'dart:math';
import 'package:clean_dialog/clean_dialog.dart';
import 'package:flat_3d_button/flat_3d_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tic_tac_dp/colors.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> displayXO = ['', '', '', '', '', '', '', '', ''];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColor.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Center(
                child: Hero(
                  tag: 'dash',
                  child: Image.asset(
                    'images/game_logo.png',
                    height: 250,
                    width: 250,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: GridView.builder(
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _humanMove(index);
                    },
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          width: 5,
                          color: Colors.black,
                        ),
                        color: MainColor.secondaryColor,
                      ),
                      child: Center(
                        child: Text(
                          displayXO[index],
                          style: GoogleFonts.coiny(
                            textStyle: TextStyle(
                              fontSize: 94,
                              color: MainColor.accentColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Hero(
              tag: 'sqsh',
              child: Flat3dButton.text(
                padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                color: Colors.teal,
                onPressed: () {
                  restart();
                },
                text: 'Restart the game',
              ),
            ),
            const Expanded(
              flex: 1,
              child: SizedBox(),
            )
          ],
        ),
      ),
    );
  }

  void _humanMove(int index) {
    checkIfOver();
    setState(() {
      if (displayXO[index] == '') {
        displayXO[index] = 'O';
        _aiMove();
      }
    });
    checkIfOver();
  }

  void _aiMove() {
    setState(() {
      int bestScore = -1000;
      int bestmove = -1;
      for (int i = 0; i < 9; i++) {
        if (displayXO[i] == '') {
          displayXO[i] = 'X';
          int score = minimax(0, false);
          displayXO[i] = '';
          if (score > bestScore) {
            bestScore = score;
            bestmove = i;
          }
        }
      }
      if (bestmove != -1) {
        displayXO[bestmove] = 'X';
      }
    });
  }

  void checkIfOver() {
    int winner = checkWinner();
    Color clr = Colors.white;
    String msg = '';
    if (winner == 10) {
      clr = const Color.fromARGB(255, 255, 29, 4);
      msg = "Lost";
    } else if (winner == 0 && isMovesLeft() == false) {
      clr = const Color.fromARGB(125, 100, 134, 124);
      msg = 'Tie';
    } else {
      return;
    }
    Timer(const Duration(milliseconds: 999), () {});
    showDialog(
      barrierColor: const Color(0x00000000),
      context: context,
      builder: (context) => CleanDialog(
        title: msg,
        content: "",
        backgroundColor: clr,
        titleTextStyle: GoogleFonts.coiny(
          textStyle: const TextStyle(
            color: Colors.white,
            letterSpacing: 3,
            fontSize: 68,
          ),
        ),
        contentTextStyle: const TextStyle(fontSize: 16, color: Colors.white),
        actions: [
          CleanDialogActionButtons(
              actionTitle: 'Try again',
              textColor: const Color.fromARGB(255, 0, 0, 0),
              onPressed: () {
                Navigator.pop(context);
                restart();
              }),
        ],
      ),
    );
  }

  int minimax(int depth, bool isMaximizing) {
    int score = checkWinner();
    if (score == 10 || score == -10) {
      return score;
    }
    if (isMovesLeft() == false) {
      return 0;
    }
    if (isMaximizing) {
      int bestScore = -1000;
      for (int i = 0; i < 9; i++) {
        if (displayXO[i] == '') {
          displayXO[i] = 'X';
          int score = minimax(depth + 1, !isMaximizing);
          bestScore = max(bestScore, score);
          displayXO[i] = '';
        }
      }
      return bestScore;
    } else {
      int bestScore = 1000;
      for (int i = 0; i < 9; i++) {
        if (displayXO[i] == '') {
          displayXO[i] = 'O';
          int score = minimax(depth + 1, !isMaximizing);
          bestScore = min(bestScore, score);
          displayXO[i] = '';
        }
      }
      return bestScore;
    }
  }

  int checkWinner() {
    for (int i = 0; i < 3; i++) {
      if (displayXO[3 * i + 0] == displayXO[3 * i + 1] &&
          displayXO[3 * i + 1] == displayXO[3 * i + 2]) {
        if (displayXO[3 * i + 0] == 'X') {
          return 10;
        } else if (displayXO[3 * i + 0] == 'O') {
          return -10;
        } else {
          return 0;
        }
      }
    }
    for (int i = 0; i < 3; i++) {
      if (displayXO[i] == displayXO[3 + i] &&
          displayXO[i] == displayXO[6 + i]) {
        if (displayXO[i] == 'X') {
          return 10;
        } else if (displayXO[i] == 'O') {
          return -10;
        } else {
          return 0;
        }
      }
    }
    if ((displayXO[0] == displayXO[4] && displayXO[0] == displayXO[8]) ||
        (displayXO[2] == displayXO[4] && displayXO[2] == displayXO[6])) {
      if (displayXO[4] == 'X') {
        return 10;
      } else if (displayXO[4] == 'O') {
        return -10;
      } else {
        return 0;
      }
    }
    return 0;
  }

  bool isMovesLeft() {
    if (displayXO[0] != '' &&
        displayXO[1] != '' &&
        displayXO[2] != '' &&
        displayXO[3] != '' &&
        displayXO[4] != '' &&
        displayXO[5] != '' &&
        displayXO[6] != '' &&
        displayXO[7] != '' &&
        displayXO[8] != '') {
      return false;
    }
    return true;
  }

  void restart() {
    for (int i = 0; i < 9; i++) {
      displayXO[i] = '';
    }
    setState(() {});
  }
}
