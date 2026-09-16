import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Different motion states for Floatoon
enum FloatoonState {
  bottomWalk,  // Walking left-to-right rounds at the bottom
  flyingUp,    // Flying up towards the top
  fallingDown, // Dropping down to the bottom
  idleRest,    // Stopped at the bottom for 4-5 seconds
  dragging,    // Being dragged by the user
}

/// Simple, clean controller managing Floatoon movement, routines, and touch dragging.
class FloatoonController extends ChangeNotifier {
  final Size characterSize;
  final math.Random _random = math.Random();

  Size _screenSize = const Size(360, 640);
  Offset _currentOffset = Offset.zero;
  bool _isFacingRight = true;
  bool _isDragging = false;

  FloatoonState _state = FloatoonState.bottomWalk;

  // Walk round tracking (randomized passes and mid-walk pauses)
  int _walkPassCount = 0;
  int _targetPasses = 3;
  bool _isWalkPaused = false;
  Timer? _walkPauseTimer;
  double? _nextMidPauseX;

  // Active wall for climbing / descending (Left or Right)
  bool _activeWallIsLeft = true;

  // Speeds (up and down speeds are identical)
  final double _walkSpeed = 110.0; // px/s horizontal walk
  final double _flySpeedY = 140.0; // px/s upward flight
  final double _fallSpeed = 140.0; // px/s downward descent (same gentle speed as going up)

  Timer? _restTimer;
  Ticker? _ticker;
  Duration _lastTick = Duration.zero;

  FloatoonController({
    this.characterSize = const Size(60, 60),
  }) {
    // Initial routine starts at bottom walk
    _state = FloatoonState.bottomWalk;
  }

  // Getters
  Offset get offset => _currentOffset;
  bool get isFacingRight => _isFacingRight;
  bool get isDragging => _isDragging;
  FloatoonState get state => _state;

  /// Start 60/120fps physics and movement loop
  void initTicker(TickerProvider vsync) {
    _ticker?.dispose();
    _ticker = vsync.createTicker(_handleTick);
    _lastTick = Duration.zero;
    _ticker?.start();
  }

  /// Update screen size and position at bottom on initial launch
  void updateScreenSize(Size size) {
    if (size == Size.zero || size == _screenSize) return;
    final bool isFirstTime = (_screenSize == const Size(360, 640));
    _screenSize = size;

    final double maxY = _bottomFloorY;
    if (isFirstTime || _currentOffset == Offset.zero) {
      // Start at bottom-left corner
      _currentOffset = Offset(20, maxY);
      _isFacingRight = true;
      _walkPassCount = 0;
      _state = FloatoonState.bottomWalk;
    } else {
      _clampPosition();
    }
    notifyListeners();
  }

  double get _maxX => (_screenSize.width - characterSize.width).clamp(0.0, double.infinity);
  double get _bottomFloorY => (_screenSize.height - characterSize.height - 25.0).clamp(0.0, double.infinity);
  double get _topCeilingY => 30.0;

  void _clampPosition() {
    _currentOffset = Offset(
      _currentOffset.dx.clamp(0.0, _maxX),
      _currentOffset.dy.clamp(_topCeilingY, _bottomFloorY),
    );
  }

  /// Frame tick: updates character position according to active state
  void _handleTick(Duration elapsed) {
    if (_lastTick == Duration.zero) {
      _lastTick = elapsed;
      return;
    }

    final double dt = (elapsed - _lastTick).inMicroseconds / 1000000.0;
    _lastTick = elapsed;

    if (dt <= 0 || dt > 0.1 || _isDragging) return;

    switch (_state) {
      case FloatoonState.bottomWalk:
        _stepBottomWalk(dt);
        break;
      case FloatoonState.flyingUp:
        _stepFlyingUp(dt);
        break;
      case FloatoonState.fallingDown:
        _stepFallingDown(dt);
        break;
      case FloatoonState.idleRest:
      case FloatoonState.dragging:
        break;
    }
  }

