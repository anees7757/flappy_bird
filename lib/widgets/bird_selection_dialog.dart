import 'package:flame_audio/flame_audio.dart';
import 'package:flappy_bird/widgets/game_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utils/asset_links.dart';
import 'outlined_text.dart';

class BirdSelectionDialog extends StatefulWidget {
  final double cardWidth;
  final double cardHeight;
  final double screenHeight;
  final double birdSize;
  final int initialSelectedIndex;
  final AudioPool swooshSound;
  final ValueChanged<int> onBirdSelected;

  const BirdSelectionDialog({
    super.key,
    required this.cardWidth,
    required this.cardHeight,
    required this.screenHeight,
    required this.birdSize,
    required this.initialSelectedIndex,
    required this.swooshSound,
    required this.onBirdSelected,
  });

  @override
  State<BirdSelectionDialog> createState() => BirdSelectionDialogState();
}

class BirdSelectionDialogState extends State<BirdSelectionDialog>
    with SingleTickerProviderStateMixin {
  late int selectedBirdIndex;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    selectedBirdIndex = widget.initialSelectedIndex;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onBirdHover(int index) {
    if (selectedBirdIndex != index) {
      setState(() => selectedBirdIndex = index);
      widget.swooshSound.start();
    }
  }

  void _onBirdTap(int index) {
    setState(() => selectedBirdIndex = index);
    widget.onBirdSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          child: Container(
            width: widget.cardWidth,
            margin: EdgeInsets.symmetric(horizontal: kIsWeb ? 30 : 20),
            padding: EdgeInsets.symmetric(
              horizontal: widget.screenHeight * 0.03,
              vertical: widget.screenHeight * 0.03,
            ),
            decoration: BoxDecoration(
              color: Color(0xffDDD69F),
              boxShadow: [
                const BoxShadow(
                  color: Colors.black,
                  spreadRadius: 0,
                  blurRadius: 0,
                  offset: Offset(8, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              spacing: 60,
              children: [
                const OutlinedText(
                  text: "select bird",
                  fontSize: 36,
                  fillColor: Colors.black,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    Assets.birds.length,
                    (index) => _BirdSelectionItem(
                      birdImage: Assets.birds[index],
                      isSelected: selectedBirdIndex == index,
                      birdSize: widget.birdSize.clamp(60.0, 90.0),
                      onHover: () => _onBirdHover(index),
                      onTap: () => _onBirdTap(index),
                      delay: Duration(milliseconds: 100 * index),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BirdSelectionItem extends StatefulWidget {
  final String birdImage;
  final bool isSelected;
  final double birdSize;
  final VoidCallback onHover;
  final VoidCallback onTap;
  final Duration delay;

  const _BirdSelectionItem({
    required this.birdImage,
    required this.isSelected,
    required this.birdSize,
    required this.onHover,
    required this.onTap,
    required this.delay,
  });

  @override
  State<_BirdSelectionItem> createState() => _BirdSelectionItemState();
}

class _BirdSelectionItemState extends State<_BirdSelectionItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    // Start animation with delay
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(opacity: _fadeAnimation.value, child: child),
        );
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() => _isHovered = true);
          widget.onHover();
        },
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedScale(
            scale: 1.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutBack,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: widget.birdSize,
              width: widget.birdSize,
              padding: EdgeInsets.all(widget.birdSize * 0.08),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: widget.isSelected
                    ? Color(0xff4e4c3a).withValues(alpha: 0.3)
                    : Colors.transparent,
                border: widget.isSelected
                    ? Border.all(color: Color(0xff4e4c3a), width: 3)
                    : null,
              ),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: widget.isSelected ? 1.0 : 0.0),
                duration: const Duration(milliseconds: 300),
                builder: (context, value, child) {
                  return Transform.rotate(
                    angle: value * 0.1 * (widget.isSelected ? 1 : -1),
                    child: child,
                  );
                },
                child: Image.asset(
                  widget.birdImage,
                  width: widget.birdSize * 0.7,
                  height: widget.birdSize * 0.7,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
