import 'package:flutter/material.dart';

class HoverableTabWidget extends StatefulWidget {
  const HoverableTabWidget({required this.builder, super.key});

  /// A builder that receives the hover state.
  ///
  /// The `isHover` parameter is `true` when the mouse is over the widget.
  final Widget Function(bool isHover) builder;

  @override
  State<HoverableTabWidget> createState() => _HoverableTabWidgetState();
}

class _HoverableTabWidgetState extends State<HoverableTabWidget> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      key: const Key('HoverableTabWidget - MouseRegion'),
      onEnter: (_) {
        setState(() {
          _isHovering = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovering = false;
        });
      },
      child: widget.builder(_isHovering),
    );
  }
}
