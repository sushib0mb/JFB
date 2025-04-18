// lib/settings_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'theme_notifier.dart';
import 'pages/survey/survey_list_page.dart';
import 'pages/survey/survey_page.dart';
import 'admin_dashboard.dart';
import 'package:flutter/foundation.dart';
// import 'providers/reminder_provider.dart';

class SettingsPage extends StatefulWidget {
  static const routeName = '/settings';
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeNotifier>();
    // final reminderProv = context.watch<ReminderProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          // Dark mode
          // SwitchListTile(
          //   title: const Text('Dark Mode'),
          //   subtitle: Text(theme.isDark ? 'Enabled' : 'Disabled'),
          //   value: theme.isDark,
          //   onChanged: (_) => theme.toggle(),
          // ),

          // Event reminders
          //  SwitchListTile(
          //     title: const Text('Event Reminders'),
          //     subtitle: Text(reminderProv.enabled ? 'On' : 'Off'),
          //     value: reminderProv.enabled,
          //     onChanged: (_) => reminderProv.toggle(),
          //   ),

          // Calendar sync stub
          // ListTile(
          //   leading: const Icon(Icons.calendar_today),
          //   title: const Text('Sync with Calendar'),
          //   onTap: () {
          //     // TODO: implement real calendar sync
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       const SnackBar(content: Text('Sync not yet implemented')),
          //     );
          //   },
          // ),

          // Share this app
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share this App'),
            onTap: () {
              Share.share(
                'Check out the JFB Festival app! Download it now and plan your visit.',
              );
            },
          ),

          // Report a bug → in‑app feedback form
          // ListTile(
          //   leading: const Icon(Icons.bug_report),
          //   title: const Text('Report a Bug'),
          //   onTap: () {
          //     Navigator.pushNamed(context, FeedbackPage.routeName);
          //   },
          // ),
          //           ListTile(
          //   leading: const Icon(Icons.pending_actions),
          //   title: const Text('Pending Feedback'),
          //   onTap: () =>
          //       Navigator.pushNamed(context, FeedbackListPage.routeName),
          // ),
          ListTile(
            leading: const Icon(Icons.poll),
            title: const Text('Fill Out Survey'),
            onTap: () => Navigator.pushNamed(context, SurveyPage.routeName),
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('View All Surveys'),
            onTap: () => Navigator.pushNamed(context, SurveyListPage.routeName),
          ),
          // if (kDebugMode)
          //   ListTile(
          //     leading: Icon(Icons.admin_panel_settings),
          //     title: Text('Admin Dashboard'),
          //     onTap: () => Navigator.pushNamed(context, AdminDashboardPage.routeName),
          //   ),

          // About & Version
          AboutListTile(
            icon: const Icon(Icons.info_outline),
            applicationName: 'JFBoston',
            applicationVersion: '1.0.0',
            applicationLegalese: '© 2025 Japan Festival Boston',
          ),
        ],
      ),
    );
  }
}
