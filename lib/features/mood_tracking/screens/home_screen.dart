// home_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Главная'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Главная'),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              icon: const Icon(Icons.track_changes),
              label: const Text('Открыть трекер настроения'),
              onPressed: () => context.go('/mood'),
            ),
            const SizedBox(height: 8),

            ElevatedButton.icon(
              icon: const Icon(Icons.list),
              label: const Text('Список записей'),
              onPressed: () => context.go('/list'),
            ),
            const SizedBox(height: 8),

            ElevatedButton.icon(
              icon: const Icon(Icons.settings),
              label: const Text('Настройки'),
              onPressed: () => context.go('/settings'),
            ),
            const SizedBox(height: 8),

            const Divider(),
            // const SizedBox(height: 8),
            // const Text('Примеры навигации:'),
            // const SizedBox(height: 8),

            // СТРАНИЧНАЯ НАВИГАЦИЯ - пример горизонтальной навигации
            // ElevatedButton(
            //   onPressed: () {
            //     // СТРАНИЧНАЯ НАВИГАЦИЯ - горизонтальная через pushReplacement
            //     Navigator.of(context).pushReplacement(
            //       MaterialPageRoute(
            //         builder: (_) => Scaffold(
            //           appBar: AppBar(title: const Text('Замещённый экран')),
            //           body: const Center(child: Text('Это пример pushReplacement')),
            //         ),
            //       ),
            //     );
            //   },
            //   child: const Text('Пример pushReplacement (горизонтальная)'),
            // ),
          ],
        ),
      ),
    );
  }
}