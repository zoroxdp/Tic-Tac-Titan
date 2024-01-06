import 'dart:math';
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
  String winner = '';

  static var customFontWhite = GoogleFonts.coiny(
    textStyle: const TextStyle(
      color: Colors.black,
      letterSpacing: 3,
      fontSize: 28,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColor.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Expanded(
              flex: 1,
              child: Center(child: Text("Tic-Tac-DP")),
            ),
            Expanded(
              flex: 3,
              child: GridView.builder(
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _humanMove(index);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          width: 3,
                          color: MainColor.accentColor,
                        ),
                        color: MainColor.secondaryColor,
                      ),
                      child: Center(
                        child: Text(
                          displayXO[index],
                          style: GoogleFonts.coiny(
                            textStyle: TextStyle(
                              fontSize: 104,
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
            Expanded(
              flex: 1,
              child: Text(
                "Tic-Tac-DP",
                style: customFontWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _humanMove(int index) {
    setState(() {
      if (displayXO[index] == '') {
        displayXO[index] = 'O';
        _aiMove();
      }
    });
  }

  void _aiMove() {
    setState(() {
      int bestScore = -1000;
      int bestmove = -1;
      for (int i = 0; i < 9; i++) {
        if (displayXO[i] == '') {
          displayXO[i] = 'X';
          int score = minimax(0,false);
          displayXO[i] = '';
          if (score > bestScore) {
            bestScore = score;
            bestmove = i;
          }
        }
      }
      if(bestmove != -1){
        displayXO[bestmove] = 'X';
      }
    });
    int winner = checkWinner();
    if(winner != 0){

    }
  }

  int minimax(int depth, bool isMaximizing) {
    int score = checkWinner();
    if (score == 10 || score == -10) {
      return score;
    }
    if(isMovesLeft() == false){
      return 0;
    }
    if (isMaximizing) {
      int bestScore = -1000;
      for (int i = 0; i < 9; i++) {
        if (displayXO[i] == '') {
          displayXO[i] = 'X';
          int score = minimax(depth+1,!isMaximizing);
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
          int score = minimax(depth+1, !isMaximizing);
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
        } else if (displayXO[3 * i + 0] == 'O'){
          return -10;
        }
        else{
          return 0;
        }
      }
    }
    for (int i = 0; i < 3; i++) {
      if (displayXO[i] == displayXO[3 + i] &&
          displayXO[i] == displayXO[6 + i]) {
        if (displayXO[i] == 'X') {
          return 10;
        } else if (displayXO[i] == 'O'){
          return -10;
        }
        else{
          return 0;
        }
      }
    }
    if ((displayXO[0] == displayXO[4] && displayXO[0] == displayXO[8]) ||
        (displayXO[2] == displayXO[4] && displayXO[2] == displayXO[6])) {
      if (displayXO[4] == 'X') {
          return 10;
        } else if (displayXO[4] == 'O'){
          return -10;
        }
        else{
          return 0;
        }
    }
    return 0;
  }
  bool isMovesLeft(){
    if(displayXO[0] != '' && displayXO[1] != '' && displayXO[2] != '' && displayXO[3] != '' && displayXO[4] != '' && 
    displayXO[5] != '' && displayXO[6] != '' && displayXO[7] != '' && displayXO[8] != ''){
      return false;
    }
    return true;
  }
}
