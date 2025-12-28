import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

import '../enum/liquid_glass_quality.dart';

/// Glass bottom sheet with drag indicator and iOS-style dismiss behavior.
class LGSheet extends StatelessWidget {
  const LGSheet({
    required this.child,
    super.key,
    this.showDragIndicator = true,
    this.dragIndicatorColor,
    this.settings,
    this.quality = LGQuality.standard,
    this.padding,
  });

  /// Sheet content widget.
  final Widget child;

  /// Padding around content.
  final EdgeInsetsGeometry? padding;

  /// Whether to show drag indicator.
  final bool showDragIndicator;

  /// Drag indicator color.
  final Color? dragIndicatorColor;

  /// Glass effect settings.
  final LiquidGlassSettings? settings;

  /// Rendering quality.
  final LGQuality quality;

  /// Shows a glass bottom sheet.
  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    LiquidGlassSettings? settings,
    LGQuality quality = LGQuality.standard,
    bool showDragIndicator = true,
    Color? dragIndicatorColor,
    bool isDismissible = true,
    bool enableDrag = true,
    bool isScrollControlled = false,
    Color? backgroundColor,
    Color? barrierColor,
    double elevation = 0,
    ShapeBorder? shape,
    Clip? clipBehavior,
    BoxConstraints? constraints,
    double initialChildSize = 0.5,
    double minChildSize = 0.25,
    double maxChildSize = 1.0,
    EdgeInsetsGeometry? padding,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor ?? Colors.transparent,
      barrierColor: barrierColor,
      elevation: elevation,
      shape: shape ??
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
      clipBehavior: clipBehavior ?? Clip.antiAlias,
      constraints: constraints,
      builder: (context) {
        return LGSheet(
          settings: settings,
          quality: quality,
          showDragIndicator: showDragIndicator,
          dragIndicatorColor: dragIndicatorColor,
          padding: padding,
          child: builder(context),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LiquidGlass.withOwnLayer(
      shape: const LiquidRoundedSuperellipse(borderRadius: 20),
      settings: settings ?? const LiquidGlassSettings(),
      fake: quality.usesBackdropFilter,
      child: LiquidGlassLayer(
        settings: settings ?? const LiquidGlassSettings(),
        fake: quality.usesBackdropFilter,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showDragIndicator) ...[
                const SizedBox(height: 8),
                _LGDragIndicator(
                  color: dragIndicatorColor,
                ),
                const SizedBox(height: 8),
              ] else
                const SizedBox(height: 16),
              if (padding != null)
                Padding(
                  padding: padding!,
                  child: child,
                )
              else
                child,
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

/// Drag indicator widget for glass sheets.
class _LGDragIndicator extends StatelessWidget {
  const _LGDragIndicator({
    this.color,
  });

  static const _defaultColor = Color(0x4DFFFFFF);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 5,
      decoration: BoxDecoration(
        color: color ?? _defaultColor,
        borderRadius: BorderRadius.circular(2.5),
      ),
    );
  }
}
