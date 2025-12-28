import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

import '../components/box/liquid_glass_card.dart';
import '../buttons/liquid_glass_button.dart';
import '../enum/liquid_glass_quality.dart';

/// Glass alert dialog with liquid glass effect.
class LGDialog extends StatelessWidget {
  const LGDialog({
    required this.actions,
    super.key,
    this.title,
    this.message,
    this.content,
    this.settings,
    this.quality = LGQuality.standard,
    this.maxWidth = 280,
  }) : assert(
          actions.length > 0 && actions.length <= 3,
          'LGDialog must have 1-3 actions',
        );

  static const _actionButtonShape = LiquidRoundedSuperellipse(borderRadius: 12);

  static const _defaultMessageColor = Color(0xB3FFFFFF);
  static const _defaultGlowColor = Color(0x4DFFFFFF);
  static const _destructiveGlowColor = Color(0x4DFF0000);
  static const _primaryGlowColor = Color(0x4D0000FF);

  /// Dialog title.
  final String? title;

  /// Dialog message text.
  final String? message;

  /// Custom content widget.
  final Widget? content;

  /// Maximum dialog width.
  final double maxWidth;

  /// Action buttons. Must have 1-3 actions.
  final List<LGDialogAction> actions;

  /// Glass effect settings.
  final LiquidGlassSettings? settings;

  /// Rendering quality.
  final LGQuality quality;

  /// Shows a glass dialog.
  static Future<T?> show<T>({
    required BuildContext context,
    required List<LGDialogAction> actions,
    String? title,
    String? message,
    Widget? content,
    LiquidGlassSettings? settings,
    LGQuality quality = LGQuality.standard,
    bool barrierDismissible = false,
    Color? barrierColor,
    double maxWidth = 280,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: (context) => LGDialog(
        title: title,
        message: message,
        content: content,
        actions: actions,
        settings: settings,
        quality: quality,
        maxWidth: maxWidth,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: LGCard(
          useOwnLayer: true,
          settings: settings,
          quality: quality,
          padding: const EdgeInsets.all(20),
          child: LiquidGlassLayer(
            settings: settings ?? const LiquidGlassSettings(),
            fake: quality.usesBackdropFilter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                if (title != null) ...[
                  Text(
                    title!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                ],

                // Message
                if (message != null) ...[
                  Text(
                    message!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: _defaultMessageColor,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                ],

                // Custom content
                if (content != null) ...[
                  content!,
                  const SizedBox(height: 8),
                ],

                const SizedBox(height: 12),

                // Actions
                _buildActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActions() {
    // 1-2 actions: Horizontal layout
    if (actions.length <= 2) {
      return Row(
        children: actions.asMap().entries.map((entry) {
          final index = entry.key;
          final action = entry.value;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: index > 0 ? 8 : 0,
              ),
              child: _buildActionButton(action),
            ),
          );
        }).toList(),
      );
    }

    // 3 actions: Vertical layout (iOS pattern)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: actions.asMap().entries.map((entry) {
        final index = entry.key;
        final action = entry.value;
        return Padding(
          padding: EdgeInsets.only(
            top: index > 0 ? 8 : 0,
          ),
          child: _buildActionButton(action),
        );
      }).toList(),
    );
  }

  Widget _buildActionButton(LGDialogAction action) {
    // Determine button styling based on action type
    var glowColor = _defaultGlowColor;
    if (action.isDestructive) {
      glowColor = _destructiveGlowColor;
    } else if (action.isPrimary) {
      glowColor = _primaryGlowColor;
    }

    return LGButton.custom(
      onTap: action.onPressed,
      height: 44,
      shape: _actionButtonShape,
      glowColor: glowColor,
      child: Text(
        action.label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: action.isPrimary ? FontWeight.bold : FontWeight.w600,
          color: action.isDestructive ? Colors.red : Colors.white,
        ),
      ),
    );
  }
}

/// Configuration for a dialog action button.
class LGDialogAction {
  const LGDialogAction({
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
    this.isDestructive = false,
  });

  /// Button label text.
  final String label;

  /// Button press callback.
  final VoidCallback onPressed;

  /// Whether this is the primary action.
  final bool isPrimary;

  /// Whether this is a destructive action.
  final bool isDestructive;
}
