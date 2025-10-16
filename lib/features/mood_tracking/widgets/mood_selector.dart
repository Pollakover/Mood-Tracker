import 'package:flutter/material.dart';
import 'package:mood_tracker/shared/app_constants.dart';

class MoodSelector extends StatelessWidget {
  final String? selectedMood;
  final ValueChanged<String> onMoodSelected;

  const MoodSelector({
    super.key,
    this.selectedMood,
    required this.onMoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: SingleChildScrollView( // Добавляем горизонтальную прокрутку
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: AppConstants.availableMoods.map((moodOption) {
            final isSelected = selectedMood == moodOption.value;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0), // Добавляем отступы между элементами
              child: GestureDetector(
                onTap: () => onMoodSelected(moodOption.value),
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? moodOption.color.withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: isSelected ? moodOption.color : Colors.transparent,
                      width: 2.0,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        moodOption.emoji,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        moodOption.label,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? moodOption.color : Colors.grey,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}