  // --- Step 1: Bottom Walk (Left <-> Right with random mid-walk pauses) ---

  void _startBottomWalk() {
    _state = FloatoonState.bottomWalk;
    _walkPassCount = 0;
    // 2, 3, or 4 passes so it alternates landing on Left and Right!
    _targetPasses = 2 + _random.nextInt(3);
    _isWalkPaused = false;
    _walkPauseTimer?.cancel();

    // Walk towards opposite wall along the bottom
    final bool isNearLeft = _currentOffset.dx <= (_maxX / 2);
    _isFacingRight = isNearLeft;

    _scheduleNextMidPause();
    notifyListeners();
  }

  void _scheduleNextMidPause() {
    // 60% chance to schedule a random breather stop mid-walk
    if (_random.nextDouble() < 0.60) {
      // Pick random spot between 25% and 75% of bottom floor
      _nextMidPauseX = _maxX * (0.25 + _random.nextDouble() * 0.50);
    } else {
      _nextMidPauseX = null;
    }
  }

  void _stepBottomWalk(double dt) {
    if (_isWalkPaused) return;

    final double maxY = _bottomFloorY;
    double currentX = _currentOffset.dx;

    // Check if reached scheduled mid-walk pause spot
    if (_nextMidPauseX != null) {
      final bool reached = _isFacingRight
          ? currentX >= _nextMidPauseX!
          : currentX <= _nextMidPauseX!;
      if (reached) {
        _nextMidPauseX = null;
        _isWalkPaused = true;
        _walkPauseTimer?.cancel();
        // Pause randomly between 1.5 to 3 seconds, then resume walking
        final int pauseMs = 1500 + _random.nextInt(1500);
        _walkPauseTimer = Timer(Duration(milliseconds: pauseMs), () {
          _isWalkPaused = false;
          notifyListeners();
        });
        notifyListeners();
        return;
      }
    }

    if (_isFacingRight) {
      currentX += _walkSpeed * dt;
      if (currentX >= _maxX) {
        currentX = _maxX;
        _walkPassCount++;
        // If finished target passes, climb up the RIGHT wall!
        if (_walkPassCount >= _targetPasses) {
          _startFlyingUp(onLeft: false);
          return;
        } else {
          _isFacingRight = false; // Turn left
          _scheduleNextMidPause();
        }
      }
    } else {
      currentX -= _walkSpeed * dt;
      if (currentX <= 0) {
        currentX = 0;
        _walkPassCount++;
        // If finished target passes, climb up the LEFT wall!
        if (_walkPassCount >= _targetPasses) {
          _startFlyingUp(onLeft: true);
          return;
        } else {
          _isFacingRight = true; // Turn right
          _scheduleNextMidPause();
        }
      }
    }

    _currentOffset = Offset(currentX, maxY);
    notifyListeners();
  }

  // --- Step 2: Flying Up (Randomly along Left wall OR Right wall) ---

  void _startFlyingUp({bool? onLeft}) {
    _state = FloatoonState.flyingUp;
    _walkPauseTimer?.cancel();
    _isWalkPaused = false;

    // Pick Left or Right wall
    if (onLeft != null) {
      _activeWallIsLeft = onLeft;
    } else {
      _activeWallIsLeft = _currentOffset.dx <= (_maxX / 2);
    }

    final double targetX = _activeWallIsLeft ? 0.0 : _maxX;
    _currentOffset = Offset(targetX, _currentOffset.dy);
    _isFacingRight = _activeWallIsLeft; // Face inward towards screen
    notifyListeners();
  }

  void _stepFlyingUp(double dt) {
    final double targetX = _activeWallIsLeft ? 0.0 : _maxX;
    double nextY = _currentOffset.dy - (_flySpeedY * dt);

    // Check if reached top end
    if (nextY <= _topCeilingY) {
      nextY = _topCeilingY;
      // Reached top! Descend smoothly down along this same wall
      _state = FloatoonState.fallingDown;
    }

    _currentOffset = Offset(targetX, nextY);
    _isFacingRight = _activeWallIsLeft;
    notifyListeners();
  }

