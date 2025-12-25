import 'package:flutter/material.dart';
import 'liquid_glass_container.dart';
import '../enum/liquid_glass_quality.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

/// A beautiful glass panel widget for larger surface areas following Apple's design.
///
/// [LGPanel] builds upon [LGContainer] with styling optimized for
/// larger content areas, modal surfaces, and full-screen containers. Features
/// default padding of 24px and rounded superellipse corners with 20px radius,
/// making it perfect for modal dialogs, settings panels, and detail views.
class LGPanel extends StatelessWidget {
  /// Creates a glass panel.
  const LGPanel({
    super.key,
    this.child,
    this.padding = const EdgeInsets.all(24),
    this.margin,
    this.shape = const LiquidRoundedSuperellipse(borderRadius: 20),
    this.settings,
    this.useOwnLayer = false,
    this.quality = LGQuality.standard,
    this.clipBehavior = Clip.none,
    this.width,
    this.height,
  });

  /// The widget below this widget in the tree.
  final Widget? child;

  /// Width of the panel in logical pixels.
  ///
  /// If null, the panel will size itself to fit its child.
  final double? width;

  /// Height of the panel in logical pixels.
  ///
  /// If null, the panel will size itself to fit its child.
  final double? height;

  /// Empty space to inscribe inside the panel.
  ///
  /// The child is placed inside this padding.
  ///
  /// Defaults to 24px on all sides (more generous than cards).
  final EdgeInsetsGeometry padding;

  /// Empty space to surround the panel.
  ///
  /// The glass effect is not applied to the margin area.
  ///
  /// Defaults to null (no margin).
  final EdgeInsetsGeometry? margin;


  /// Shape of the panel.
  ///
  /// Can be [LiquidOval], [LiquidRoundedRectangle], or
  /// [LiquidRoundedSuperellipse].
  ///
  /// Defaults to [LiquidRoundedSuperellipse] with 20px border radius,
  /// suitable for larger surfaces.
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
  /// [LiquidGlassLayer].
  ///   This is more performant when you have multiple glass elements that can
  ///   share the same rendering context.
  ///
  /// - `true`: Uses [LiquidGlass.withOwnLayer], can be used anywhere.
  ///   Creates an independent glass rendering context for this panel.
  ///
  /// Defaults to false.
  final bool useOwnLayer;

  /// Rendering quality for the glass effect.
  ///
  /// Defaults to [LGQuality.standard], which uses backdrop filter rendering.
  /// This works reliably in all contexts, including scrollable lists.
  ///
  /// Use [LGQuality.premium] for shader-based glass in static layouts only.
  final LGQuality quality;

  /// The clipping behavior for the panel.
  ///
  /// Controls how content is clipped at the panel's bounds:
  /// - [Clip.none]: No clipping (default, best performance)
  /// - [Clip.antiAlias]: Smooth anti-aliased clipping
  /// - [Clip.hardEdge]: Sharp clipping without anti-aliasing
  ///
  /// Use [Clip.antiAlias] or [Clip.hardEdge] when the child extends beyond
  /// the panel's bounds (e.g., images, overflowing content).
  ///
  /// Defaults to [Clip.none].
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
