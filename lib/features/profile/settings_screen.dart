import 'package:flutter/material.dart';

import 'package:watchers/core/theme/app_colors.dart';
import 'package:watchers/core/theme/theme_controller.dart';
import 'package:watchers/shared/widgets/setting_row.dart';
import 'package:watchers/shared/widgets/watcher_status_bar.dart';
import 'package:watchers/shared/widgets/watcher_toggle.dart';

import 'widgets/settings_header.dart';
import 'widgets/settings_profile_card.dart';
import 'widgets/settings_section.dart';
import 'widgets/settings_section_label.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _newEpisodes = true;
  bool _watchlistReminders = false;
  bool _privateProfile = false;

  @override
  Widget build(BuildContext context) {
    final palette = WatchersPalette.of(context);
    return Scaffold(
      backgroundColor: palette.bg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const WatcherStatusBar(),
          const SettingsHeader(),
          Expanded(
            child: ListenableBuilder(
              listenable: ThemeController.instance,
              builder: (context, _) {
                final dark = ThemeController.instance.isDark;
                return ListView(
                  padding: const EdgeInsets.only(bottom: 40),
                  children: [
                    const SettingsProfileCard(),
                    const SettingsSectionLabel(label: 'Appearance'),
                    SettingsSection(
                      children: [
                        SettingRow(
                          icon: Icon(
                            Icons.light_mode_outlined,
                            size: 16,
                            color: palette.textSec,
                          ),
                          label: 'Appearance',
                          sub: dark ? 'Dark mode' : 'Light mode',
                          right: WatcherToggle(
                            value: dark,
                            onChanged: (value) =>
                                ThemeController.instance.setDark(value),
                          ),
                        ),
                        SettingRow(
                          icon: Icon(
                            Icons.notes,
                            size: 16,
                            color: palette.textSec,
                          ),
                          label: 'Language',
                          sub: 'English',
                        ),
                      ],
                    ),
                    const SettingsSectionLabel(label: 'Notifications'),
                    SettingsSection(
                      children: [
                        SettingRow(
                          icon: Icon(
                            Icons.notifications_none,
                            size: 16,
                            color: palette.textSec,
                          ),
                          label: 'New Episodes',
                          sub: 'Get notified when new episodes air',
                          right: WatcherToggle(
                            value: _newEpisodes,
                            onChanged: (value) =>
                                setState(() => _newEpisodes = value),
                          ),
                        ),
                        SettingRow(
                          icon: Icon(
                            Icons.mail_outline,
                            size: 16,
                            color: palette.textSec,
                          ),
                          label: 'Watchlist Reminders',
                          sub: 'Remind me about unwatched content',
                          right: WatcherToggle(
                            value: _watchlistReminders,
                            onChanged: (value) =>
                                setState(() => _watchlistReminders = value),
                          ),
                        ),
                      ],
                    ),
                    const SettingsSectionLabel(label: 'Privacy'),
                    SettingsSection(
                      children: [
                        SettingRow(
                          icon: Icon(
                            Icons.verified_user_outlined,
                            size: 16,
                            color: palette.textSec,
                          ),
                          label: 'Private Profile',
                          sub: 'Only you can see your activity',
                          right: WatcherToggle(
                            value: _privateProfile,
                            onChanged: (value) =>
                                setState(() => _privateProfile = value),
                          ),
                        ),
                        SettingRow(
                          icon: Icon(
                            Icons.person_outline,
                            size: 16,
                            color: palette.textSec,
                          ),
                          label: 'Manage Account',
                          sub: 'Password, email, and account details',
                        ),
                      ],
                    ),
                    const SettingsSectionLabel(label: 'About'),
                    SettingsSection(
                      children: [
                        SettingRow(
                          icon: Icon(
                            Icons.info_outline,
                            size: 16,
                            color: palette.textSec,
                          ),
                          label: 'About WATCHERS',
                          sub: 'Version 1.0.0',
                        ),
                        SettingRow(
                          icon: Icon(
                            Icons.mail_outline,
                            size: 16,
                            color: palette.textSec,
                          ),
                          label: 'Contact Support',
                        ),
                        SettingRow(
                          icon: Icon(
                            Icons.article_outlined,
                            size: 16,
                            color: palette.textSec,
                          ),
                          label: 'Privacy Policy',
                        ),
                      ],
                    ),
                    const SettingsSectionLabel(label: 'Account'),
                    SettingsSection(
                      children: [
                        SettingRow(
                          danger: true,
                          icon: Icon(
                            Icons.logout,
                            size: 16,
                            color: AppColors.danger,
                          ),
                          label: 'Sign Out',
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
