import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

import '../components/box/liquid_glass_container.dart';
import '../enum/liquid_glass_quality.dart';
import 'liquid_glass_menu_item.dart';

/// Liquid glass context menu that morphs from its trigger button.
class LGMenu extends StatefulWidget {
  /// Widget that triggers the menu.
  final Widget? trigger;

  /// Builder for trigger widget with menu toggle callback.
  final Widget Function(BuildContext context, VoidCallback toggleMenu)?
      triggerBuilder;

  /// Menu items to display.
  final List<LGMenuItem> items;

  /// Expanded menu width.
  final double menuWidth;

  /// Menu border radius.
  final double menuBorderRadius;

  /// Glass effect settings.
  final LiquidGlassSettings? glassSettings;

  /// Rendering quality.
  final LGQuality quality;

  const LGMenu({
    super.key,
    this.trigger,
    this.triggerBuilder,
    required this.items,
    this.menuWidth = 200,
    this.menuBorderRadius = 16.0,
    this.glassSettings,
    this.quality = LGQuality.standard,
  }) : assert(trigger != null || triggerBuilder != null,
            'Either trigger or triggerBuilder must be provided');

  @override
  State<LGMenu> createState() => _LGMenuState();
}

class _LGMenuState extends State<LGMenu>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  final OverlayPortalController _overlayController = OverlayPortalController();

  late final AnimationController _animationController;
  Size? _triggerSize;
  double? _triggerBorderRadius;

  final _springDescription = const SpringDescription(
    mass: 1.0,
    stiffness: 180.0,
    damping: 27.0,
  );

  Alignment _morphAlignment = Alignment.topLeft;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController.unbounded(vsync: this);
    _animationController.addListener(() {
      if (mounted) setState(() {});
      if (_overlayController.isShowing &&
          _animationController.value <= 0.001 &&
          _animationController.status != AnimationStatus.forward) {
        _overlayController.hide();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMenuOpen =
        _overlayController.isShowing && _animationController.value > 0.05;

    return CompositedTransformTarget(
      link: _layerLink,
      child: Stack(
        children: [
          Opacity(
            opacity: isMenuOpen ? 0.0 : 1.0,
            child: IgnorePointer(
              ignoring: isMenuOpen,
              child: widget.triggerBuilder != null
                  ? widget.triggerBuilder!(context, _toggleMenu)
                  : GestureDetector(
                      onTap: _toggleMenu,
                      child: widget.trigger,
                    ),
            ),
          ),
          OverlayPortal(
            controller: _overlayController,
            overlayChildBuilder: _buildMorphingOverlay,
          ),
        ],
      ),
    );
  }

  void _runSpring(double target) {
    final simulation = SpringSimulation(
      _springDescription,
      _animationController.value,
      target,
      0.0,
    );
    _animationController.animateWith(simulation);
  }

  void _toggleMenu() {
    if (_overlayController.isShowing && _animationController.value > 0.1) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  void _openMenu() {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      _triggerSize = renderBox.size;
      _triggerBorderRadius = _triggerSize!.height / 2;
      final position = renderBox.localToGlobal(Offset.zero);
      final screenWidth = MediaQuery.of(context).size.width;
      if (position.dx > screenWidth / 2) {
        _morphAlignment = Alignment.topRight;
      } else {
        _morphAlignment = Alignment.topLeft;
      }
    }
    _overlayController.show();
    _runSpring(1.0);
  }

  void _closeMenu() {
    _runSpring(0.0);
  }

  Widget _buildMorphingOverlay(BuildContext context) {
    if (_triggerSize == null) return const SizedBox.shrink();

      final value = _animationController.value.clamp(0.0, 1.0);

    return Stack(
      children: [
        if (value > 0.3)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _closeMenu,
              child: Container(
                color: Colors.black
                    .withValues(alpha: 0.0), // Invisible but tappable
              ),
            ),
          ),

        CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          targetAnchor: _morphAlignment,
          followerAnchor: _morphAlignment,
          offset: Offset(0, _calculateSwoopOffset(value)),
          child: _buildMorphingContainer(value),
        ),
      ],
    );
  }

  /// Calculates the vertical swoop offset for morphing animation.
  double _calculateSwoopOffset(double t) {
    final easedValue = 1 - (1 - t) * (1 - t) * (1 - t);
    return easedValue * 8.0;
  }

  /// Calculates the total menu content height.
  double _calculateMenuHeight() {
    final itemHeights = widget.items.fold<double>(
      0.0,
      (sum, item) => sum + item.height,
    );
    return itemHeights + 16.0;
  }

  Widget _buildMorphingContainer(double value) {
    final menuHeight = _calculateMenuHeight();
    final currentWidth =
        lerpDouble(_triggerSize!.width, widget.menuWidth, value)!;
    final currentHeight = value < 0.85
        ? lerpDouble(_triggerSize!.height, menuHeight, value)!
        : null;
    final currentBorderRadius = lerpDouble(
      _triggerBorderRadius ?? 16.0,
      widget.menuBorderRadius,
      value,
    )!;
    final buttonOpacity = (1.0 - (value / 0.02)).clamp(0.0, 1.0);
    final menuOpacity = ((value - 0.7) / 0.3).clamp(0.0, 1.0);
    const defaultSettings = LiquidGlassSettings(
      blur: 20,
      thickness: 30,
    );
    return RepaintBoundary(
      child: LGContainer(
        useOwnLayer: true,
        settings: widget.glassSettings ?? defaultSettings,
        quality: widget.quality,
        width: currentWidth,
        height: currentHeight,
        shape: LiquidRoundedSuperellipse(borderRadius: currentBorderRadius),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          alignment: _morphAlignment,
          clipBehavior: Clip.hardEdge,
          children: [
            if (value < 0.02)
              Opacity(
                opacity: buttonOpacity,
                child: SizedBox(
                  width: _triggerSize!.width,
                  height: _triggerSize!.height,
                  child: Center(
                    child: widget.triggerBuilder != null
                        ? widget.triggerBuilder!(context, _toggleMenu)
                        : widget.trigger,
                  ),
                ),
              ),
            if (value > 0.65)
              Opacity(
                opacity: menuOpacity,
                child: SizedBox(
                  width: currentWidth,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: widget.items.map((item) {
                          return LGMenuItem(
                            key: item.key,
                            title: item.title,
                            icon: item.icon,
                            isDestructive: item.isDestructive,
                            trailing: item.trailing,
                            height: item.height,
                            onTap: () {
                              item.onTap();
                              _closeMenu();
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
