/// Glass effect rendering style configuration.
///
/// Defines the visual rendering approach for liquid glass effects,
/// offering trade-offs between appearance quality and system performance.
enum LiquidGlassQuality {
  /// Standard backdrop filter implementation.
  ///
  /// **Ideal scenarios:**
  /// - Scrollable content containers
  /// - Data entry interfaces
  /// - Performance-critical applications
  /// - Cross-platform compatibility requirements
  ///
  /// **Technical details:**
  /// - Leverages BackdropFilter widget
  /// - Optimized rendering pipeline
  /// - Smooth scrolling behavior
  /// - Universal widget compatibility
  ///
  /// Default selection for typical application needs.
  standard,

  /// Advanced shader-based glass visualization.
  ///
  /// **Ideal scenarios:**
  /// - Fixed position UI elements
  /// - Promotional or marketing sections
  /// - Premium visual experiences
  /// - Non-scrolling layouts
  ///
  /// **Technical details:**
  /// - GPU-accelerated shader rendering
  /// - Enhanced visual fidelity
  /// - Increased resource consumption
  /// - Limited scroll context support
  ///
  /// Restricted to fixed-position, non-scrolling UI components.
  premium,
}

/// Extension methods for [Style] enum configuration.
extension LiquidGlassQualityExtension on LiquidGlassQuality {
  /// Indicates if backdrop filter rendering should be applied.
  ///
  /// - [Style.standard] → true (backdrop filter enabled)
  /// - [Style.premium] → false (shader rendering enabled)
  bool get usesBackdropFilter {
    switch (this) {
      case LiquidGlassQuality.standard:
        return true;
      case LiquidGlassQuality.premium:
        return false;
    }
  }
}
