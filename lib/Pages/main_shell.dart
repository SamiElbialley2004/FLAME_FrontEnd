import 'package:flutter/material.dart';

import '../components/app_bottom_nav.dart';
import '../components/app_tab_scope.dart';
import 'events/events_page.dart';
import 'home/home_page.dart';
import 'profile/profile_screen.dart';
import 'social/communities/communities_screen.dart';
import 'workshops/workshop_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  late final List<Widget> _pages = const [
    HomePage(),
    WorkshopPage(),
    EventsPage(),
    CommunitiesScreen(),
    ProfileScreen(),
  ];

  void _selectTab(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return AppTabScope(
      selectTab: _selectTab,
      child: Scaffold(
        backgroundColor: const Color(0xFF09090B),
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        bottomNavigationBar: AppBottomNav(
          selectedIndex: _selectedIndex,
          onTap: _selectTab,
        ),
      ),
    );
  }
}
