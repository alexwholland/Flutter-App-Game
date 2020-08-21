
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'game_controller.dart';

class BuyMenu{

  final GameController gameController;
  TextPainter painter;
  Offset position;


  BuyMenu(this.gameController) {
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
    painter.text = TextSpan(
      text: 'Buy Prestige',
      style: TextStyle(
        color: Colors.black,
        fontSize: 50.0,
      ),
    );
    painter.layout();

    position = Offset(
      (gameController.screenSize.width / 2) - (painter.width / 2),
      (gameController.screenSize.height * 0.9) - (painter.height / 2),
    );
  }
}


