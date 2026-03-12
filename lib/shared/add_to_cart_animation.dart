import 'package:flutter/material.dart';

class AddToCartAnimation extends StatefulWidget {
  final Offset startPosition;
  final Size startSize;
  final Offset targetPosition;
  final Size targetSize;
  final Widget child;
  final VoidCallback onComplete;

  const AddToCartAnimation({
    super.key,
    required this.startPosition,
    required this.startSize,
    required this.targetPosition,
    required this.targetSize,
    required this.child,
    required this.onComplete,
  });

  static void run({
    required BuildContext startContext,
    required Offset targetPosition, 
    required Widget child,
    VoidCallback? onComplete,
  }) {
    final startRenderBox = startContext.findRenderObject() as RenderBox?;

    if (startRenderBox == null) {
      if (onComplete != null) onComplete();
      return;
    }

    final startPosition = startRenderBox.localToGlobal(Offset.zero);

    final overlayState = Overlay.of(startContext);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) {
        return AddToCartAnimation(
          startPosition: startPosition,
          startSize: startRenderBox.size,
          targetPosition: targetPosition,
          targetSize: const Size(56, 56), // Tamaño por defecto de un FAB
          child: child,
          onComplete: () {
            overlayEntry.remove();
            if (onComplete != null) onComplete();
          },
        );
      },
    );

    overlayState.insert(overlayEntry);
  }

  @override
  State<AddToCartAnimation> createState() => _AddToCartAnimationState();
}

class _AddToCartAnimationState extends State<AddToCartAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _xAnimation;
  late Animation<double> _yAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
       duration: const Duration(milliseconds: 700),
       vsync: this,
    );

    _xAnimation = Tween<double>(
      begin: widget.startPosition.dx,
      end: widget.targetPosition.dx,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    // Usamos easeInBack para dar un pequeño efecto de salto parabólico invertido
    _yAnimation = Tween<double>(
      begin: widget.startPosition.dy,
      end: widget.targetPosition.dy,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInBack));

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInCubic),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.8, 1.0)),
    );

    _controller.forward().then((_) {
      widget.onComplete();
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
        return Positioned(
          left: _xAnimation.value,
          top: _yAnimation.value,
          width: widget.startSize.width,
          height: widget.startSize.height,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}
