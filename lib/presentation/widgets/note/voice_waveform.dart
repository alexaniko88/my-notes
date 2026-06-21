import 'package:flutter/material.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';

class VoiceWaveform extends StatelessWidget {
  static const _barAnimationDuration = Duration(milliseconds: 180);

  final List<double> levels;
  final double _height = 96.0;
  final double _barWidth = 3.0;
  final double _minBarFraction = 0.04;

  const VoiceWaveform({super.key, required this.levels});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = context.dimensions.spacing;
    final barColor = theme.colorScheme.primary;
    final barRadius = BorderRadius.circular(_barWidth);

    return SizedBox(
      height: _height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (final level in levels)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.xs / 2),
              child: AnimatedContainer(
                duration: _barAnimationDuration,
                curve: Curves.easeOut,
                width: _barWidth,
                height:
                    _height * (_minBarFraction + level * (1 - _minBarFraction)),
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: barRadius,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
