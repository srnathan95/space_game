import 'dart:math';
import 'game_config.dart';

class Asteroid {
  double x;
  double y;
  double speed;

  Asteroid(this.x, this.y, this.speed);

  factory Asteroid.random(double speedMultiplier) {
    final random = Random();
    // Base speed range with config constants
    final baseSpeed = GameConfig.asteroidSpeedMin +
        random.nextDouble() *
            (GameConfig.asteroidSpeedMax - GameConfig.asteroidSpeedMin);
    final finalSpeed = baseSpeed * speedMultiplier;

    return Asteroid(
      random.nextDouble(), // Random X position
      0, // Start at top
      finalSpeed, // Speed with multiplier applied
    );
  }

  void update(double deltaTime) {
    y += speed * deltaTime * 60; // Move down
  }
}
