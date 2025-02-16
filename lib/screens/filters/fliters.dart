import 'package:flutter/material.dart';
import 'package:dekorner_recipe/models/recipe_filter.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FilterScreen extends HookWidget {
  const FilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedMealType = useState<RecipeFilter?>(null);
    final selectedDishType = useState<RecipeFilter?>(null);
    final selectedCuisine = useState<RecipeFilter?>(null);
    final selectedDietaryRestrictions = useState<List<RecipeFilter>>([]);
    final selectedCookingMethod = useState<RecipeFilter?>(null);

    final showAllDishTypes = useState(false);
    final showAllCuisines = useState(false);
    final showAllDietaryRestrictions = useState(false);

    void clearFilters() {
      selectedMealType.value = null;
      selectedDishType.value = null;
      selectedCuisine.value = null;
      selectedDietaryRestrictions.value = [];
      selectedCookingMethod.value = null;
    }

    final mealTypes = [
      RecipeFilter(id: 27, name: 'Breakfast'),
      RecipeFilter(id: 36, name: 'Lunch'),
      RecipeFilter(id: 8, name: 'Dinner'),
      RecipeFilter(id: 39, name: 'Snacks'),
    ];

    final dishTypes = [
      RecipeFilter(id: 56, name: 'Pasta'),
      RecipeFilter(id: 22, name: 'Pizza'),
      RecipeFilter(id: 21, name: 'Salad'),
      RecipeFilter(id: 5, name: 'Dessert'),
      RecipeFilter(id: 10, name: 'Soup'),
      RecipeFilter(id: 18, name: 'Cake'),
      RecipeFilter(id: 16, name: 'Pie'),
      RecipeFilter(id: 13, name: 'Chicken'),
      RecipeFilter(id: 60, name: 'Shrimp'),
      RecipeFilter(id: 34, name: 'Fish'),
      RecipeFilter(id: 29, name: 'Rice'),
      RecipeFilter(id: 23, name: 'Bread'),
      RecipeFilter(id: 24, name: 'Pudding'),
    ];

    final cuisines = [
      RecipeFilter(id: 7, name: 'Indian'),
      RecipeFilter(id: 17, name: 'Italian'),
      RecipeFilter(id: 20, name: 'Mexican'),
      RecipeFilter(id: 204, name: 'Chinese'),
      RecipeFilter(id: 205, name: 'Japanese'),
      RecipeFilter(id: 206, name: 'Thai'),
      RecipeFilter(id: 207, name: 'Korean'),
      RecipeFilter(id: 208, name: 'French'),
      RecipeFilter(id: 209, name: 'Spanish'),
      RecipeFilter(id: 210, name: 'German'),
      RecipeFilter(id: 211, name: 'Turkish'),
      RecipeFilter(id: 212, name: 'Greek'),
      RecipeFilter(id: 213, name: 'Russian'),
      RecipeFilter(id: 214, name: 'English'),
      RecipeFilter(id: 215, name: 'Moroccan'),
      RecipeFilter(id: 216, name: 'Lebanese'),
      RecipeFilter(id: 217, name: 'Egyptian'),
      RecipeFilter(id: 218, name: 'Vietnamese'),
      RecipeFilter(id: 219, name: 'Cuban'),
    ];

    final dietaryRestrictions = [
      RecipeFilter(id: 12, name: 'Vegetarian'),
      RecipeFilter(id: 9, name: 'Vegan'),
      RecipeFilter(id: 303, name: 'Low-Calorie'),
      RecipeFilter(id: 304, name: 'Low-Carb'),
      RecipeFilter(id: 305, name: 'Low-Fat'),
      RecipeFilter(id: 306, name: 'Low-Sodium'),
      RecipeFilter(id: 307, name: 'Dairy-Free'),
      RecipeFilter(id: 308, name: 'Gluten-Free'),
      RecipeFilter(id: 309, name: 'Lactose-Free'),
      RecipeFilter(id: 310, name: 'Sugar-Free'),
      RecipeFilter(id: 311, name: 'Salt-Free'),
    ];

    final cookingMethods = [
      RecipeFilter(id: 45, name: 'Baking'),
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'Filters',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 16.0,
                bottom: 80.0, // Add padding at bottom for the fixed container
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Meal Type',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: mealTypes
                        .map(
                          (filter) => FilterChip(
                            label: Text(filter.name),
                            selected: selectedMealType.value?.id == filter.id,
                            onSelected: (bool selected) {
                              selectedMealType.value = selected ? filter : null;
                            },
                            backgroundColor: const Color(0xffFAFAFA),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(
                                color: Color(0xffE0E0E0),
                                width: 1,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Dish Type',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: (showAllDishTypes.value
                                ? dishTypes
                                : dishTypes.take(6).toList())
                            .map(
                              (filter) => FilterChip(
                                label: Text(filter.name),
                                selected:
                                    selectedDishType.value?.id == filter.id,
                                onSelected: (bool selected) {
                                  selectedDishType.value =
                                      selected ? filter : null;
                                },
                                backgroundColor: const Color(0xffFAFAFA),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: const BorderSide(
                                    color: Color(0xffE0E0E0),
                                    width: 1,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      if (dishTypes.length > 6)
                        TextButton(
                          onPressed: () {
                            showAllDishTypes.value = !showAllDishTypes.value;
                          },
                          child: Text(
                            showAllDishTypes.value ? 'Show Less' : 'Show More',
                            style: const TextStyle(
                              color: Color(0xFF1E88E5),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Cuisine',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: (showAllCuisines.value
                                ? cuisines
                                : cuisines.take(6).toList())
                            .map((filter) => FilterChip(
                                  label: Text(filter.name),
                                  selected:
                                      selectedCuisine.value?.id == filter.id,
                                  onSelected: (bool selected) {
                                    selectedCuisine.value =
                                        selected ? filter : null;
                                  },
                                  backgroundColor: const Color(0xffFAFAFA),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: const BorderSide(
                                      color: Color(0xffE0E0E0),
                                      width: 1,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                      if (cuisines.length > 6)
                        TextButton(
                          onPressed: () {
                            showAllCuisines.value = !showAllCuisines.value;
                          },
                          child: Text(
                            showAllCuisines.value ? 'Show Less' : 'Show More',
                            style: const TextStyle(
                              color: Color(0xFF1E88E5),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Dietary Restrictions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: (showAllDietaryRestrictions.value
                                ? dietaryRestrictions
                                : dietaryRestrictions.take(6).toList())
                            .map((filter) => FilterChip(
                                  label: Text(filter.name),
                                  selected: selectedDietaryRestrictions.value
                                      .any((selected) =>
                                          selected.id == filter.id),
                                  onSelected: (bool selected) {
                                    if (selected) {
                                      selectedDietaryRestrictions.value = [
                                        ...selectedDietaryRestrictions.value,
                                        filter
                                      ];
                                    } else {
                                      selectedDietaryRestrictions.value =
                                          selectedDietaryRestrictions.value
                                              .where((selected) =>
                                                  selected.id != filter.id)
                                              .toList();
                                    }
                                  },
                                  backgroundColor: const Color(0xffFAFAFA),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: const BorderSide(
                                      color: Color(0xffE0E0E0),
                                      width: 1,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                      if (dietaryRestrictions.length > 6)
                        TextButton(
                          onPressed: () {
                            showAllDietaryRestrictions.value =
                                !showAllDietaryRestrictions.value;
                          },
                          child: Text(
                            showAllDietaryRestrictions.value
                                ? 'Show Less'
                                : 'Show More',
                            style: const TextStyle(
                              color: Color(0xFF1E88E5),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Cooking Method',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: cookingMethods
                        .map((filter) => FilterChip(
                              label: Text(filter.name),
                              selected:
                                  selectedCookingMethod.value?.id == filter.id,
                              onSelected: (bool selected) {
                                selectedCookingMethod.value =
                                    selected ? filter : null;
                              },
                              backgroundColor: const Color(0xffFAFAFA),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(
                                  color: Color(0xffE0E0E0),
                                  width: 1,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: clearFilters,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Clear filters',
                          style: TextStyle(
                            color: Color.fromARGB(255, 7, 124, 227),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Return selected filters to previous screen
                          Navigator.of(context)
                              .pushNamed('/filter/results', arguments: [
                            if (selectedMealType.value != null)
                              selectedMealType.value!,
                            if (selectedDishType.value != null)
                              selectedDishType.value!,
                            if (selectedCuisine.value != null)
                              selectedCuisine.value!,
                            ...selectedDietaryRestrictions.value,
                            if (selectedCookingMethod.value != null)
                              selectedCookingMethod.value!,
                          ]);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E88E5),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Apply',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
