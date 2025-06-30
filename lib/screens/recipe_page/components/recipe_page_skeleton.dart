import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RecipePageSkeleton extends StatelessWidget {
  const RecipePageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          children: [
            Container(
              height: 350,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
