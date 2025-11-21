// Game configuration constants

class GameConfig {
  // Timer settings
  static const int gameDurationSeconds = 20;

  // Asteroid spawn settings
  static const int asteroidSpawnIntervalMs = 1000; // Spawn every 1 second

  // Bullet spawn settings
  static const int bulletSpawnIntervalMs = 500; // Spawn every 250ms
  static const double bulletSpeed = 0.009; // Bullet movement speed

  // Asteroid speed settings
  static const double asteroidSpeedMin = 0.008;
  static const double asteroidSpeedMax = 0.017;
  static const double asteroidSpeedMultiplierStart = 0.5;
  static const double asteroidSpeedMultiplierMax = 2.5;
  static const double asteroidSpeedMultiplierRate = 0.01; // Increase per second

  // Rocket movement settings
  static const double rocketMoveDistance = 0.08;

  // Background scroll settings
  static const double backgroundScrollSpeed = 0.01;

  // Collision detection settings
  static const double collisionThreshold = 0.08;

  // Game loop settings
  static const int frameDelayMs = 16; // ~60 FPS
}
