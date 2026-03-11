import 'dart:math';
import 'package:flutter/material.dart';

/// 子ウィジェットを上下にリズミカルに揺らすアニメーションラッパー。
///
/// 2秒周期で中央→上→中央→下→中央のフル振動を行う。
class BounceEmoji extends StatefulWidget {
  const BounceEmoji({super.key, required this.child});

  final Widget child;

  @override
  State<BounceEmoji> createState() => _BounceEmojiState();
}

class _BounceEmojiState extends State<BounceEmoji>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const _amplitude = 14.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
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
        // sin(2π * t): 0→1→0→-1→0 で上下フル振動（中央起点）
        final yOffset = -sin(2 * pi * _controller.value) * _amplitude;
        return Transform.translate(offset: Offset(0, yOffset), child: child);
      },
      child: widget.child,
    );
  }
}