  // --- Step 3: Falling Down (Descends down along Left or Right wall) ---

  void _stepFallingDown(double dt) {
    double nextY = _currentOffset.dy + (_fallSpeed * dt);

    final double targetX = _activeWallIsLeft ? 0.0 : _maxX;
    double nextX = _currentOffset.dx;
    if ((nextX - targetX).abs() > 1.0) {
      nextX = nextX + (targetX - nextX) * (dt * 8.0);
    } else {
      nextX = targetX;
    }

    final double maxY = _bottomFloorY;
    if (nextY >= maxY) {
      nextY = maxY;
      _currentOffset = Offset(targetX, maxY);
      // Landed on bottom edge -> Stop for 4 to 5 seconds
      _startBottomRest();
      return;
    }

    _currentOffset = Offset(nextX, nextY);
    _isFacingRight = _activeWallIsLeft;
    notifyListeners();
  }

  // --- Step 4: Resting 4 to 5 Seconds at Bottom ---

  void _startBottomRest() {
    _state = FloatoonState.idleRest;
    _currentOffset = Offset(_currentOffset.dx, _bottomFloorY);
    _restTimer?.cancel();
    _walkPauseTimer?.cancel();
    _isWalkPaused = false;

    // Rest for 4 to 5 seconds
    final int restSeconds = 4 + _random.nextInt(2);
    _restTimer = Timer(Duration(seconds: restSeconds), () {
      if (_isDragging) return;
      _chooseNextRoutine();
    });
    notifyListeners();
  }

  void _chooseNextRoutine() {
    // Random routine after rest:
    // 50% chance: walk along bottom
    // 50% chance: climb up along the current wall (Left or Right)
    if (_random.nextBool()) {
      _startBottomWalk();
    } else {
      final bool isNearLeft = _currentOffset.dx <= (_maxX / 2);
      _startFlyingUp(onLeft: isNearLeft);
    }
  }

  // --- User Touch & Drag Handlers ---

  void onDragStart(Offset fingerGlobalPos) {
    _isDragging = true;
    _state = FloatoonState.dragging;
    _restTimer?.cancel();
    _walkPauseTimer?.cancel();
    _isWalkPaused = false;
    _updatePositionAboveFinger(fingerGlobalPos);
    notifyListeners();
  }

  void onDragUpdate(Offset fingerGlobalPos, Offset delta) {
    if (!_isDragging) return;

    if (delta.dx.abs() > 0.8) {
      _isFacingRight = delta.dx > 0;
    }

    _updatePositionAboveFinger(fingerGlobalPos);
    notifyListeners();
  }

  /// Places character slightly above user's finger so the finger doesn't block the cartoon
  void _updatePositionAboveFinger(Offset fingerPos) {
    final double targetX = (fingerPos.dx - (characterSize.width / 2)).clamp(0.0, _maxX);
    // Keep character ~25px above finger position
    final double targetY = (fingerPos.dy - characterSize.height - 25.0).clamp(_topCeilingY, _bottomFloorY);

    _currentOffset = Offset(targetX, targetY);
  }

  void onDragEnd(Offset flingVelocity) {
    _isDragging = false;
    final double maxY = _bottomFloorY;

    // If released near bottom floor without upward fling:
    if (_currentOffset.dy >= maxY - 40.0 && flingVelocity.dy >= -100) {
      _startBottomRest();
    } else {
      // Released in the air: assign closest wall to descend along
      _activeWallIsLeft = _currentOffset.dx <= (_maxX / 2);
      _state = FloatoonState.fallingDown;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _ticker?.dispose();
    _restTimer?.cancel();
    _walkPauseTimer?.cancel();
    super.dispose();
  }
}
