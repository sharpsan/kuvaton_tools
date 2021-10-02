import 'package:flutter/material.dart';

class LoadingOverlay extends StatefulWidget {
  final Widget child;
  final double opacity;
  final isLoading;
  LoadingOverlay({
    required this.child,
    this.opacity = 0.4,
    this.isLoading = false,
  }) : assert(opacity >= 0 && opacity <= 1);
  @override
  _LoadingOverlayState createState() => _LoadingOverlayState();
}

class _LoadingOverlayState extends State<LoadingOverlay> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        widget.child,
        Visibility(
          visible: widget.isLoading,
          child: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black.withOpacity(widget.opacity),
            child: Center(
              child: Container(
                padding: EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSecondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
