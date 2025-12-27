import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_liquid_glass_plus/entry/liquid_glass_text_field.dart';
import 'package:flutter_liquid_glass_plus/enum/liquid_glass_quality.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

/// Multi-line glass text area.
class LGTextArea extends StatelessWidget {
  const LGTextArea({
    super.key,
    this.controller,
    this.focusNode,
    this.placeholder,
    this.minLines = 3,
    this.maxLines = 5,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.textInputAction = TextInputAction.newline,
    this.inputFormatters,
    this.textStyle,
    this.placeholderStyle,
    this.padding = const EdgeInsets.all(16),
    this.settings,
    this.useOwnLayer = false,
    this.quality = LGQuality.standard,
    this.shape = const LiquidRoundedSuperellipse(borderRadius: 10),
  });

  /// Text editing controller.
  final TextEditingController? controller;

  /// Focus node.
  final FocusNode? focusNode;

  /// Placeholder text.
  final String? placeholder;

  /// Minimum lines.
  final int minLines;

  /// Maximum lines.
  final int maxLines;

  /// Text change callback.
  final ValueChanged<String>? onChanged;

  /// Submit callback.
  final ValueChanged<String>? onSubmitted;

  /// Whether enabled.
  final bool enabled;

  /// Whether read-only.
  final bool readOnly;

  /// Whether autofocus.
  final bool autofocus;

  /// Text input action.
  final TextInputAction? textInputAction;

  /// Input formatters.
  final List<TextInputFormatter>? inputFormatters;

  /// Text style.
  final TextStyle? textStyle;

  /// Placeholder style.
  final TextStyle? placeholderStyle;

  /// Internal padding.
  final EdgeInsetsGeometry padding;

  /// Glass effect settings.
  final LiquidGlassSettings? settings;

  /// Whether to use its own layer or grouped glass.
  final bool useOwnLayer;

  /// Rendering quality.
  final LGQuality quality;

  /// Container shape.
  final LiquidShape shape;

  @override
  Widget build(BuildContext context) {
    return LGTextField(
      controller: controller,
      focusNode: focusNode,
      placeholder: placeholder,
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: TextInputType.multiline,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      inputFormatters: inputFormatters,
      textStyle: textStyle,
      placeholderStyle: placeholderStyle,
      padding: padding,
      settings: settings,
      useOwnLayer: useOwnLayer,
      quality: quality,
      shape: shape,
    );
  }
}
