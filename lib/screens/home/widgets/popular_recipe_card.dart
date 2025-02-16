// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dekorner_recipe/screens/recipe_page/recipe_screen_arguments.dart';
import 'package:flutter/material.dart';

import 'package:dekorner_recipe/models/recipe.dart';
import 'package:flutter_svg/svg.dart';

class PopularRecipeCard extends StatelessWidget {
  final Recipe recipe;
  const PopularRecipeCard({
    super.key,
    required this.recipe,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/recipe',
            arguments: RecipeScreenArguments(recipe: recipe));
      },
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: recipe.images[0],
                fit: BoxFit.cover,
                height: 60,
                width: 60,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.name,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      // overflowReplacement: FittedBox(
                      //   fit: BoxFit.fitWidth,
                      //   child: Text(
                      //     recipe.name,
                      //     style: const TextStyle(
                      //       fontSize: 17,
                      //       fontWeight: FontWeight.w600,
                      //     ),
                      //   ),
                      // ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.alarm,
                                size: 16,
                                color: Color.fromARGB(255, 83, 79, 79),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 5),
                                child: Text(
                                  recipe.totalTime,
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 83, 79, 79),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 32.0),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/svg/servings.svg',
                                  color: Color.fromARGB(255, 83, 79, 79),
                                  width: 16,
                                  height: 16,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    '${recipe.noOfServings.toString()} servings',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 83, 79, 79),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
