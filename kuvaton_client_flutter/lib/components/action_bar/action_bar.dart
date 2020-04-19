import 'package:flutter/material.dart';
import 'package:kuvaton_client_flutter/components/action_bar/icon_text_button.dart';

/// sits at the end of the image list
/// inside home_route.dart
///
/// go to next/previous page
class ActionBar extends StatelessWidget {
  final Function buttonPreviousOnPressed;
  final Function buttonNextOnPressed;
  final Function buttonPageOnPressed;
  final int currentPageNumber;
  ActionBar({
    @required this.buttonPreviousOnPressed,
    @required this.buttonNextOnPressed,
    @required this.buttonPageOnPressed,
    @required this.currentPageNumber,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 2,
        bottom: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconTextButton(
            iconIsLeading: true,
            iconData: Icons.arrow_back_ios,
            onPressed: buttonPreviousOnPressed,
          ),
          IconTextButton(
            text: '$currentPageNumber',
            onPressed: buttonPageOnPressed,
          ),
          IconTextButton(
            iconIsLeading: false,
            iconData: Icons.arrow_forward_ios,
            onPressed: buttonNextOnPressed,
          ),
        ],
      ),
    );
  }
}
