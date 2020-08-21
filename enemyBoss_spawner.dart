import 'package:final_game/enemy_boss.dart';

import 'enemy_boss.dart';
import 'game_controller.dart';

class EnemySpawnerBoss {
  final GameController gameController;
  final int maxSpawnInterval = 12000;
  final int minSpawnInterval = 6000;
  final int intervalChange = 3;
  final int maxEnemies = 7;
  int currentInterval;
  int nextSpawn;

  EnemySpawnerBoss(this.gameController) {
    initialize();
  }

  void initialize() {
    killAllEnemies();
    currentInterval = maxSpawnInterval;
    nextSpawn = DateTime.now().millisecondsSinceEpoch + currentInterval;
  }

  void killAllEnemies() {
    gameController.enemiesB.forEach((EnemyBoss enemyB) => enemyB.isDead = true);
  }

  void update(double t) {
    int now = DateTime.now().millisecondsSinceEpoch;
    if (gameController.enemiesB.length < maxEnemies && now >= nextSpawn) {
      gameController.spawnEnemyBoss();
      if (currentInterval > minSpawnInterval) {
        currentInterval -= intervalChange;
        currentInterval -= (currentInterval * 0.1).toInt();
      }
      nextSpawn = now + currentInterval;
    }
  }

}