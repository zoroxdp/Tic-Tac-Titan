import 'package:flat_3d_button/flat_3d_button.dart';
import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import 'colors.dart';
import 'game.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColor.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'dash',
              child:
                  Image.asset('images/game_logo.png', height: 350, width: 350),
            ),
            const SizedBox(
              height: 30,
            ),
            Hero(
              tag: 'sqsh',
              child: Flat3dButton.text(
                padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                color: Colors.teal,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GameScreen(),
                    ),
                  );
                },
                text: 'PLAY',
              ),
            ),

            TextButton(
              style: const ButtonStyle(overlayColor: MaterialStatePropertyAll(Color.fromARGB(0, 0, 0, 0))),
              onPressed: () {
                final snackBar = SnackBar(
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: 'Tic-Tac-Toe Game',
                    message:
                        'Made by DP Shekhawat 🙂',
                    contentType: ContentType.help,
                  ),
                );
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);
              },
              child: const Icon(Icons.info_outline),
            ),
          ],
        ),
      ),
    );
  }
}
