import 'package:flutter/material.dart';

class FilterButtons extends StatelessWidget {
  final String currentFilter;
  final Function(String) onFilterChanged;

  const FilterButtons({
    Key? key,
    required this.currentFilter,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildFilterButton('all', 'Todas'),
        _buildFilterButton('completed', 'Concluídas'),
        _buildFilterButton('pending', 'Pendentes'),
      ],
    );
  }

  Widget _buildFilterButton(String filter, String label) {
    final isSelected = filter == currentFilter;
    return ElevatedButton(
      onPressed: () => onFilterChanged(filter),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
      ),
      child: Text(label),
    );
  }
}
