import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planner_plus/core/constants/app_constants.dart';
import 'package:planner_plus/features/tasks/presentation/providers/theme_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentThemeMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _SectionHeader(
            title: 'Appearance',
            icon: Icons.palette,
            theme: theme,
          ),

          ListTile(
            leading: const Icon(Icons.light_mode),
            title: const Text('Light Mode'),
            trailing: Radio<ThemeMode>(
              value: ThemeMode.light,
              groupValue: currentThemeMode,
              onChanged: (mode) {
                if (mode != null) {
                  ref.read(themeProvider.notifier).setThemeMode(mode);
                }
              },
            ),
            onTap: () {
              ref.read(themeProvider.notifier).setThemeMode(ThemeMode.light);
            },
          ),

          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            trailing: Radio<ThemeMode>(
              value: ThemeMode.dark,
              groupValue: currentThemeMode,
              onChanged: (mode) {
                if (mode != null) {
                  ref.read(themeProvider.notifier).setThemeMode(mode);
                }
              },
            ),
            onTap: () {
              ref.read(themeProvider.notifier).setThemeMode(ThemeMode.dark);
            },
          ),

          ListTile(
            leading: const Icon(Icons.settings_suggest),
            title: const Text('System'),
            subtitle: const Text('Follow system theme'),
            trailing: Radio<ThemeMode>(
              value: ThemeMode.system,
              groupValue: currentThemeMode,
              onChanged: (mode) {
                if (mode != null) {
                  ref.read(themeProvider.notifier).setThemeMode(mode);
                }
              },
            ),
            onTap: () {
              ref.read(themeProvider.notifier).setThemeMode(ThemeMode.system);
            },
          ),

          const Divider(),

          _SectionHeader(
            title: 'About',
            icon: Icons.info,
            theme: theme,
          ),

          ListTile(
            leading: const Icon(Icons.app_settings_alt),
            title: const Text('Version'),
            subtitle: const Text(AppConstants.appVersion),
          ),

          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('About Planner+'),
            subtitle: const Text(
              'A production-quality task planning app',
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.theme,
  });

  final String title;
  final IconData icon;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.defaultPadding,
        AppConstants.largePadding,
        AppConstants.defaultPadding,
        AppConstants.smallPadding,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: AppConstants.smallPadding),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
