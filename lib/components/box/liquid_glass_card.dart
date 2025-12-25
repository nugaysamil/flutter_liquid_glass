import 'package:flutter/material.dart';
import 'liquid_glass_container.dart';
import '../../enum/liquid_glass_quality.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

/// Glass card widget with iOS-style design defaults.
///
/// Provides card styling with default padding and rounded corners.
class LGCard extends StatelessWidget {
  const LGCard({
    super.key,
    this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.shape = _defaultShape,
    this.settings,
    this.useOwnLayer = false,
    this.quality = LGQuality.standard,
    this.clipBehavior = Clip.none,
    this.width,
    this.height,
  });

  /// Content widget displayed inside the card.
  final Widget? child;

  /// Card width. If null, sizes to fit child.
  final double? width;

  /// Card height. If null, sizes to fit child.
  final double? height;

  /// Internal padding. Defaults to 16px on all sides.
  final EdgeInsetsGeometry padding;

  /// External margin around the card.
  final EdgeInsetsGeometry? margin;

  /// Card shape. Defaults to rounded superellipse with 12px radius.
  final LiquidShape shape;

  static const _defaultShape = LiquidRoundedSuperellipse(borderRadius: 12);

  /// Glass effect settings. Only used when [useOwnLayer] is true.
  final LiquidGlassSettings? settings;

  /// Whether to create its own layer or use grouped glass from parent.
  final bool useOwnLayer;

  /// Rendering quality for the glass effect.
  final LGQuality quality;

  /// Content clipping behavior.
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    return LGContainer(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      shape: shape,
      settings: settings,
      useOwnLayer: useOwnLayer,
      quality: quality,
      clipBehavior: clipBehavior,
      child: child,
    );
  }
}
