import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../models/floatoon_action.dart';

/// Different motion states for Floatoon
enum FloatoonState {
  bottomWalk,   // Walking left-to-right rounds at the bottom
  flyingUp,     // Flying up towards the top
  fallingDown,  // Dropping down to the bottom
  idleRest,     // Stopped at the bottom for 4-5 seconds
  dragging,     // Being dragged by the user
  following,    // Tracking & pursuing target character for an action (hug/kiss/propose)
  interacting,  // Close enough! Locked in interaction for 3-4s with controls disabled
}

/// Advanced controller managing Floatoon movement, physics, routines, touch dragging,
/// dynamic partner tracking, and multi-user interaction states.
class FloatoonController extends ChangeNotifier {
  final String id;
  final String displayName;
  final bool startsOnLeft;
  final Size characterSize;
  final math.Random _random = math.Random();

  Size _screenSize = const Size(360, 640);
  Offset _currentOffset = Offset.zero;
  bool _isFacingRight = true;
  bool _isDragging = false;
  bool isControlsDisabled = false;

  FloatoonState _state = FloatoonState.bottomWalk;

  // Active interaction tracking
  FloatoonAction? _activeAction;
  FloatoonController? _targetCharacter;
  Timer? _actionTimer;

  // Callbacks for WebSocket & UI notifications
  void Function(Map<String, dynamic> eventPayload)? onEmitWebSocketEvent;
  void Function(FloatoonAction action, FloatoonController source, FloatoonController target)? onActionStarted;
  void Function(FloatoonAction action, FloatoonController source, FloatoonController target)? onActionCompleted;

  // Walk round tracking (randomized passes and mid-walk pauses)
  int _walkPassCount = 0;
  int _targetPasses = 3;
  bool _isWalkPaused = false;
  Timer? _walkPauseTimer;
  double? _nextMidPauseX;

  // Active wall for climbing / descending (Left or Right)
  bool _activeWallIsLeft = true;

  // Speeds (px/s)
  final double _walkSpeed = 110.0;    // horizontal walk
  final double _flySpeedY = 140.0;    // upward flight
  final double _fallSpeed = 140.0;    // downward descent
  final double _pursuitSpeed = 185.0; // dynamic tracking/following speed

  Timer? _restTimer;
  Ticker? _ticker;
  Duration _lastTick = Duration.zero;

  FloatoonController({
    this.id = 'user_1',
    this.displayName = 'You',
    this.startsOnLeft = true,
    this.characterSize = const Size(60, 60),
    this.onEmitWebSocketEvent,
    this.onActionStarted,
    this.onActionCompleted,
  }) {
    _state = FloatoonState.bottomWalk;
    _isFacingRight = startsOnLeft;
    _activeWallIsLeft = startsOnLeft;
  }

