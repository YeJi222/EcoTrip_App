
class Product {
  const Product({
    required this.title,
    required this.description,
    required this.imageURL,
    required this.location,
  });

  final String title;
  final String location;
  final String description;
  final String imageURL;
}