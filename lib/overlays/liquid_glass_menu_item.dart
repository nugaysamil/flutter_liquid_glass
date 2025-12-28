import 'package:flutter/material.dart';

/// Menu item for use within a menu.
class LGMenuItem extends StatefulWidget {
  const LGMenuItem({
    required this.title,
    required this.onTap,
    super.key,
    this.icon,
    this.isDestructive = false,
    this.trailing,
    this.height = 44.0,
  });

  /// Item title text.
  final String title;

  /// Icon displayed before title.
  final IconData? icon;

  /// Tap callback.
  final VoidCallback onTap;

  /// Whether this is a destructive action.
  final bool isDestructive;

  /// Widget displayed after title.
  final Widget? trailing;

  /// Item height.
  final double height;

  @override
  State<LGMenuItem> createState() => _LGMenuItemState();
}

class _LGMenuItemState extends State<LGMenuItem> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final Color textColor = widget.isDestructive
        ? const Color(0xFFEF5350)
        : const Color(0xE6FFFFFF);
    final Color iconColor = widget.isDestructive
        ? const Color(0xFFEF5350)
        : const Color(0xB3FFFFFF);
    final Color backgroundColor = _isPressed
        ? const Color(0x26FFFFFF)
        : _isHovered
            ? const Color(0x1AFFFFFF)
            : Colors.transparent;
    final double scale = _isPressed ? 0.98 : 1.0;
    return RepaintBoundary(
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
            child: AnimatedScale(
            scale: scale,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOutCubic,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOutCubic,
              height: widget.height,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  if (widget.icon != null) ...[
                    Icon(
                      widget.icon,
                      size: 20,
                      color: iconColor,
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  if (widget.trailing != null) widget.trailing!,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
