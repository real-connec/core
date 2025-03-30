import 'package:flutter/material.dart';
import 'package:realconnect_ui/auth/widgets/dashboard_widgets.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = <Widget>[
    ChatsScreen(),
    AudioCallsScreen(),
    VideoCallsScreen(),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onFabPressed() {
    if (_selectedIndex == 0) {
      // New chat
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Start a new chat')),
      );
    } else if (_selectedIndex == 1) {
      // New audio call
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Start a new audio call')),
      );
    } else if (_selectedIndex == 2) {
      // New video call
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Start a new video call')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Handle logout
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out')),
              );
              // Navigate back to login or splash screen
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: _onFabPressed,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: 'Audio Calls',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_call),
            label: 'Video Calls',
          ),
        ],
      ),
    );
  }
}
