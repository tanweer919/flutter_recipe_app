import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../models/recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe data;
  const RecipeCard({super.key, required this.data});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      // Card Wrapper
      child: Container(
        width: 160,
        height: 200,
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: CachedNetworkImageProvider(data.images.isNotEmpty
                ? data.images[0]
                : 'https://res.cloudinary.com/doy9hqxr1/image/upload/q_40/v1725202027/dish2_u6uxaz.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        // Recipe Card Info
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.black.withOpacity(0.26),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Recipe Title
                  AutoSizeText(
                    data.name,
                    maxLines: 2,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 150 / 100,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // Recipe Calories and Time
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: Wrap(
                      children: [
                        SvgPicture.asset(
                          'assets/svg/fire-filled.svg',
                          color: Colors.white,
                          width: 12,
                          height: 12,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 5),
                          child: Text(
                            data.calories.toString(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 10),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SvgPicture.asset(
                          'assets/svg/servings.svg',
                          color: Colors.white,
                          width: 12,
                          height: 12,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 5),
                          child: Text(
                            '${data.noOfServings.toString()} servings',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 10),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.alarm,
                                size: 12, color: Colors.white),
                            Container(
                              margin: const EdgeInsets.only(left: 5),
                              child: Text(
                                data.totalTime,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
