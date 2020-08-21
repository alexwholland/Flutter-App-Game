import 'dart:ui';

import 'package:flutter/cupertino.dart';

import 'game_controller.dart';

class EnemyBoss {
  final GameController gameController;
  int health;
  int damage;
  double speed;
  Rect enemyRectB;
  bool isDead = false;

  EnemyBoss(this.gameController, double x, double y) {
    health = 6;
    damage = 1;
    speed = gameController.tileSize * 2;
    enemyRectB = Rect.fromLTWH(
      x,
      y,
      gameController.tileSize * 1.8,
      gameController.tileSize * 1.8,
    );
  }

  void render(Canvas c) {
    Color color;
    switch (health) {
      case 1:
        color = Color(0xFFAED581);
        break;
      case 2:
        color = Color(0xFF9CCC65);
        break;
      case 3:
        color = Color(0xFF8BC34A);
        break;
      case 4:
        color = Color(0xFF7CB342);
        break;
      case 5:
        color = Color(0xFF689F38);
        break;
      case 6:
        color = Color(0xFF558B2F);
        break;
      default:
        color = Color(0xFFFF0000);
        break;
    }
    Paint enemyColor = Paint()..color = color;
    c.drawRect(enemyRectB, enemyColor);
  }

  void update(double t) {
    if (!isDead) {
      double stepDistance = speed * t;
      Offset toPlayer =
          gameController.player.playerRect.center - enemyRectB.center;
      if (stepDistance <= toPlayer.distance - gameController.tileSize * 1.25) {
        Offset stepToPlayer =
        Offset.fromDirection(toPlayer.direction, stepDistance);
        enemyRectB = enemyRectB.shift(stepToPlayer);
      } else {
        attack();
      }
    }
  }

  void attack() {
    if (!gameController.player.isDead) {
      gameController.player.currentHealth -= damage;
    }
  }

  void onTapDown() {
    if (!isDead) {
      health--;
      if (health <= 0) {
        isDead = true;
        gameController.score++;
        if (gameController.score > (gameController.storage.getInt('highscore') ?? 0)) {
          gameController.storage.setInt('highscore', gameController.score);
        }
      }
    }
  }
}