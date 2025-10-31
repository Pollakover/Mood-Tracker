// lib/features/mood_tracking/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _dark = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Тёмная тема (локально)'),
              value: _dark,
              onChanged: (v) => setState(() => _dark = v),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Перейти на Главную (GoRouter)'),
            ),
          ],
        ),
      ),
    );
  }
}
