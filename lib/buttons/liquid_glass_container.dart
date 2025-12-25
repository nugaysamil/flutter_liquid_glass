import 'package:flutter/material.dart';
import 'package:flutter_liquid_glass/enum/liquid_glass_quality.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

/// A foundational glass container widget following Apple's liquid glass design.
///
/// This is the base primitive for all container-based glass widgets. It
/// provides a simple glass surface with configurable dimensions, padding,
/// and shape. Supports both grouped mode (shares parent layer) and standalone
/// mode (creates its own layer).
class LiquidGlassContainer extends StatelessWidget {
  /// Creates a glass container.
  const LiquidGlassContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.shape = const LiquidRoundedSuperellipse(borderRadius: 16),
    this.settings,
    this.useOwnLayer = false,
    this.quality = LiquidGlassQuality.standard,
    this.clipBehavior = Clip.none,
    this.alignment,
  });

  /// The widget below this widget in the tree.
  final Widget? child;

  /// The alignment of the [child] within the container.
  ///
  /// If null, the child is positioned according to its natural size.
  final AlignmentGeometry? alignment;

  /// Width of the container in logical pixels.
  ///
  /// If null, the container will size itself to fit its child.
  final double? width;

  /// Height of the container in logical pixels.
  ///
  /// If null, the container will size itself to fit its child.
  final double? height;

  /// Empty space to inscribe inside the glass container.
  ///
  /// The child is placed inside this padding.
  final EdgeInsetsGeometry? padding;

  /// Empty space to surround the glass container.
  ///
  /// The glass effect is not applied to the margin area.
  final EdgeInsetsGeometry? margin;


  /// Shape of the glass container.
  ///
  /// Can be [LiquidOval], [LiquidRoundedRectangle], or
  /// [LiquidRoundedSuperellipse].
  ///
  /// Defaults to [LiquidRoundedSuperellipse] with 16px border radius, matching
  /// Apple's standard corner radius for cards and containers.
  final LiquidShape shape;

  /// Glass effect settings (only used when [useOwnLayer] is true).
  ///
  /// Controls the visual appearance of the glass effect including thickness,
  /// blur radius, color tint, lighting, and more.
  ///
  /// If null when [useOwnLayer] is true, uses [LiquidGlassSettings] defaults.
  /// Ignored when [useOwnLayer] is false (inherits from parent layer).
  final LiquidGlassSettings? settings;

  /// Whether to create its own layer or use grouped glass within an existing
  /// layer.
  ///
  /// - `false` (default): Uses [LiquidGlass.grouped], must be inside a
  /// [LiquidGlassLayer]. This is more performant when you have multiple glass
  /// elements that can share the same rendering context.
  ///
  /// - `true`: Uses [LiquidGlass.withOwnLayer], can be used anywhere.
  ///   Creates an independent glass rendering context for this container.
  ///
  /// Defaults to false.
  final bool useOwnLayer;

  /// Rendering quality for the glass effect.
  ///
  /// Defaults to [GlassQuality.standard], which uses backdrop filter rendering.
  /// This works reliably in all contexts, including scrollable lists.
  ///
  /// Use [GlassQuality.premium] for shader-based glass in static layouts only.
  final LiquidGlassQuality quality;

  /// The clipping behavior for the container.
  ///
  /// Controls how content is clipped at the container's bounds:
  /// - [Clip.none]: No clipping (default, best performance)
  /// - [Clip.antiAlias]: Smooth anti-aliased clipping
  /// - [Clip.hardEdge]: Sharp clipping without anti-aliasing
  ///
  /// Use [Clip.antiAlias] or [Clip.hardEdge] when the child extends beyond
  /// the container's bounds (e.g., images, overflowing content).
  ///
  /// Defaults to [Clip.none].
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    var content = child ?? const SizedBox.shrink();

    if (padding != null) {
      content = Padding(
        padding: padding!,
        child: content,
      );
    }

    if (alignment != null) {
      content = Align(
        alignment: alignment!,
        child: content,
      );
    }

    Widget glassWidget = useOwnLayer
        ? LiquidGlass.withOwnLayer(
            shape: shape,
            settings: settings ?? const LiquidGlassSettings(),
            fake: quality.usesBackdropFilter,
            clipBehavior: clipBehavior,
            child: content,
          )
        : LiquidGlass.grouped(
            shape: shape,
            clipBehavior: clipBehavior,
            child: content,
          );

    if (width != null || height != null) {
      glassWidget = SizedBox(
        width: width,
        height: height,
        child: glassWidget,
      );
    }

    if (margin != null) {
      glassWidget = Padding(
        padding: margin!,
        child: glassWidget,
      );
    }

    return glassWidget;
  }
}
