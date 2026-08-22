import 'package:flutter/material.dart';
import 'package:flutter_mastery/live_previews/widgets/container_preview.dart';
import 'package:flutter_mastery/live_previews/widgets/text_preview.dart';
import 'package:flutter_mastery/live_previews/widgets/card_preview.dart';
import 'package:flutter_mastery/live_previews/widgets/icon_preview.dart';
import 'package:flutter_mastery/live_previews/widgets/image_preview.dart';
import 'package:flutter_mastery/live_previews/widgets/buttons_preview.dart';
import 'package:flutter_mastery/live_previews/widgets/textfield_preview.dart';
import 'package:flutter_mastery/live_previews/widgets/dropdownbutton_preview.dart';
import 'package:flutter_mastery/live_previews/widgets/textformfield_preview.dart';
import 'package:flutter_mastery/live_previews/widgets/appbar_preview.dart';
import 'package:flutter_mastery/live_previews/widgets/row_preview.dart';
import 'package:flutter_mastery/live_previews/widgets/column_preview.dart';
import 'package:flutter_mastery/live_previews/widgets/listview_preview.dart';
import 'package:flutter_mastery/live_previews/widgets/gridview_preview.dart';
import 'package:flutter_mastery/live_previews/widgets/stack_preview.dart';
import 'package:flutter_mastery/live_previews/widgets/sizedbox_preview.dart';
import 'package:flutter_mastery/live_previews/widgets/divider_preview.dart';

/// Registry mapping preview types from `info.json` (e.g. `"container"`) to the corresponding preview widget.
Widget getTopicPreview(String previewType) {
  switch (previewType.toLowerCase()) {
    case 'container':
      return const ContainerPreview();
    case 'text':
      return const TextPreview();
    case 'card':
      return const CardPreview();
    case 'icon':
      return const IconPreview();
    case 'image':
      return const ImagePreview();
    case 'buttons':
      return const ButtonsPreview();
    case 'textfield':
      return const TextFieldPreview();
    case 'dropdownbutton':
      return const DropdownButtonPreview();
    case 'textformfield':
      return const TextFormFieldPreview();
    case 'appbar':
      return const AppBarPreview();
    case 'row':
      return const RowPreview();
    case 'column':
      return const ColumnPreview();
    case 'listview':
      return const ListViewPreview();
    case 'gridview':
      return const GridViewPreview();
    case 'stack':
      return const StackPreview();
    case 'sizedbox':
      return const SizedBoxPreview();
    case 'divider':
      return const DividerPreview();
    default:
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Live preview not available for this widget.',
            style: TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      );
  }
}
