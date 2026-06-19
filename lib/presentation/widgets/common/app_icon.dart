import 'package:flutter/material.dart';

enum AppIconName {
  add,
  check,
  chevronRight,
  close,
  deleteForever,
  deleteOutlined,
  editOutlined,
  emailOutlined,
  imageOutlined,
  labelOutlined,
  lockOutlined,
  logout,
  menu,
  moreVert,
  pushPin,
  pushPinOutlined,
  restore,
  micOutlined,
  pictureAsPdfOutlined,
  search,
  stickyNote2Outlined,
  textFields,
  visibilityOffOutlined,
  visibilityOutlined,
}

class AppIcon extends StatelessWidget {
  final AppIconName name;
  final double? size;
  final Color? color;

  const AppIcon({super.key, required this.name, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    return Icon(_iconData(name), size: size, color: color);
  }
}

IconData _iconData(AppIconName name) => switch (name) {
  AppIconName.add => Icons.add,
  AppIconName.check => Icons.check,
  AppIconName.chevronRight => Icons.chevron_right,
  AppIconName.close => Icons.close,
  AppIconName.deleteForever => Icons.delete_forever,
  AppIconName.deleteOutlined => Icons.delete_outline,
  AppIconName.editOutlined => Icons.edit_outlined,
  AppIconName.emailOutlined => Icons.email_outlined,
  AppIconName.imageOutlined => Icons.image_outlined,
  AppIconName.labelOutlined => Icons.label_outline,
  AppIconName.lockOutlined => Icons.lock_outlined,
  AppIconName.logout => Icons.logout,
  AppIconName.menu => Icons.menu,
  AppIconName.moreVert => Icons.more_vert,
  AppIconName.pushPin => Icons.push_pin,
  AppIconName.pushPinOutlined => Icons.push_pin_outlined,
  AppIconName.restore => Icons.restore,
  AppIconName.micOutlined => Icons.mic_outlined,
  AppIconName.pictureAsPdfOutlined => Icons.picture_as_pdf_outlined,
  AppIconName.search => Icons.search,
  AppIconName.stickyNote2Outlined => Icons.sticky_note_2_outlined,
  AppIconName.textFields => Icons.text_fields,
  AppIconName.visibilityOffOutlined => Icons.visibility_off_outlined,
  AppIconName.visibilityOutlined => Icons.visibility_outlined,
};
