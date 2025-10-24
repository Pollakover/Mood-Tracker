import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: AppConstants.availableMoods.map((moodOption) {
            final isSelected = selectedMood == moodOption.value;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
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
                      _buildEmojiImage(moodOption),
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

  Widget _buildEmojiImage(MoodConfig moodOption) {
    return CachedNetworkImage(
      imageUrl: moodOption.imageUrl,
      width: 32,
      height: 32,
      placeholder: (context, url) => Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(strokeWidth: 2),
      ),
      errorWidget: (context, url, error) => Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        child: Text(
          moodOption.emoji,
          style: const TextStyle(fontSize: 20),
        ),
      ),
      fit: BoxFit.contain,
    );
  }
}