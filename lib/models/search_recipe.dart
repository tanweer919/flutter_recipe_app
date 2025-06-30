class SearchRecipe {
  final int id;
  final String name;
  final String? image;
  SearchRecipe({required this.id, required this.name, this.image});

  factory SearchRecipe.fromJson(Map<String, dynamic> json) {
    return SearchRecipe(
      id: json['id'],
      name: json['name'],
      image: json['image'] != null && json['image'] != 'default.jpg'
          ? json['image']
          : null,
    );
  }
}
