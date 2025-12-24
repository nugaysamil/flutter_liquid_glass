// ignore_for_file: deprecated_member_use

import 'package:flutter/widgets.dart';

/// Physics utilities for draggable indicators.
class IndicatorPhysics {
  IndicatorPhysics._();

  /// Applies rubber band resistance when dragging beyond edges.
  static double applyRubberBandResistance(
    double value, {
    double resistance = 0.4,
    double maxOverdrag = 0.3,
  }) {
    if (value < 0) {
      final overdrag = -value;
      final resistedOverdrag = overdrag * resistance;
      return -resistedOverdrag.clamp(0.0, maxOverdrag);
    } else if (value > 1) {
      final overdrag = value - 1;
      final resistedOverdrag = overdrag * resistance;
      return 1 + resistedOverdrag.clamp(0.0, maxOverdrag);
    }

    return value;
  }

  /// Creates a jelly transform matrix based on velocity.
  static Matrix4 jellyTransform({
    required Offset velocity,
    double maxDistortion = 0.7,
    double velocityScale = 1000.0,
  }) {
    final speed = velocity.distance;
    if (speed == 0) return Matrix4.identity();

    final direction = velocity / speed;
    final distortionFactor =
        (speed / velocityScale).clamp(0.0, 1.0) * maxDistortion;

    final squashX = 1.0 - (direction.dx.abs() * distortionFactor * 0.5);
    final squashY = 1.0 - (direction.dy.abs() * distortionFactor * 0.5);
    final stretchX = 1.0 + (direction.dy.abs() * distortionFactor * 0.3);
    final stretchY = 1.0 + (direction.dx.abs() * distortionFactor * 0.3);

    final scaleX = squashX * stretchX;
    final scaleY = squashY * stretchY;

    return Matrix4.identity()..scale(scaleX, scaleY);
  }

  /// Converts item index to alignment (-1 to 1).
  static double computeAlignment(int index, int itemCount) {
    final relativeIndex = (index / (itemCount - 1)).clamp(0.0, 1.0);
    return (relativeIndex * 2) - 1;
  }

  /// Converts global drag position to alignment with rubber band resistance.
  static double alignmentFromPosition(
    Offset globalPosition,
    BuildContext context,
    int itemCount,
  ) {
    final box = context.findRenderObject()! as RenderBox;
    final localPosition = box.globalToLocal(globalPosition);

    final indicatorWidth = 1.0 / itemCount;
    final draggableRange = 1.0 - indicatorWidth;
    final padding = indicatorWidth / 2;

    final rawRelativeX = (localPosition.dx / box.size.width).clamp(0.0, 1.0);
    final normalizedX = (rawRelativeX - padding) / draggableRange;
    final adjustedRelativeX = applyRubberBandResistance(normalizedX);

    return (adjustedRelativeX * 2) - 1;
  }

  /// Computes target index based on drag position and velocity.
  static int computeTargetIndex({
    required double currentRelativeX,
    required double velocityX,
    required double itemWidth,
    required int itemCount,
    double velocityThreshold = 0.5,
    double projectionTime = 0.3,
  }) {
    if (currentRelativeX < 0) return 0;
    if (currentRelativeX > 1) return itemCount - 1;

    if (velocityX.abs() > velocityThreshold) {
      final projectedX =
          (currentRelativeX + velocityX * projectionTime).clamp(0.0, 1.0);
      var targetIndex =
          (projectedX / itemWidth).round().clamp(0, itemCount - 1);

      final currentIndex =
          (currentRelativeX / itemWidth).round().clamp(0, itemCount - 1);

      if (velocityX > velocityThreshold &&
          targetIndex <= currentIndex &&
          currentIndex < itemCount - 1) {
        targetIndex = currentIndex + 1;
      } else if (velocityX < -velocityThreshold &&
          targetIndex >= currentIndex &&
          currentIndex > 0) {
        targetIndex = currentIndex - 1;
      }

      return targetIndex;
    }

    return (currentRelativeX / itemWidth).round().clamp(0, itemCount - 1);
  }
}

