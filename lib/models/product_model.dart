class ProductModel {
  final String id;
  final String sellerId;
  final String sellerName;
  final String name;
  final String description;
  final double price;
  final Currency currency;
  final int quantity;
  final ProductUnit unit;
  final ProductSize size;
  final ProductCategory category;
  final List<String> imageUrls;
  final String? location;
  final String? pincode;
  final double? latitude;
  final double? longitude;
  final ProductStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int views;
  final List<String> tags;

  ProductModel({
    required this.id,
    required this.sellerId,
    required this.sellerName,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
    required this.quantity,
    required this.unit,
    required this.size,
    required this.category,
    required this.imageUrls,
    this.location,
    this.pincode,
    this.latitude,
    this.longitude,
    this.status = ProductStatus.active,
    required this.createdAt,
    required this.updatedAt,
    this.views = 0,
    this.tags = const [],
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? '',
      sellerId: map['sellerId'] ?? '',
      sellerName: map['sellerName'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      currency: Currency.values.firstWhere(
            (e) => e.toString() == 'Currency.${map['currency']}',
        orElse: () => Currency.inr,
      ),
      quantity: map['quantity'] ?? 0,
      unit: ProductUnit.values.firstWhere(
            (e) => e.toString() == 'ProductUnit.${map['unit']}',
        orElse: () => ProductUnit.kg,
      ),
      size: ProductSize.values.firstWhere(
            (e) => e.toString() == 'ProductSize.${map['size']}',
        orElse: () => ProductSize.medium,
      ),
      category: ProductCategory.values.firstWhere(
            (e) => e.toString() == 'ProductCategory.${map['category']}',
        orElse: () => ProductCategory.vegetables,
      ),
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      location: map['location'],
      pincode: map['pincode'],
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      status: ProductStatus.values.firstWhere(
            (e) => e.toString() == 'ProductStatus.${map['status']}',
        orElse: () => ProductStatus.active,
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
      views: map['views'] ?? 0,
      tags: List<String>.from(map['tags'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'name': name,
      'description': description,
      'price': price,
      'currency': currency.toString().split('.').last,
      'quantity': quantity,
      'unit': unit.toString().split('.').last,
      'size': size.toString().split('.').last,
      'category': category.toString().split('.').last,
      'imageUrls': imageUrls,
      'location': location,
      'pincode': pincode,
      'latitude': latitude,
      'longitude': longitude,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'views': views,
      'tags': tags,
    };
  }

  ProductModel copyWith({
    String? name,
    String? description,
    double? price,
    Currency? currency,
    int? quantity,
    ProductUnit? unit,
    ProductSize? size,
    ProductCategory? category,
    List<String>? imageUrls,
    String? location,
    String? pincode,
    double? latitude,
    double? longitude,
    ProductStatus? status,
    int? views,
    List<String>? tags,
  }) {
    return ProductModel(
      id: id,
      sellerId: sellerId,
      sellerName: sellerName,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      size: size ?? this.size,
      category: category ?? this.category,
      imageUrls: imageUrls ?? this.imageUrls,
      location: location ?? this.location,
      pincode: pincode ?? this.pincode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      views: views ?? this.views,
      tags: tags ?? this.tags,
    );
  }

  // Helper methods
  String get formattedPrice {
    switch (currency) {
      case Currency.inr:
        return '₹${price.toStringAsFixed(2)}';
      case Currency.usd:
        return '\$${price.toStringAsFixed(2)}';
      case Currency.aud:
        return 'A\$${price.toStringAsFixed(2)}';
    }
  }

  String get formattedQuantity {
    return '$quantity ${unit.displayName}';
  }

  String get sizeDisplayName {
    switch (size) {
      case ProductSize.small:
        return 'Small';
      case ProductSize.medium:
        return 'Medium';
      case ProductSize.large:
        return 'Large';
      case ProductSize.allSizes:
        return 'All Sizes';
    }
  }

  String get categoryDisplayName {
    switch (category) {
      case ProductCategory.vegetables:
        return 'Vegetables';
      case ProductCategory.fruits:
        return 'Fruits';
      case ProductCategory.grains:
        return 'Grains';
      case ProductCategory.dairy:
        return 'Dairy';
      case ProductCategory.spices:
        return 'Spices';
      case ProductCategory.pulses:
        return 'Pulses';
      case ProductCategory.seeds:
        return 'Seeds';
      case ProductCategory.tools:
        return 'Tools';
      case ProductCategory.fertilizers:
        return 'Fertilizers';
      case ProductCategory.other:
        return 'Other';
    }
  }

  bool get isAvailable => status == ProductStatus.active && quantity > 0;
}

enum Currency { inr, usd, aud }

enum ProductUnit {
  kg,
  grams,
  liters,
  meters,
  boxes,
  packets,
  pieces,
  bundles,
  dozens
}

extension ProductUnitExtension on ProductUnit {
  String get displayName {
    switch (this) {
      case ProductUnit.kg:
        return 'KG';
      case ProductUnit.grams:
        return 'Grams';
      case ProductUnit.liters:
        return 'Liters';
      case ProductUnit.meters:
        return 'Meters';
      case ProductUnit.boxes:
        return 'Boxes';
      case ProductUnit.packets:
        return 'Packets';
      case ProductUnit.pieces:
        return 'Pieces';
      case ProductUnit.bundles:
        return 'Bundles';
      case ProductUnit.dozens:
        return 'Dozens';
    }
  }

  String get shortName {
    switch (this) {
      case ProductUnit.kg:
        return 'kg';
      case ProductUnit.grams:
        return 'g';
      case ProductUnit.liters:
        return 'L';
      case ProductUnit.meters:
        return 'm';
      case ProductUnit.boxes:
        return 'box';
      case ProductUnit.packets:
        return 'pkt';
      case ProductUnit.pieces:
        return 'pcs';
      case ProductUnit.bundles:
        return 'bundle';
      case ProductUnit.dozens:
        return 'dozen';
    }
  }
}

enum ProductSize { small, medium, large, allSizes }

enum ProductCategory {
  vegetables,
  fruits,
  grains,
  dairy,
  spices,
  pulses,
  seeds,
  tools,
  fertilizers,
  other
}

enum ProductStatus { active, inactive, soldOut, pending }