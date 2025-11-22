import 'dart:math';
import 'game_config.dart';

class Asteroid {
  double x;
  double y;
  double speed;
  double horizontalSpeed; // Horizontal movement speed

  Asteroid(this.x, this.y, this.speed, this.horizontalSpeed);

  factory Asteroid.random(double speedMultiplier) {
    final random = Random();
    // Base speed range with config constants
    final baseSpeed = GameConfig.asteroidSpeedMin +
        random.nextDouble() *
            (GameConfig.asteroidSpeedMax - GameConfig.asteroidSpeedMin);
    final finalSpeed = baseSpeed * speedMultiplier;

    // Constrain X position so at least 80% of asteroid is visible
    // Asteroid is 120px wide (60px radius), so we need at least 96px (80%) visible
    // This means the center should be at least 48px from each edge
    // In normalized coordinates (0.0 to 1.0), assuming average screen width ~400px:
    // 48/400 = 0.12, so x should be between 0.12 and 0.88
    // Using a safer range: 0.15 to 0.85 to ensure good visibility
    final minX = 0.15;
    final maxX = 0.85;
    final xPosition = minX + random.nextDouble() * (maxX - minX);

    // Random horizontal speed for bouncing effect (-0.003 to 0.003)
    final horizontalSpeed = (random.nextDouble() - 0.5) * 0.006;

    return Asteroid(
      xPosition, // Constrained X position for better visibility
      0, // Start at top
      finalSpeed, // Speed with multiplier applied
      horizontalSpeed, // Horizontal movement speed
    );
  }

  void update(double deltaTime) {
    y += speed * deltaTime * 60; // Move down
    x += horizontalSpeed * deltaTime * 60; // Move horizontally

    // Bounce off screen edges (asteroid radius is ~0.06 in normalized coords)
    // Using 0.05 and 0.95 as safe bounds to keep asteroid visible
    if (x < 0.05) {
      x = 0.05;
      horizontalSpeed = horizontalSpeed.abs(); // Bounce right
    } else if (x > 0.95) {
      x = 0.95;
      horizontalSpeed = -horizontalSpeed.abs(); // Bounce left
    }
  }
}
