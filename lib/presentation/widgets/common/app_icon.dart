import 'package:flutter/material.dart';

enum AppIconName {
  add,
  chevronRight,
  close,
  emailOutlined,
  imageOutlined,
  lockOutlined,
  logout,
  menu,
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

  const AppIcon({
    super.key,
    required this.name,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(_iconData(name), size: size, color: color);
  }
}

IconData _iconData(AppIconName name) => switch (name) {
      AppIconName.add => Icons.add,
      AppIconName.chevronRight => Icons.chevron_right,
      AppIconName.close => Icons.close,
      AppIconName.emailOutlined => Icons.email_outlined,
      AppIconName.imageOutlined => Icons.image_outlined,
      AppIconName.lockOutlined => Icons.lock_outlined,
      AppIconName.logout => Icons.logout,
      AppIconName.menu => Icons.menu,
      AppIconName.micOutlined => Icons.mic_outlined,
      AppIconName.pictureAsPdfOutlined => Icons.picture_as_pdf_outlined,
      AppIconName.search => Icons.search,
      AppIconName.stickyNote2Outlined => Icons.sticky_note_2_outlined,
      AppIconName.textFields => Icons.text_fields,
      AppIconName.visibilityOffOutlined => Icons.visibility_off_outlined,
      AppIconName.visibilityOutlined => Icons.visibility_outlined,
    };
