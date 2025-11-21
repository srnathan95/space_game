class Rocket {
  double position; // 0.0 to 1.0

  Rocket() : position = 0.5;

  void move(double dx) {
    position += dx;
    if (position < 0) position = 0;
    if (position > 1) position = 1;
  }
}
