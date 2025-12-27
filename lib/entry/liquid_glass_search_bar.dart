import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_liquid_glass_plus/entry/liquid_glass_text_field.dart';
import 'package:flutter_liquid_glass_plus/enum/liquid_glass_quality.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

/// Glass search bar with pill shape, animated clear button and cancel button.
class LGSearchBar extends StatefulWidget {
  const LGSearchBar({
    super.key,
    this.controller,
    this.placeholder = 'Search',
    this.onChanged,
    this.onSubmitted,
    this.onCancel,
    this.showsCancelButton = false,
    this.autofocus = false,
    this.enabled = true,
    this.searchIconColor,
    this.clearIconColor,
    this.cancelButtonColor,
    this.textStyle,
    this.placeholderStyle,
    this.height = 44.0,
    this.cancelButtonText = 'Cancel',
    this.settings,
    this.useOwnLayer = false,
    this.quality = LGQuality.standard,
  });

  /// Text editing controller.
  final TextEditingController? controller;

  /// Placeholder text.
  final String placeholder;

  /// Text change callback.
  final ValueChanged<String>? onChanged;

  /// Submit callback.
  final ValueChanged<String>? onSubmitted;

  /// Cancel button tap callback.
  final VoidCallback? onCancel;

  /// Whether to show cancel button.
  final bool showsCancelButton;

  /// Whether to autofocus.
  final bool autofocus;

  /// Whether enabled.
  final bool enabled;

  /// Search icon color.
  final Color? searchIconColor;

  /// Clear button icon color.
  final Color? clearIconColor;

  /// Cancel button text color.
  final Color? cancelButtonColor;

  /// Search text style.
  final TextStyle? textStyle;

  /// Placeholder text style.
  final TextStyle? placeholderStyle;

  /// Search bar height.
  final double height;

  /// Cancel button text.
  final String cancelButtonText;

  /// Glass effect settings. Only used when [useOwnLayer] is true.
  final LiquidGlassSettings? settings;

  /// Whether to use its own layer or grouped glass.
  final bool useOwnLayer;

  /// Rendering quality.
  final LGQuality quality;

  @override
  State<LGSearchBar> createState() => _LGSearchBarState();
}

class _LGSearchBarState extends State<LGSearchBar>
    with SingleTickerProviderStateMixin {
  // Cache default colors to avoid allocations
  static const _defaultSearchIconColor =
      Color(0x99FFFFFF); // white.withValues(alpha: 0.6)
  static const _defaultClearIconColor =
      Color(0x99FFFFFF); // white.withValues(alpha: 0.6)
  static const _defaultCancelButtonColor =
      Color(0xE6FFFFFF); // white.withValues(alpha: 0.9)

  late TextEditingController _controller;
  late AnimationController _clearButtonController;
  late FocusNode _focusNode;
  bool _showCancelButton = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = FocusNode();

    // Animation for clear button
    _clearButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    // Listen to text changes
    _controller.addListener(_onTextChanged);

    // Listen to focus changes for cancel button
    _focusNode.addListener(_onFocusChanged);

    // Initialize clear button animation state based on initial text
    if (_controller.text.isNotEmpty) {
      _clearButtonController.value = 1.0;
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _clearButtonController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    // Animate clear button based on text presence
    if (_controller.text.isNotEmpty) {
      if (_clearButtonController.status != AnimationStatus.completed &&
          _clearButtonController.status != AnimationStatus.forward) {
        unawaited(_clearButtonController.forward());
      }
    } else {
      if (_clearButtonController.status != AnimationStatus.dismissed &&
          _clearButtonController.status != AnimationStatus.reverse) {
        unawaited(_clearButtonController.reverse());
      }
    }
  }

  void _onFocusChanged() {
    if (widget.showsCancelButton) {
      setState(() {
        _showCancelButton = _focusNode.hasFocus;
      });
    }
  }

  void _handleClear() {
    _controller.clear();
    widget.onChanged?.call('');
  }

  void _handleCancel() {
    _controller.clear();
    _focusNode.unfocus();
    widget.onCancel?.call();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final searchIconColor = widget.searchIconColor ?? _defaultSearchIconColor;
    final clearIconColor = widget.clearIconColor ?? _defaultClearIconColor;
    final cancelButtonColor =
        widget.cancelButtonColor ?? _defaultCancelButtonColor;

    return Row(
      children: [
        // Search field
        Expanded(
          child: SizedBox(
            height: widget.height,
            child: LGTextField(
              controller: _controller,
              focusNode: _focusNode,
              placeholder: widget.placeholder,
              prefixIcon: Icon(
                CupertinoIcons.search,
                size: 20,
                color: searchIconColor,
              ),
              suffixIcon: RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _clearButtonController,
                  builder: (context, child) {
                    final animation = CurvedAnimation(
                      parent: _clearButtonController,
                      curve: Curves.easeInOut,
                    );

                    return Opacity(
                      opacity: animation.value,
                      child: Transform.scale(
                        scale: animation.value,
                        child: Icon(
                          CupertinoIcons.clear_circled_solid,
                          size: 18,
                          color: clearIconColor,
                        ),
                      ),
                    );
                  },
                ),
              ),
              onSuffixTap: _handleClear,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              autofocus: widget.autofocus,
              enabled: widget.enabled,
              textStyle: widget.textStyle,
              placeholderStyle: widget.placeholderStyle,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              iconSpacing: 8,
              shape: LiquidRoundedSuperellipse(
                borderRadius: widget.height / 2, // Pill shape
              ),
              settings: widget.settings,
              useOwnLayer: widget.useOwnLayer,
              quality: widget.quality,
            ),
          ),
        ),

        // Cancel button
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: _showCancelButton
              ? Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: GestureDetector(
                    onTap: _handleCancel,
                    child: Text(
                      widget.cancelButtonText,
                      style: TextStyle(
                        color: cancelButtonColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
