import 'game_config.dart';

class Bullet {
  double x;
  double y;
  double speed;

  Bullet(double startX)
      : x = startX,
        y = 0.75, // Starting from rocket nozzle (adjusted for higher rocket position)
        speed = GameConfig.bulletSpeed;

  void update(double deltaTime) {
    y -= speed * deltaTime * 60; // Move up
  }

  bool isOffScreen() {
    return y < 0;
  }
}
