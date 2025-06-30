import 'package:dekorner_recipe/models/tab_bar_item.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CustomTabBar extends HookWidget {
  final List<TabBarItem> items;
  final int? tabIndex;

  const CustomTabBar({
    super.key,
    required this.items,
    this.tabIndex,
  });

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState(tabIndex ?? 0);
    final pageController = usePageController();
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xffe6ebf3),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  left: currentIndex.value *
                      (MediaQuery.of(context).size.width - 40) /
                      items.length,
                  top: 0,
                  bottom: 0,
                  width:
                      (MediaQuery.of(context).size.width - 40) / items.length,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff042629),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                Row(
                  children: [
                    for (int i = 0; i < items.length; i++)
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            currentIndex.value = i;
                            pageController.animateToPage(
                              i,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: SizedBox(
                            height: 46,
                            child: Center(
                              child: Text(
                                items[i].title,
                                style: TextStyle(
                                  color: i == currentIndex.value
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ExpandablePageView.builder(
              controller: pageController,
              itemCount: items.length,
              onPageChanged: (index) {
                currentIndex.value = index;
              },
              itemBuilder: (context, index) {
                return items[index].child;
              },
            ),
          ),
        )
      ],
    );
  }
}
