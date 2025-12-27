import 'package:flutter/material.dart';

/// Form field wrapper for glass inputs with label, error and helper text.
class LGFormField extends StatelessWidget {
  const LGFormField({
    required this.child,
    super.key,
    this.label,
    this.helperText,
    this.errorText,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  // Cache default helper text color to avoid allocations
  static const _defaultHelperTextColor =
      Color(0x99FFFFFF); // white.withValues(alpha: 0.6)

  /// Input widget child.
  final Widget child;

  /// Label text above the input.
  final String? label;

  /// Helper text below the input.
  final String? helperText;

  /// Error text below the input (replaces helperText when provided).
  final String? errorText;

  /// Column cross axis alignment.
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
        ],
        child,

        if (errorText != null) ...[
          const SizedBox(height: 6),
          Text(
            errorText!,
            style: TextStyle(
              fontSize: 12,
              color: Colors.redAccent.shade100,
              fontWeight: FontWeight.w500,
            ),
          ),
        ] else if (helperText != null) ...[
          const SizedBox(height: 6),
          Text(
            helperText!,
            style: const TextStyle(
              fontSize: 12,
              color: _defaultHelperTextColor,
            ),
          ),
        ],
      ],
    );
  }
}
