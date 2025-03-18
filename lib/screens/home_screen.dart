import 'package:flutter/material.dart';
import 'package:taskone/screens/calendar_screen.dart';
import 'package:taskone/screens/task_list.dart';
import 'package:taskone/screens/tasks/schedule_manage_task.dart';
import 'package:taskone/screens/tasks/task_form_screen.dart';
import 'package:taskone/widgets/custon_botton_bar.dart';
import '../themes/color_scheme.dart'; // Importe o esquema de cores

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    TaskList(), // Tela 1
    ScheduleManageTask(), // Tela 2
    TaskFormScreen(), // Tela 3
    NotificationsScreen(), // Tela 4
    ProfileScreen(), // Tela 5
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor:
            Theme.of(
              context,
            ).colorScheme.secondary, // Usa a cor secundária do tema
        unselectedItemColor:
            Theme.of(
              context,
            ).colorScheme.onSurfaceVariant, // Usa a cor do texto secundário
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor:
            Theme.of(context).colorScheme.surface, // Usa a cor de superfície
        elevation: 4, // Sombra suave
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class AddScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Add Screen",
        style: TextStyle(
          fontSize: 24,
          color:
              Theme.of(
                context,
              ).colorScheme.onSurface, // Usa a cor do texto do tema
        ),
      ),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Notifications Screen",
        style: TextStyle(
          fontSize: 24,
          color:
              Theme.of(
                context,
              ).colorScheme.onSurface, // Usa a cor do texto do tema
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Profile Screen",
        style: TextStyle(
          fontSize: 24,
          color:
              Theme.of(
                context,
              ).colorScheme.onSurface, // Usa a cor do texto do tema
        ),
      ),
    );
  }
}
