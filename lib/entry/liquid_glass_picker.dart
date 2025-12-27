import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_liquid_glass_plus/enum/liquid_glass_quality.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

/// Glass picker widget following iOS design patterns.
class LGPicker extends StatelessWidget {
  const LGPicker({
    required this.value,
    this.onTap,
    super.key,
    this.placeholder = 'Select',
    this.icon,
    this.height = 48.0,
    this.width,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.textStyle,
    this.placeholderStyle,
    this.glassSettings,
    this.useOwnLayer = false,
    this.quality = LGQuality.standard,
    this.shape = const LiquidRoundedSuperellipse(borderRadius: 10),
  });

  // Cache default placeholder color to avoid allocations
  static const _defaultPlaceholderColor =
      Color(0x80FFFFFF); // white.withValues(alpha: 0.5)

  /// Selected value.
  final String? value;

  /// Placeholder text.
  final String placeholder;

  /// Icon displayed at the end.
  final IconData? icon;

  /// Tap callback.
  final VoidCallback? onTap;

  /// Picker height.
  final double height;

  /// Picker width.
  final double? width;

  /// Internal padding.
  final EdgeInsetsGeometry padding;

  /// Value text style.
  final TextStyle? textStyle;

  /// Placeholder text style.
  final TextStyle? placeholderStyle;

  /// Glass effect settings.
  final LiquidGlassSettings? glassSettings;

  /// Whether to use its own layer or grouped glass.
  final bool useOwnLayer;

  /// Rendering quality.
  final LGQuality quality;

  /// Container shape.
  final LiquidShape shape;

  @override
  Widget build(BuildContext context) {
    final effectiveTextStyle =
        textStyle ?? const TextStyle(fontSize: 16, color: Colors.white);

    final effectivePlaceholderStyle = placeholderStyle ??
        const TextStyle(fontSize: 16, color: _defaultPlaceholderColor);

    final child = Container(
      height: height,
      width: width,
      padding: padding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              value ?? placeholder,
              style: value != null
                  ? effectiveTextStyle
                  : effectivePlaceholderStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            icon ?? CupertinoIcons.chevron_up_chevron_down,
            size: 16,
            color: Colors.white70,
          ),
        ],
      ),
    );

    final glassWidget = useOwnLayer
        ? LiquidGlass.withOwnLayer(
            shape: shape,
            settings: glassSettings ?? const LiquidGlassSettings(blur: 8),
            fake: quality.usesBackdropFilter,
            child: child,
          )
        : LiquidGlass.grouped(
            shape: shape,
            child: child,
          );

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: glassWidget,
    );
  }

  /// Shows a bottom sheet picker.
  static Future<T?> showSheet<T>({
    required BuildContext context,
    required List<T> items,
    required Widget Function(T item) itemBuilder,
    String? title,
  }) {
    return showCupertinoModalPopup<T>(
      context: context,
      builder: (context) => Container(
        height: 300,
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground.resolveFrom(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            if (title != null)
              Container(
                height: 50,
                alignment: Alignment.center,
                child: Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            Expanded(
              child: CupertinoPicker.builder(
                itemExtent: 40,
                onSelectedItemChanged: (index) {
                  // Handle live update if needed
                },
                itemBuilder: (context, index) {
                  if (index < 0 || index >= items.length) return null;
                  return itemBuilder(items[index]);
                },
                childCount: items.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
