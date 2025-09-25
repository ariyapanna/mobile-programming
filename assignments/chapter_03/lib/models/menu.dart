enum MenuCategory {
    Food,
    Beverage
}

class Menu {
    final String name, imageUrl;
    final MenuCategory category;
    final double price;

    Menu({required this.name, required this.category, required this.imageUrl, required this.price});

    String getName() => name;
    String getCategory() => category.toString();
    String getImageUrl() => imageUrl;
    double getPrice() => price;
}