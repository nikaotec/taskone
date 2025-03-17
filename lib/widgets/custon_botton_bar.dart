import 'package:flutter/material.dart';

class CustomBottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ícones e rótulos para o BottomNavigationBar
    final List<IconData> icons = [
      Icons.home_outlined,
      Icons.calendar_today_outlined,
      Icons.add_circle_outline,
      Icons.notifications_outlined,
      Icons.person_outlined,
    ];

    final List<String> labels = [
      "Home",
      "Calendar",
      "Add",
      "Notifications",
      "Profile",
    ];

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue, // Cor do ícone selecionado
        unselectedItemColor: Colors.grey, // Cor dos ícones não selecionados
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items:
            icons.asMap().entries.map((entry) {
              int index = entry.key;
              IconData icon = entry.value;
              return BottomNavigationBarItem(
                icon: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:
                        selectedIndex == index
                            ? Colors.blue.withOpacity(0.1)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon),
                ),
                label: labels[index],
              );
            }).toList(),
      ),
    );
  }
}
