/// Visual style for liquid glass buttons.
///
/// Determines whether the button displays with a liquid glass background
/// or appears transparent (ideal for grouped button scenarios).
enum LiquidButtonStyle {
  /// Button displays with a liquid glass background.
  ///
  /// This is the default style. The button will showcase a visible liquid
  /// glass effect with blur and transparency properties.
  filled,

  /// Button appears transparent with only interaction effects visible.
  ///
  /// Use this style when grouping buttons together (e.g., in a
  /// [GlassButtonGroup]) to prevent double-drawing liquid glass backgrounds.
  /// The button will still have glow and stretch effects, but no liquid glass shape.
  transparent,
}
