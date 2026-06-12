import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_notes/presentation/screens/playground/items/note_card_item.dart';
import 'package:my_notes/presentation/screens/playground/playground_item_screen.dart';
import 'package:my_notes/presentation/widgets/common/app_icon.dart';
import 'package:my_notes/shared/navigation/app_route.dart';

class PlaygroundScreen extends StatelessWidget {
  const PlaygroundScreen({super.key});

  static final _configs = <PlaygroundItemConfig>[noteCardPlaygroundItem];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Playground')),
      body: ListView.separated(
        itemCount: _configs.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder:
            (context, index) => ListTile(
              title: Text(_configs[index].label),
              trailing: const AppIcon(name: AppIconName.chevronRight),
              onTap:
                  () => context.push(
                    AppRoute.playgroundItem.path,
                    extra: _configs[index],
                  ),
            ),
      ),
    );
  }
}
