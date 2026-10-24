/// Represents interactive couple / friend actions between two Floatoon characters
enum FloatoonAction {
  hug,
  kiss,
  propose;

  String get id {
    switch (this) {
      case FloatoonAction.hug:
        return 'hug';
      case FloatoonAction.kiss:
        return 'kiss';
      case FloatoonAction.propose:
        return 'propose';
    }
  }

  String get label {
    switch (this) {
      case FloatoonAction.hug:
        return 'Hug';
      case FloatoonAction.kiss:
        return 'Kiss';
      case FloatoonAction.propose:
        return 'Propose';
    }
  }

  String get emoji {
    switch (this) {
      case FloatoonAction.hug:
        return '🤗';
      case FloatoonAction.kiss:
        return '💋';
      case FloatoonAction.propose:
        return '💍';
    }
  }

  String get activeStatusText {
    switch (this) {
      case FloatoonAction.hug:
        return 'Hugging... 🤗';
      case FloatoonAction.kiss:
        return 'Kissing... 💋';
      case FloatoonAction.propose:
        return 'Proposing... 💍';
    }
  }

  static FloatoonAction fromId(String id) {
    switch (id.toLowerCase().trim()) {
      case 'kiss':
        return FloatoonAction.kiss;
      case 'propose':
        return FloatoonAction.propose;
      case 'hug':
      default:
        return FloatoonAction.hug;
    }
  }
}

/// Ready-to-send WebSocket action event payload
class FloatoonActionEvent {
  final FloatoonAction action;
  final String fromUserId;
  final String toUserId;
  final int timestamp;

  FloatoonActionEvent({
    required this.action,
    required this.fromUserId,
    required this.toUserId,
    int? timestamp,
  }) : timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toJson() {
    return {
      'type': 'FLOATOON_ACTION',
      'action': action.id,
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'timestamp': timestamp,
    };
  }

  factory FloatoonActionEvent.fromJson(Map<String, dynamic> json) {
    return FloatoonActionEvent(
      action: FloatoonAction.fromId(json['action']?.toString() ?? 'hug'),
      fromUserId: json['fromUserId']?.toString() ?? '',
      toUserId: json['toUserId']?.toString() ?? '',
      timestamp: json['timestamp'] is int ? json['timestamp'] as int : DateTime.now().millisecondsSinceEpoch,
    );
  }
}

/// Optional real-time position synchronization payload over WebSocket
class FloatoonPositionEvent {
  final String userId;
  final double x;
  final double y;
  final String state;
  final bool isFacingRight;
  final int timestamp;

  FloatoonPositionEvent({
    required this.userId,
    required this.x,
    required this.y,
    required this.state,
    required this.isFacingRight,
    int? timestamp,
  }) : timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toJson() {
    return {
      'type': 'FLOATOON_POSITION',
      'userId': userId,
      'x': x,
      'y': y,
      'state': state,
      'isFacingRight': isFacingRight,
      'timestamp': timestamp,
    };
  }

  factory FloatoonPositionEvent.fromJson(Map<String, dynamic> json) {
    return FloatoonPositionEvent(
      userId: json['userId']?.toString() ?? '',
      x: (json['x'] as num?)?.toDouble() ?? 0.0,
      y: (json['y'] as num?)?.toDouble() ?? 0.0,
      state: json['state']?.toString() ?? 'bottomWalk',
      isFacingRight: json['isFacingRight'] as bool? ?? true,
      timestamp: json['timestamp'] is int ? json['timestamp'] as int : DateTime.now().millisecondsSinceEpoch,
    );
  }
}
