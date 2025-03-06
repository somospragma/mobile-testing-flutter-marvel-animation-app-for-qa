import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marvel_animation_app/features/home/presentation/pages/home_page.dart';
import 'package:marvel_animation_app/features/home/presentation/pages/profile_page.dart';
import '../../../../shared/presentation/state/navigation_provider.dart';
import '../../../../shared/presentation/templates/main_template.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  final List<Widget> _pages = const [
    HomePage(),  
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationProvider); 

    return MainTemplate(
      displayBottomBar: true,
      body: _pages[currentIndex],
    );
  }
}
