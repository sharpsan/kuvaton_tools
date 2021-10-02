import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {
  final bool iconIsLeading;
  final IconData? iconData;
  final String? text;
  final VoidCallback? onPressed;
  IconTextButton({
    this.iconIsLeading = true,
    this.iconData,
    this.text,
    required this.onPressed,
  });

  Widget _buildIcon(IconData? iconData) {
    return iconData == null
        ? Container()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Icon(
              iconData,
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
          child: Row(
            children: <Widget>[
              if (iconIsLeading) _buildIcon(iconData),
              Text('$text',
                  style: TextStyle(
                    fontSize: 18,
                  )),
              if (!iconIsLeading) _buildIcon(iconData),
            ],
          ),
        ),
      ),
    );
  }
}
