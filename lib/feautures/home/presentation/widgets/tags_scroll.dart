import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_notes_flutter/common/my_text.dart';
import 'package:my_notes_flutter/feautures/home/presentation/providers/notes_provider.dart';

class TagsScroll extends ConsumerStatefulWidget {
  const TagsScroll({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TagsScrollState();
}

class _TagsScrollState extends ConsumerState<TagsScroll> {
  String? selectedTag;

  @override
  Widget build(BuildContext context) {
    var topTags = ref.watch(topTagsProvider);

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: topTags.length,
        itemBuilder: (context, index) {
          final tag = topTags[index];
          final isSelected = selectedTag == tag;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedTag = tag;
              });
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: EdgeInsets.symmetric(horizontal: 5),
              padding: EdgeInsets.symmetric(
                horizontal: isSelected ? 10 : 16,
                vertical: isSelected ? 6 : 10,
              ),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blueAccent : Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
                boxShadow:
                    isSelected
                        ? [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.4),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                        : [],
              ),
              child: MyText(tag),
            ),
          );
        },
      ),
    );
  }
}
