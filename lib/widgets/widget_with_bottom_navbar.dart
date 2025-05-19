import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:dekorner_recipe/widgets/custom_bottom_navbar.dart';
import 'package:flutter/material.dart';

class WidgetWithBottomNavbar extends StatelessWidget {
  final Widget child;
  const WidgetWithBottomNavbar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ColorfulSafeArea(
      color: Colors.white,
      child: Scaffold(
        body: child,
        bottomNavigationBar: const CustomNavbar(),
      ),
    );
  }
}
