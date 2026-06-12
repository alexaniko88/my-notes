import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_notes/domain/models/label.dart';
import 'package:my_notes/presentation/providers/auth/auth_provider.dart';
import 'package:my_notes/presentation/providers/labels/labels_provider.dart';
import 'package:my_notes/presentation/providers/labels/selected_label_provider.dart';
import 'package:my_notes/presentation/widgets/common/app_icon.dart';
import 'package:my_notes/presentation/widgets/common/app_text_button.dart';
import 'package:my_notes/presentation/widgets/home/drawer_labels_section.dart';
import 'package:my_notes/shared/extensions/build_context_extensions.dart';
import 'package:my_notes/shared/navigation/app_route.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  void _openEditLabels(BuildContext context) {
    Scaffold.of(context).closeDrawer();
    context.push(AppRoute.editLabels.path);
  }

  void _onLabelTap(BuildContext context, WidgetRef ref, Label label) {
    ref.read(selectedLabelProvider.notifier).toggle(label.id);
    Scaffold.of(context).closeDrawer();
  }

  Future<void> _onSignOut(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(l10n.signOutConfirmTitle),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(l10n.exitAppCancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text(l10n.signOutConfirm),
              ),
            ],
          ),
    );
    if (confirmed == true) {
      ref.read(authProvider.notifier).signOut();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final dimensions = context.dimensions;
    // while loading or on error the drawer simply shows no labels,
    // leaving only the "Create new label" row
    final labels = ref.watch(labelsProvider).asData?.value ?? const [];
    final selectedLabelId = ref.watch(selectedLabelProvider);

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DrawerLabelsSection(
              labels: labels,
              selectedLabelId: selectedLabelId,
              onEdit: () => _openEditLabels(context),
              onCreateLabel: () => _openEditLabels(context),
              onLabelTap: (label) => _onLabelTap(context, ref, label),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.all(dimensions.spacing.md),
              child: AppTextButton(
                label: l10n.signOut,
                leadingIcon: AppIconName.logout,
                color: theme.colorScheme.error,
                onPressed: () => _onSignOut(context, ref),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
