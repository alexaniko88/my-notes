import 'package:my_notes/domain/models/note.dart';
import 'package:my_notes/domain/repositories/note_repository.dart';

// Fake in-memory implementation — replace with FirebaseNoteRepository when persistence is ready.
class InMemoryNoteRepository implements NoteRepository {
  InMemoryNoteRepository() {
    _notes.addAll(_seedNotes());
  }

  final List<Note> _notes = [];

  @override
  List<Note> getAll() => List.unmodifiable(_notes);

  @override
  void add(Note note) => _notes.add(note);

  @override
  void update(Note note) {
    final index = _notes.indexWhere((n) => n.id == note.id);
    if (index != -1) _notes[index] = note;
  }

  @override
  void delete(String id) => _notes.removeWhere((n) => n.id == id);
}

List<Note> _seedNotes() {
  final now = DateTime.now();
  final yesterday = now.subtract(const Duration(days: 1));
  final lastWeek = now.subtract(const Duration(days: 7));

  return [
    Note(
      id: '1',
      title: 'Shopping list',
      body: 'Milk, eggs, bread, butter, coffee',
      isPinned: true,
      color: 0xFFFFF9C4,
      createdAt: now,
      updatedAt: now,
    ),
    Note(
      id: '2',
      title: 'Meeting notes',
      body: 'Discuss Q2 roadmap, review PRs, plan sprint',
      isPinned: false,
      color: 0xFFB2EBF2,
      createdAt: yesterday,
      updatedAt: yesterday,
    ),
    Note(
      id: '3',
      title: 'Book ideas',
      body: 'The Pragmatic Programmer, Clean Code, SICP',
      isPinned: false,
      createdAt: yesterday,
      updatedAt: yesterday,
    ),
    Note(
      id: '4',
      body: 'Call dentist tomorrow at 9am',
      isPinned: false,
      color: 0xFFFFCDD2,
      createdAt: now,
      updatedAt: now,
    ),
    Note(
      id: '5',
      title: 'Flutter tips',
      body: 'Use const constructors, prefer StatelessWidget, extract widgets for readability',
      isPinned: true,
      color: 0xFFC8E6C9,
      createdAt: yesterday,
      updatedAt: yesterday,
    ),
    Note(
      id: '6',
      title: 'Ideas',
      isPinned: false,
      color: 0xFFE1BEE7,
      createdAt: yesterday,
      updatedAt: yesterday,
    ),
    Note(
      id: '7',
      title: 'Travel plans',
      body: 'Kyoto in April, book flights by end of month',
      isPinned: false,
      color: 0xFFFFE0B2,
      createdAt: lastWeek,
      updatedAt: lastWeek,
    ),
    Note(
      id: '8',
      body: 'Buy a standing desk',
      isPinned: false,
      createdAt: lastWeek,
      updatedAt: lastWeek,
    ),
    Note(
      id: '9',
      title: 'Workout routine',
      body: 'Mon: chest, Wed: back, Fri: legs, Sun: rest',
      isPinned: false,
      color: 0xFFB2DFDB,
      createdAt: lastWeek,
      updatedAt: now,
    ),
    Note(
      id: '10',
      title: 'Recipes to try',
      body: 'Shakshuka, Thai green curry, sourdough bread',
      isPinned: false,
      color: 0xFFFFF9C4,
      createdAt: lastWeek,
      updatedAt: lastWeek,
    ),
    Note(
      id: '11',
      title: 'Password hint',
      body: 'dog + street + year',
      isPinned: true,
      color: 0xFFFFCDD2,
      createdAt: lastWeek,
      updatedAt: lastWeek,
    ),
    Note(
      id: '12',
      body: 'Learn Rust this summer',
      isPinned: false,
      color: 0xFFE1BEE7,
      createdAt: lastWeek,
      updatedAt: lastWeek,
    ),
    Note(
      id: '13',
      title: 'Gift ideas',
      body: 'Dad: toolset, Mum: spa voucher, Sara: art book',
      isPinned: false,
      color: 0xFFB2EBF2,
      createdAt: lastWeek,
      updatedAt: yesterday,
    ),
    Note(
      id: '14',
      title: 'Sprint goals',
      body: 'Ship notes sync, add offline banner, fix card overflow',
      isPinned: false,
      color: 0xFFC8E6C9,
      createdAt: yesterday,
      updatedAt: now,
    ),
    Note(
      id: '15',
      body: 'Renew car insurance before June',
      isPinned: false,
      createdAt: lastWeek,
      updatedAt: lastWeek,
    ),
    Note(
      id: '16',
      title: 'Quote',
      body: '"The best time to plant a tree was 20 years ago."',
      isPinned: false,
      color: 0xFFFFE0B2,
      createdAt: lastWeek,
      updatedAt: lastWeek,
    ),
    Note(
      id: '17',
      title: 'App feature ideas',
      body: 'Voice search, widget on home screen, markdown support',
      isPinned: false,
      color: 0xFFB2DFDB,
      createdAt: lastWeek,
      updatedAt: yesterday,
    ),
    Note(
      id: '18',
      body: 'Pick up dry cleaning Friday',
      isPinned: false,
      color: 0xFFFFF9C4,
      createdAt: now,
      updatedAt: now,
    ),
    Note(
      id: '19',
      title: 'Conference talk',
      body: 'Submit CFP for FlutterCon — deadline end of month',
      isPinned: true,
      color: 0xFFFFCDD2,
      createdAt: yesterday,
      updatedAt: yesterday,
    ),
    Note(
      id: '20',
      title: 'Home repairs',
      body: 'Fix leaky tap, repaint hallway, replace doorbell',
      isPinned: false,
      color: 0xFFE1BEE7,
      createdAt: lastWeek,
      updatedAt: lastWeek,
    ),
  ];
}
