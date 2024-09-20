import 'package:flutter/material.dart';
import 'package:simple_video_image_picker/src/enums/pick_type_enum.dart';
import 'package:simple_video_image_picker/src/models/picked_item_model.dart';
import 'package:simple_video_image_picker/src/screens/picker_screen.dart';

class SimpleVideoImagePicker {
  static Future<List<PickedItem>> pick({
    required BuildContext context,
    List<PickedItem>? pickedItems,
    Color? backgroundColor,
    Color? accentColor,
    PickType type = PickType.any,
    int maxCount = 0,
  }) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return PickerScreen(
            pickedItems: pickedItems ?? [],
            type: type,
            maxCount: maxCount,
            backgroundColor:
                backgroundColor ?? Theme.of(context).colorScheme.surface,
            accentColor: accentColor ?? Theme.of(context).primaryColor,
          );
        },
      ),
    );
  }
}
