import 'dart:math';
import 'dart:ui';

import 'package:final_game/buy_menu.dart';
import 'package:final_game/enemyBoss_spawner.dart';
import 'package:final_game/enemy_boss.dart';
import 'package:final_game/player.dart';
import 'package:final_game/score_text.dart';
import 'package:final_game/start_text.dart';
import 'package:final_game/state.dart' as im;
import 'package:flame/flame.dart';
import 'package:flame/game/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'enemy_boss.dart';
import 'enemy.dart';
import 'enemy_spawner.dart';
import 'health_bar.dart';
import 'highscore_text.dart';

class GameController extends Game {
  final SharedPreferences storage;
  Random rand;
  Size screenSize;
  double tileSize;
  Player player;
  EnemySpawner enemySpawner;
  EnemySpawnerBoss enemySpawnerBoss;
  List<Enemy> enemies;
  List<EnemyBoss> enemiesB;
  HealthBar healthBar;
  int score;
  ScoreText scoreText;
  im.State state;
  HighscoreText highscoreText;
  StartText startText;
  BuyMenu buyMenu;

  GameController(this.storage) {
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    state = im.State.menu;
    rand = Random();
    player = Player(this);
    enemies = List<Enemy>();
    enemiesB = List<EnemyBoss>();
    enemySpawnerBoss = EnemySpawnerBoss(this);
    enemySpawner = EnemySpawner(this);
    healthBar = HealthBar(this);
    score = 0;
    scoreText = ScoreText(this);
    highscoreText = HighscoreText(this);
    startText = StartText(this);
    buyMenu = BuyMenu(this);
  }

  void render(Canvas c) {
    Rect background = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    Paint backgroundPaint = Paint()..color = Color(0xFFFAFAFA);
    c.drawRect(background, backgroundPaint);

    player.render(c);

    if (state == im.State.menu) {
      startText.render(c);
      highscoreText.render(c);
      buyMenu.render(c);
    } else if (state == im.State.playing) {
      enemiesB.forEach((EnemyBoss enemyB) => enemyB.render(c));
      enemies.forEach((Enemy enemy) => enemy.render(c));
      scoreText.render(c);
      healthBar.render(c);
    }
  }

  void update(double t) {
    if (state == im.State.menu) {
      startText.update(t);
      highscoreText.update(t);
      buyMenu.update(t);
    } else if (state == im.State.playing) {
      enemySpawner.update(t);
      enemySpawnerBoss.update(t);
      enemiesB.forEach((EnemyBoss enemyB) => enemyB.update(t));
      enemies.forEach((Enemy enemy) => enemy.update(t));
      enemiesB.removeWhere((EnemyBoss enemyB) => enemyB.isDead);
      enemies.removeWhere((Enemy enemy) => enemy.isDead);
      player.update(t);
      scoreText.update(t);
      healthBar.update(t);
    }
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 10;
  }

  void onTapDown(TapDownDetails d) {
    if (state == im.State.menu) {
      state = im.State.playing;
    } else if (state == im.State.playing) {
      enemiesB.forEach((EnemyBoss enemyB) {
        if (enemyB.enemyRectB.contains(d.globalPosition)) {
          enemyB.onTapDown();
        }
      });
      enemies.forEach((Enemy enemy) {
        if (enemy.enemyRect.contains(d.globalPosition)) {
          enemy.onTapDown();
        }
      });
    }
  }

  void spawnEnemyBoss(){
    double x, y;
    switch (rand.nextInt(4)) {
      case 0:
      // Top
        x = rand.nextDouble() * screenSize.width;
        y = -tileSize * 2.5;
        break;
      case 1:
      // Right
        x = screenSize.width + tileSize * 2.5;
        y = rand.nextDouble() * screenSize.height;
        break;
      case 2:
      // Bottom
        x = rand.nextDouble() * screenSize.width;
        y = screenSize.height + tileSize * 2.5;
        break;
      case 3:
      // Left
        x = -tileSize * 2.5;
        y = rand.nextDouble() * screenSize.height;
        break;
    }
    enemiesB.add(EnemyBoss(this, x, y));
  }

    void spawnEnemy() {
      double x, y;
      switch (rand.nextInt(4)) {
        case 0:
        // Top
          x = rand.nextDouble() * screenSize.width;
          y = -tileSize * 2.5;
          break;
        case 1:
        // Right
          x = screenSize.width + tileSize * 2.5;
          y = rand.nextDouble() * screenSize.height;
          break;
        case 2:
        // Bottom
          x = rand.nextDouble() * screenSize.width;
          y = screenSize.height + tileSize * 2.5;
          break;
        case 3:
        // Left
          x = -tileSize * 2.5;
          y = rand.nextDouble() * screenSize.height;
          break;
      }
      enemies.add(Enemy(this, x, y));
    }

}