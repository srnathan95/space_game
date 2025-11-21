import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import 'rocket.dart';
import 'asteroid.dart';
import 'bullet.dart';
import 'starfield_painter.dart';
import 'game_config.dart';

class SpaceGame extends StatefulWidget {
  const SpaceGame({super.key});

  @override
  State<SpaceGame> createState() => _SpaceGameState();
}

class _SpaceGameState extends State<SpaceGame> {
  // Game state
  bool _isGameRunning = false;
  bool _isGameOver = false;
  int _score = 0;
  int _highScore = 0;
  int _timeLeft = GameConfig.gameDurationSeconds;

  // Game objects
  Rocket _rocket = Rocket();
  List<Asteroid> _asteroids = [];
  List<Bullet> _bullets = [];

  // Game timing
  late DateTime _gameStartTime;
  late DateTime _lastAsteroidSpawn;
  late DateTime _lastUpdate;
  late DateTime _lastSecondUpdate;
  late DateTime _lastBulletSpawn;

  // Background scroll
  double _backgroundOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _loadHighScore().then((_) {
      _startGame();
    });
  }

  Future<void> _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _highScore = prefs.getInt('highScore') ?? 0;
    });
  }

  Future<void> _saveHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('highScore', _highScore);
  }

  void _startGame() {
    setState(() {
      _isGameRunning = true;
      _isGameOver = false;
      _score = 0;
      _timeLeft = GameConfig.gameDurationSeconds; // Reset timer
      _rocket = Rocket();
      _asteroids = [];
      _bullets = [];
      _gameStartTime = DateTime.now();
      _lastAsteroidSpawn = DateTime.now();
      _lastUpdate = DateTime.now();
      _lastSecondUpdate = DateTime.now();
      _lastBulletSpawn = DateTime.now();
    });
    _gameLoop();
  }

  void _updateHighScore() async {
    if (_score > _highScore) {
      setState(() {
        _highScore = _score;
      });
      await _saveHighScore();
    }
  }

  void _gameLoop() async {
    while (_isGameRunning && !_isGameOver) {
      if (mounted) {
        await Future.delayed(
            const Duration(milliseconds: GameConfig.frameDelayMs));
        _update();
      }
    }
  }

  void _update() {
    if (!_isGameRunning || _isGameOver) return;

    final now = DateTime.now();
    final deltaTime = now.difference(_lastUpdate).inMilliseconds / 1000.0;
    _lastUpdate = now;

    // Update timer - decrease every second
    if (now.difference(_lastSecondUpdate).inMilliseconds >= 1000) {
      setState(() {
        _timeLeft--;
        _lastSecondUpdate = now;
      });

      // End game when timer reaches 0
      if (_timeLeft <= 0) {
        _gameOver();
        return;
      }
    }

    // Scroll background down (parallax effect)
    _backgroundOffset += GameConfig.backgroundScrollSpeed * deltaTime * 60;
    if (_backgroundOffset > 1.0) _backgroundOffset -= 1.0;

    // Spawn asteroids
    if (now.difference(_lastAsteroidSpawn).inMilliseconds >
        GameConfig.asteroidSpawnIntervalMs) {
      _spawnAsteroid();
      _lastAsteroidSpawn = now;
    }

    // Auto-shoot bullets
    if (now.difference(_lastBulletSpawn).inMilliseconds >
        GameConfig.bulletSpawnIntervalMs) {
      _bullets.add(Bullet(_rocket.position));
      _lastBulletSpawn = now;
    }

    // Update bullets
    _bullets.removeWhere((bullet) {
      bullet.update(deltaTime);
      return bullet.isOffScreen();
    });

    // Update asteroids
    List<Asteroid> toRemove = [];
    for (var asteroid in _asteroids) {
      asteroid.update(deltaTime);

      // Check if asteroid reached bottom - just remove it (no game over)
      if (asteroid.y > 1.0) {
        toRemove.add(asteroid);
        continue;
      }

      // Check collision with bullets
      for (var bullet in _bullets) {
        if (_checkCollision(asteroid, bullet)) {
          toRemove.add(asteroid);
          _bullets.remove(bullet);
          setState(() {
            _score += 1; // Increment score for each asteroid shot
          });
          break;
        }
      }
    }
    _asteroids.removeWhere((asteroid) => toRemove.contains(asteroid));

    setState(() {});
  }

  void _spawnAsteroid() {
    // Calculate speed multiplier based on game time
    final gameElapsedSeconds =
        DateTime.now().difference(_gameStartTime).inSeconds;
    final speedMultiplier = GameConfig.asteroidSpeedMultiplierStart +
        (gameElapsedSeconds * GameConfig.asteroidSpeedMultiplierRate).clamp(
            0.0,
            GameConfig.asteroidSpeedMultiplierMax -
                GameConfig.asteroidSpeedMultiplierStart);
    _asteroids.add(Asteroid.random(speedMultiplier));
  }

  bool _checkCollision(Asteroid asteroid, Bullet bullet) {
    // Bigger asteroids = bigger hit area
    return asteroid.y < bullet.y + GameConfig.collisionThreshold &&
        asteroid.y > bullet.y - GameConfig.collisionThreshold &&
        (asteroid.x - bullet.x).abs() < GameConfig.collisionThreshold;
  }

  void _moveRocketLeft() {
    if (_isGameRunning && !_isGameOver) {
      setState(() {
        _rocket.move(-GameConfig.rocketMoveDistance);
      });
    }
  }

  void _moveRocketRight() {
    if (_isGameRunning && !_isGameOver) {
      setState(() {
        _rocket.move(GameConfig.rocketMoveDistance);
      });
    }
  }

  void _gameOver() {
    _updateHighScore();
    setState(() {
      _isGameOver = true;
      _isGameRunning = false;
    });
  }

  void _restart() {
    _startGame();
  }

  @override
  void dispose() {
    _isGameRunning = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Space Game'),
        backgroundColor: const Color(0xFF000428),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Time: $_timeLeft',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  'Score: $_score',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Starfield background
          _buildStarfieldBackground(screenSize),

          // Game area
          if (_isGameOver)
            _buildGameOverOverlay(screenSize)
          else
            _buildGameArea(screenSize),

          // Controls
          _buildControls(screenSize),
        ],
      ),
    );
  }

  Widget _buildGameArea(Size screenSize) {
    return Container(
      width: screenSize.width,
      height: screenSize.height,
      child: Stack(
        children: [
          // Asteroids
          ..._asteroids.map((asteroid) => _buildAsteroid(asteroid, screenSize)),

          // Bullets
          ..._bullets.map((bullet) => _buildBullet(bullet, screenSize)),

          // Rocket
          _buildRocket(screenSize),
        ],
      ),
    );
  }

  Widget _buildRocket(Size screenSize) {
    return Positioned(
      left: _rocket.position * screenSize.width - 60,
      top: screenSize.height - 280,
      child: Lottie.asset(
        'assets/animations/Rocket Lunch.json',
        width: 120,
        height: 100,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildAsteroid(Asteroid asteroid, Size screenSize) {
    return Positioned(
      left: asteroid.x * screenSize.width - 30,
      top: asteroid.y * screenSize.height - 30,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey[700],
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey[800]!, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[900]!.withOpacity(0.5),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBullet(Bullet bullet, Size screenSize) {
    return Positioned(
      left: bullet.x * screenSize.width - 3,
      top: bullet.y * screenSize.height - 8,
      child: Container(
        width: 6,
        height: 15,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.yellow, Colors.orange],
          ),
          borderRadius: BorderRadius.circular(3),
          boxShadow: [
            BoxShadow(
              color: Colors.yellow.withOpacity(0.9),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControls(Size screenSize) {
    return Stack(
      children: [
        // Left button - positioned at left edge
        Positioned(
          left: 20,
          bottom: 60,
          child: GestureDetector(
            onTapDown: (_) => _moveRocketLeft(),
            onTapCancel: () {},
            onTapUp: (_) {},
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.3),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child:
                  const Icon(Icons.arrow_back, size: 35, color: Colors.white),
            ),
          ),
        ),

        // Right button - positioned at right edge
        Positioned(
          right: 20,
          bottom: 60,
          child: GestureDetector(
            onTapDown: (_) => _moveRocketRight(),
            onTapCancel: () {},
            onTapUp: (_) {},
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.3),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_forward,
                  size: 35, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStarfieldBackground(Size screenSize) {
    return CustomPaint(
      painter: StarfieldPainter(_backgroundOffset),
      size: Size.infinite,
    );
  }

  Widget _buildGameOverOverlay(Size screenSize) {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "TIME'S UP!",
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Asteroids Shot: $_score',
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'High Score: $_highScore',
              style: TextStyle(
                fontSize: 20,
                color: Colors.yellow[300],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _restart,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text(
                'Play Again',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
