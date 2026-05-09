import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_notes/domain/models/note.dart';
import 'package:my_notes/presentation/screens/playground/playground_item_screen.dart';
import 'package:my_notes/presentation/widgets/notes/note_card.dart';
import 'package:my_notes/shared/navigation/app_route.dart';

class PlaygroundScreen extends StatelessWidget {
  const PlaygroundScreen({super.key});

  static final _now = DateTime.now();
  static final _yesterday = _now.subtract(const Duration(days: 1));
  static final _pastDate = _now.subtract(const Duration(days: 30));

  static final _configs = <PlaygroundItemConfig>[
    PlaygroundItemConfig(
      label: 'NoteCard',
      variants: [
        PlaygroundVariant(
          label: 'Title only',
          child: NoteCard(
            note: Note(
              id: '1',
              isPinned: false,
              createdAt: _now,
              updatedAt: _now,
              title: 'Shopping list',
            ),
          ),
        ),
        PlaygroundVariant(
          label: 'Body only',
          child: NoteCard(
            note: Note(
              id: '2',
              isPinned: false,
              createdAt: _now,
              updatedAt: _now,
              body: 'Pick up milk, eggs, and bread from the store.',
            ),
          ),
        ),
        PlaygroundVariant(
          label: 'Title + body',
          child: NoteCard(
            note: Note(
              id: '3',
              isPinned: false,
              createdAt: _now,
              updatedAt: _now,
              title: 'Meeting notes',
              body: 'Discuss Q3 roadmap, assign owners, follow up by Friday.',
            ),
          ),
        ),
        PlaygroundVariant(
          label: 'Title + body + color',
          child: NoteCard(
            note: Note(
              id: '4',
              isPinned: false,
              createdAt: _now,
              updatedAt: _now,
              title: 'Idea',
              body: 'Build a widget playground for fast visual testing.',
              color: 0xFFFFF9C4,
            ),
          ),
        ),
        PlaygroundVariant(
          label: 'Long body, no title',
          child: NoteCard(
            note: Note(
              id: '5',
              isPinned: false,
              createdAt: _now,
              updatedAt: _now,
              body: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                  'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
                  'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.',
            ),
          ),
        ),
        PlaygroundVariant(
          label: 'Long title + long body',
          child: NoteCard(
            note: Note(
              id: '6',
              isPinned: false,
              createdAt: _now,
              updatedAt: _now,
              title: 'This is a very long title that might wrap onto multiple lines',
              body: 'And here is a body that also has quite a bit of content. '
                  'It keeps going to show how the card handles overflow gracefully.',
            ),
          ),
        ),
        PlaygroundVariant(
          label: 'Updated yesterday',
          child: NoteCard(
            note: Note(
              id: '7',
              isPinned: false,
              createdAt: _yesterday,
              updatedAt: _yesterday,
              title: "Yesterday's note",
              body: 'Written and last updated yesterday.',
            ),
          ),
        ),
        PlaygroundVariant(
          label: 'Updated 30 days ago',
          child: NoteCard(
            note: Note(
              id: '8',
              isPinned: false,
              createdAt: _pastDate,
              updatedAt: _pastDate,
              title: 'Old note',
              body: 'This note was last touched a month ago.',
              color: 0xFFE8F5E9,
            ),
          ),
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Playground')),
      body: ListView.separated(
        itemCount: _configs.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) => ListTile(
          title: Text(_configs[index].label),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push(
            AppRoute.playgroundItem.path,
            extra: _configs[index],
          ),
        ),
      ),
    );
  }
}
