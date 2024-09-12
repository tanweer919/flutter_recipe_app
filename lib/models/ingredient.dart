class Ingredient {
  final int id;
  final String name;
  final String? affiliateLink;

  Ingredient({required this.id, required this.name, this.affiliateLink});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
        id: json['id'],
        name: json['name'],
        affiliateLink: json['affiliate_link']);
  }
}
