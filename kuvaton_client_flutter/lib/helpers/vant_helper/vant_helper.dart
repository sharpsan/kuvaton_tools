import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vant_kit/widgets/dialog.dart';
import 'package:flutter_vant_kit/widgets/picker.dart';

class VantHelper {
  static void quickNDialog(
    BuildContext context, {
    @required String title,
    @required String message,
    Function onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (_) => NDialog(
        title: title,
        onConfirm: onConfirm,
        confirmButtonText: 'Okay',
        closeOnClickOverlay: true,
        confirmTextColor: Theme.of(context).primaryColor,
        message: message,
      ),
    );
  }

  static void quickPicker(
    BuildContext context, {
    @required int currentPage,
    @required Function(int) onConfirm,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Picker(
        title: 'Page',
        confirmButtonText: 'Confirm',
        cancelButtonText: 'Cancel',
        showToolbar: true,
        // subtract 1 because the page number is the page number,
        // not the index
        defaultIndex: currentPage - 1,
        // generated list starts at 0, and since our first page is 1
        // we add +1
        colums:
            List.generate(500, (index) => PickerItem((index + 1).toString())),
        onConfirm: (List<String> selectedValues, dynamic selectedIndex) {
          onConfirm(int.parse(selectedValues[0]));
          ExtendedNavigator.of(context).pop();
        },
        onCancel: (_, __) => ExtendedNavigator.of(context).pop(),
      ),
    );
  }
}
