import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/floatoon_action.dart';
import '../controllers/floatoon_controller.dart';

/// Clean WebSocket / Socket.io / Firebase connector bridge.
///
/// Easily plug this into your real backend connection (e.g. `web_socket_channel` or `socket_io_client`).
/// In your app:
/// ```dart
/// final bridge = FloatoonWebSocketBridge(
///   localController: myController,
///   partnerController: partnerController,
///   sendRawMessage: (jsonStr) => socket.sink.add(jsonStr),
/// );
///
/// // When receiving message from socket:
/// bridge.handleIncomingRawMessage(socketEventString);
/// ```
class FloatoonWebSocketBridge {
  final FloatoonController localController;
  final FloatoonController partnerController;
  final void Function(String rawJsonMessage)? sendRawMessage;

  FloatoonWebSocketBridge({
    required this.localController,
    required this.partnerController,
    this.sendRawMessage,
  }) {
    // Listen to local controller actions to emit to remote user
    localController.onEmitWebSocketEvent = (payload) {
      final jsonStr = jsonEncode(payload);
      if (kDebugMode) {
        print('[FloatoonWebSocket] Emitting event: $jsonStr');
      }
      sendRawMessage?.call(jsonStr);
    };
  }

  /// Call this whenever a raw message is received from your server/WebSocket
  void handleIncomingRawMessage(String rawJson) {
    try {
      final dynamic decoded = jsonDecode(rawJson);
      if (decoded is Map<String, dynamic>) {
        handleIncomingMap(decoded);
      }
    } catch (e) {
      if (kDebugMode) {
        print('[FloatoonWebSocket] Error parsing incoming message: $e');
      }
    }
  }

  /// Process incoming JSON map event
  void handleIncomingMap(Map<String, dynamic> event) {
    final type = event['type']?.toString();

    if (type == 'FLOATOON_ACTION') {
      final actionEvent = FloatoonActionEvent.fromJson(event);
      // If action came from partner targeting local user:
      if (actionEvent.fromUserId == partnerController.id) {
        partnerController.triggerAction(
          action: actionEvent.action,
          target: localController,
          emitWebSocket: false, // Don't re-emit remote event back to socket
        );
      } else if (actionEvent.fromUserId == localController.id) {
        localController.triggerAction(
          action: actionEvent.action,
          target: partnerController,
          emitWebSocket: false,
        );
      }
    } else if (type == 'FLOATOON_POSITION') {
      final posEvent = FloatoonPositionEvent.fromJson(event);
      if (posEvent.userId == partnerController.id) {
        partnerController.applyRemotePosition(
          x: posEvent.x,
          y: posEvent.y,
          isFacingRight: posEvent.isFacingRight,
        );
      }
    }
  }

  /// Helper to trigger an action and notify WebSocket
  void sendAction(FloatoonAction action) {
    localController.triggerAction(
      action: action,
      target: partnerController,
      emitWebSocket: true,
    );
  }
}
