const undefined = Object();
extension StringCasingExtension on String {
  String get toCapitalized =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String get toTitleCase => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized)
      .join(' ');
}
String baseUrl = 'https://recipe-428313.el.r.appspot.com';
(bool, int?, int?) extractFraction(String input) {
  // Remove any leading/trailing whitespace and match the fraction pattern
  final match = RegExp(r'^(\d+)/(\d+)$').firstMatch(input.trim());

  if (match != null) {
    // Parse the numerator and denominator
    final numerator = int.tryParse(match.group(1)!);
    final denominator = int.tryParse(match.group(2)!);

    // Return the parsed values
    return (true, numerator, denominator);
  }

  // Return null values if the input is not a valid fraction
  return (false, null, null);
}
