import 'package:flutter/material.dart';
import 'package:my_notes/presentation/widgets/common/app_icon.dart';
import 'package:my_notes/presentation/widgets/home/fab_option_item.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';

class FabNotes extends StatefulWidget {
  final List<(AppIconName, String)> options;

  const FabNotes({super.key, required this.options});

  @override
  State<FabNotes> createState() => _FabNotesState();
}

class _FabNotesState extends State<FabNotes>
    with SingleTickerProviderStateMixin {
  static const _toggleDuration = Duration(milliseconds: 250);

  final _fabSize = 56.0;
  late final AnimationController _controller;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _toggleDuration, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _isOpen = !_isOpen);
    _isOpen ? _controller.forward() : _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final fabBottom = spacing.md;
    final optionsBottom = fabBottom + _fabSize + spacing.sm;

    return Stack(
      children: [
        _FabScrim(isOpen: _isOpen, onTap: _toggle),
        _FabSpeedDialOptions(
          isOpen: _isOpen,
          controller: _controller,
          options: widget.options,
          bottom: optionsBottom,
        ),
        Positioned(
          right: spacing.md,
          bottom: fabBottom,
          child: FloatingActionButton(
            onPressed: _toggle,
            tooltip: context.l10n.addNote,
            child: AnimatedRotation(
              turns: _isOpen ? 0.125 : 0.0,
              duration: _toggleDuration,
              child: const AppIcon(name: AppIconName.add),
            ),
          ),
        ),
      ],
    );
  }
}

class _FabScrim extends StatelessWidget {
  static const _duration = Duration(milliseconds: 200);

  final bool isOpen;
  final VoidCallback onTap;

  const _FabScrim({required this.isOpen, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: !isOpen,
        child: AnimatedOpacity(
          opacity: isOpen ? 1.0 : 0.0,
          duration: _duration,
          child: GestureDetector(
            onTap: onTap,
            child: ColoredBox(
              color: context.colors.fabScrim,
            ),
          ),
        ),
      ),
    );
  }
}

class _FabSpeedDialOptions extends StatelessWidget {
  final bool isOpen;
  final AnimationController controller;
  final List<(AppIconName, String)> options;
  final double bottom;

  const _FabSpeedDialOptions({
    required this.isOpen,
    required this.controller,
    required this.options,
    required this.bottom,
  });

  Animation<double> _itemAnimation(int index) {
    final reversedIndex = (options.length - 1) - index;
    final start = reversedIndex * 0.1;
    final end = (start + 0.6).clamp(0.0, 1.0);
    return CurvedAnimation(
      parent: controller,
      curve: Interval(start, end, curve: Curves.easeOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    return Positioned(
      right: spacing.md,
      bottom: bottom,
      child: IgnorePointer(
        ignoring: !isOpen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: List.generate(options.length, (i) {
            return Padding(
              padding: EdgeInsets.only(bottom: spacing.sm),
              child: FabOptionItem(
                icon: options[i].$1,
                label: options[i].$2,
                animation: _itemAnimation(i),
              ),
            );
          }),
        ),
      ),
    );
  }
}
