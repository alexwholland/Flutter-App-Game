
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'game_controller.dart';

class HighscoreText {
  final GameController gameController;
  TextPainter painter;
  Offset position;

  HighscoreText(this.gameController) {
    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    position = Offset.zero;
  }

  void render(Canvas c) {
    painter.paint(c, position);
  }

  void update(double t) {
    int highscore = gameController.storage.getInt('highscore') ?? 0;
    painter.text = TextSpan(
      style: new TextStyle(
        fontSize: 50.0,
        color: Colors.black,
      ),
      children: <TextSpan>[
        new TextSpan(text: 'Highscore:'),
        new TextSpan(text: ' $highscore', style: new TextStyle(fontWeight: FontWeight.bold),),
      ],
    );
    painter.layout();

    position = Offset(
      (gameController.screenSize.width / 2) - (painter.width / 2),
      (gameController.screenSize.height * 0.2) - (painter.height / 2),
    );
  }
}