  // Getters
  Offset get offset => _currentOffset;
  bool get isFacingRight => _isFacingRight;
  bool get isDragging => _isDragging;
  FloatoonState get state => _state;
  FloatoonAction? get activeAction => _activeAction;
  FloatoonController? get targetCharacter => _targetCharacter;

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
      // If startsOnLeft, place at left bottom; else place at right bottom
      final double startX = startsOnLeft ? _minX : _maxX;
      _currentOffset = Offset(startX, maxY);
      _isFacingRight = startsOnLeft;
      _walkPassCount = 0;
      _state = FloatoonState.bottomWalk;
    } else {
      _clampPosition();
    }
    notifyListeners();
  }

  // Screen boundary compensation for internal transparent padding in Lottie vector art
  // so the visible character art physically touches all 4 screen edges
  static const double _edgeBleedX = 6.0;
  static const double _edgeBleedTop = 5.0;
  static const double _edgeBleedBottom = 4.0;

  double get _minX => -_edgeBleedX;
  double get _maxX => (_screenSize.width - characterSize.width + _edgeBleedX).clamp(_minX, double.infinity);
  double get _topCeilingY => -_edgeBleedTop;
  double get _bottomFloorY => (_screenSize.height - characterSize.height + _edgeBleedBottom).clamp(_topCeilingY, double.infinity);

  void _clampPosition() {
    _currentOffset = Offset(
      _currentOffset.dx.clamp(_minX, _maxX),
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
      case FloatoonState.following:
        _stepFollowing(dt);
        break;
      case FloatoonState.interacting:
      case FloatoonState.idleRest:
      case FloatoonState.dragging:
        break;
    }
  }

  // --- Step 1: Bottom Walk (Left <-> Right with random mid-walk pauses) ---

  void _startBottomWalk() {
    _state = FloatoonState.bottomWalk;
    _walkPassCount = 0;
    // 2, 3, or 4 passes so it alternates landing on Left and Right
    _targetPasses = 2 + _random.nextInt(3);
    _isWalkPaused = false;
    _walkPauseTimer?.cancel();

    // Walk towards opposite wall along the bottom
    final double midX = (_minX + _maxX) / 2;
    final bool isNearLeft = _currentOffset.dx <= midX;
    _isFacingRight = isNearLeft;

    _scheduleNextMidPause();
    notifyListeners();
  }

  void _scheduleNextMidPause() {
    // 60% chance to schedule a random breather stop mid-walk
    if (_random.nextDouble() < 0.60) {
      final double span = _maxX - _minX;
      _nextMidPauseX = _minX + (span * (0.25 + _random.nextDouble() * 0.50));
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
      if (currentX <= _minX) {
        currentX = _minX;
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

  // --- Step 2: Flying Up (Climbs along Left wall OR Right wall only) ---

  void _startFlyingUp({bool? onLeft}) {
    _state = FloatoonState.flyingUp;
    _walkPauseTimer?.cancel();
    _isWalkPaused = false;

    // Pick Left or Right wall
    if (onLeft != null) {
      _activeWallIsLeft = onLeft;
    } else {
      final double midX = (_minX + _maxX) / 2;
      _activeWallIsLeft = _currentOffset.dx <= midX;
    }

    final double targetX = _activeWallIsLeft ? _minX : _maxX;
    _currentOffset = Offset(targetX, _currentOffset.dy);
    _isFacingRight = _activeWallIsLeft; // Face inward towards screen
    notifyListeners();
  }

  void _stepFlyingUp(double dt) {
    final double targetX = _activeWallIsLeft ? _minX : _maxX;
    double nextY = _currentOffset.dy - (_flySpeedY * dt);

    // Check if reached top ceiling
    if (nextY <= _topCeilingY) {
      nextY = _topCeilingY;
      // Reached top! Descend smoothly down along this same wall
      _state = FloatoonState.fallingDown;
    }

    _currentOffset = Offset(targetX, nextY);
    _isFacingRight = _activeWallIsLeft;
    notifyListeners();
  }

  // --- Step 3: Falling Down (Drops straight down vertically from release position) ---

  void _stepFallingDown(double dt) {
    final double nextY = _currentOffset.dy + (_fallSpeed * dt);
    // User release in center: fall straight down without steering left or right!
    final double currentX = _currentOffset.dx;

    final double maxY = _bottomFloorY;
    if (nextY >= maxY) {
      _currentOffset = Offset(currentX, maxY);
      // Landed on bottom edge -> Stop and rest for 4 to 5 seconds
      _startBottomRest();
      return;
    }

    _currentOffset = Offset(currentX, nextY);
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
      if (_isDragging || _state == FloatoonState.following || _state == FloatoonState.interacting) return;
      _chooseNextRoutine();
    });
    notifyListeners();
  }

  void _chooseNextRoutine() {
    if (_state == FloatoonState.following || _state == FloatoonState.interacting) return;

    // If dropped in the middle of the bottom floor by user, walk along the bottom floor to a wall
    final bool isAtLeftWall = (_currentOffset.dx - _minX).abs() < 5.0;
    final bool isAtRightWall = (_currentOffset.dx - _maxX).abs() < 5.0;

    if (!isAtLeftWall && !isAtRightWall) {
      // Walk towards wall along the bottom floor
      _startBottomWalk();
      return;
    }

    // It is at one of the walls (Left or Right)
    // Random routine:
    // 50% chance: walk along bottom
    // 50% chance: climb up along this wall
    if (_random.nextBool()) {
      _startBottomWalk();
    } else {
      _startFlyingUp(onLeft: isAtLeftWall);
    }
  }

  // --- Step 5: Dynamic Target Tracking & Follow Logic (Manager's Feature) ---

  /// Initiates an action (Hug, Kiss, Propose) targeting another character
  void triggerAction({
    required FloatoonAction action,
    required FloatoonController target,
    bool emitWebSocket = true,
  }) {
    if (isControlsDisabled) return;

    _activeAction = action;
    _targetCharacter = target;
    _state = FloatoonState.following;
    _restTimer?.cancel();
    _walkPauseTimer?.cancel();
    _isWalkPaused = false;

    if (emitWebSocket) {
      onEmitWebSocketEvent?.call(FloatoonActionEvent(
        action: action,
        fromUserId: id,
        toUserId: target.id,
      ).toJson());
    }

    notifyListeners();
  }

  /// Called on each tick while following another character
  void _stepFollowing(double dt) {
    if (_targetCharacter == null || _activeAction == null) {
      _startBottomWalk();
      return;
    }

    final targetCenter = Offset(
      _targetCharacter!.offset.dx + (_targetCharacter!.characterSize.width / 2),
      _targetCharacter!.offset.dy + (_targetCharacter!.characterSize.height / 2),
    );
    final currentCenter = Offset(
      _currentOffset.dx + (characterSize.width / 2),
      _currentOffset.dy + (characterSize.height / 2),
    );

    final double dx = targetCenter.dx - currentCenter.dx;
    final double dy = targetCenter.dy - currentCenter.dy;
    final double distance = math.sqrt(dx * dx + dy * dy);

    // Close enough contact threshold (when characters are side by side)
    final double contactThreshold = characterSize.width * 0.90;

    if (distance <= contactThreshold) {
      // Close enough! Lock movement controls and initiate action
      _beginInteraction();
      return;
    }

    // Continuously pursue the target character (even if other character moves or gets dragged!)
    final double step = _pursuitSpeed * dt;
    final double ratio = (step / distance).clamp(0.0, 1.0);

    final double nextX = _currentOffset.dx + (dx * ratio);
    final double nextY = _currentOffset.dy + (dy * ratio);

    _currentOffset = Offset(
      nextX.clamp(_minX, _maxX),
      nextY.clamp(_topCeilingY, _bottomFloorY),
    );

    // Keep facing towards target
    if (dx.abs() > 1.0) {
      _isFacingRight = dx > 0;
    }
    notifyListeners();
  }

  /// Locks movement controls and triggers the 3-4s action animation
  void _beginInteraction() {
    _state = FloatoonState.interacting;
    isControlsDisabled = true;

    final target = _targetCharacter;
    if (target != null) {
      target._state = FloatoonState.interacting;
      target.isControlsDisabled = true;
      target._activeAction = _activeAction;
      target._targetCharacter = this;

      // Both face each other!
      final double dx = target.offset.dx - _currentOffset.dx;
      _isFacingRight = dx >= 0;
      target._isFacingRight = dx < 0;

      target.notifyListeners();
    }

    notifyListeners();
    if (_activeAction != null && target != null) {
      onActionStarted?.call(_activeAction!, this, target);
    }

    // Action completes in 3.5 seconds
    _actionTimer?.cancel();
    _actionTimer = Timer(const Duration(milliseconds: 3500), () {
      _completeInteraction();
    });
  }

  /// Interaction duration ended: re-enable controls and resume normal stroll
  void _completeInteraction() {
    final completedAction = _activeAction;
    final partner = _targetCharacter;

    _activeAction = null;
    _targetCharacter = null;
    isControlsDisabled = false;
    _startBottomRest();

    if (partner != null) {
      partner._actionTimer?.cancel();
      partner._activeAction = null;
      partner._targetCharacter = null;
      partner.isControlsDisabled = false;
      partner._startBottomRest();
      partner.notifyListeners();
    }

    notifyListeners();
    if (completedAction != null && partner != null) {
      onActionCompleted?.call(completedAction, this, partner);
    }
  }

  /// Cancels an in-progress following/interacting state
  void cancelAction() {
    _actionTimer?.cancel();
    _activeAction = null;
    _targetCharacter = null;
    isControlsDisabled = false;
    _startBottomWalk();
    notifyListeners();
  }

  // --- Step 6: User Touch & Drag Handlers ---

  void onDragStart(Offset fingerGlobalPos) {
    if (isControlsDisabled) return; // Controls disabled during hug/kiss/propose
    _isDragging = true;
    _state = FloatoonState.dragging;
    _restTimer?.cancel();
    _walkPauseTimer?.cancel();
    _isWalkPaused = false;
    _updatePositionAboveFinger(fingerGlobalPos);
    notifyListeners();
  }

  void onDragUpdate(Offset fingerGlobalPos, Offset delta) {
    if (!_isDragging || isControlsDisabled) return;

    if (delta.dx.abs() > 0.8) {
      _isFacingRight = delta.dx > 0;
    }

    _updatePositionAboveFinger(fingerGlobalPos);
    notifyListeners();
  }

  /// Places character comfortably above user's finger so the finger doesn't block the cartoon
  void _updatePositionAboveFinger(Offset fingerPos) {
    final double targetX = (fingerPos.dx - (characterSize.width / 2)).clamp(_minX, _maxX);
    // Keep character ~55px above finger position so it is fully visible above the finger
    final double targetY = (fingerPos.dy - characterSize.height - 55.0).clamp(_topCeilingY, _bottomFloorY);

    _currentOffset = Offset(targetX, targetY);
  }

  void onDragEnd(Offset flingVelocity) {
    if (isControlsDisabled) return;
    _isDragging = false;
    final double maxY = _bottomFloorY;

    // If released near bottom floor without upward fling:
    if (_currentOffset.dy >= maxY - 40.0 && flingVelocity.dy >= -100) {
      _currentOffset = Offset(_currentOffset.dx, maxY);
      _startBottomRest();
    } else {
      // Released in the air: fall straight down vertically from current position!
      _state = FloatoonState.fallingDown;
    }
    notifyListeners();
  }

  /// Synchronize position from a remote partner received via WebSocket
  void applyRemotePosition({
    required double x,
    required double y,
    bool isFacingRight = true,
  }) {
    _currentOffset = Offset(x.clamp(_minX, _maxX), y.clamp(_topCeilingY, _bottomFloorY));
    _isFacingRight = isFacingRight;
    notifyListeners();
  }

  @override
  void dispose() {
    _ticker?.dispose();
    _restTimer?.cancel();
    _walkPauseTimer?.cancel();
    _actionTimer?.cancel();
    super.dispose();
  }
}
