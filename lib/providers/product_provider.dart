import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();

  // Products lists
  List<ProductModel> _allProducts = [];
  List<ProductModel> _sellerProducts = [];
  List<ProductModel> _searchResults = [];
  List<ProductModel> _filteredProducts = [];

  // Selected product
  ProductModel? _selectedProduct;

  // Loading states
  bool _isLoading = false;
  bool _isSearching = false;
  bool _isCreating = false;
  bool _isUpdating = false;

  // Error handling
  String? _error;

  // Search and filter states
  String _searchQuery = '';
  ProductCategory? _selectedCategory;
  ProductSize? _selectedSize;
  Currency? _selectedCurrency;
  double? _minPrice;
  double? _maxPrice;
  String? _selectedLocation;

  // Statistics
  Map<String, dynamic> _sellerStats = {};

  // Getters
  List<ProductModel> get allProducts => _allProducts;
  List<ProductModel> get sellerProducts => _sellerProducts;
  List<ProductModel> get searchResults => _searchResults;
  List<ProductModel> get filteredProducts => _filteredProducts;
  ProductModel? get selectedProduct => _selectedProduct;

  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  bool get isCreating => _isCreating;
  bool get isUpdating => _isUpdating;

  String? get error => _error;
  String get searchQuery => _searchQuery;
  ProductCategory? get selectedCategory => _selectedCategory;
  ProductSize? get selectedSize => _selectedSize;
  Currency? get selectedCurrency => _selectedCurrency;
  double? get minPrice => _minPrice;
  double? get maxPrice => _maxPrice;
  String? get selectedLocation => _selectedLocation;

  Map<String, dynamic> get sellerStats => _sellerStats;

  // Helper getters
  List<ProductModel> get activeProducts =>
      _allProducts.where((p) => p.status == ProductStatus.active).toList();

  List<ProductModel> get availableProducts =>
      _allProducts.where((p) => p.isAvailable).toList();

  // Set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error
  void setError(String? error) {
    _error = error;
    _isLoading = false;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Create Product
  Future<String?> createProduct(ProductModel product) async {
    _isCreating = true;
    _error = null;
    notifyListeners();

    try {
      String productId = await _productService.createProduct(product);

      // Add to local list
      ProductModel createdProduct = product.copyWith();
      _allProducts.insert(0, createdProduct);
      _sellerProducts.insert(0, createdProduct);

      _isCreating = false;
      notifyListeners();

      return productId;
    } catch (e) {
      _error = e.toString();
      _isCreating = false;
      notifyListeners();
      return null;
    }
  }

  // Load All Products
  Future<void> loadAllProducts({int limit = 20}) async {
    setLoading(true);

    try {
      _allProducts = await _productService.getAllActiveProducts(limit: limit);
      clearError();
    } catch (e) {
      setError(e.toString());
    }
  }

  // Load Seller Products
  Future<void> loadSellerProducts(String sellerId) async {
    setLoading(true);

    try {
      _sellerProducts = await _productService.getProductsBySeller(sellerId);
      clearError();
    } catch (e) {
      setError(e.toString());
    }
  }

  // Search Products
  Future<void> searchProducts(String query) async {
    _searchQuery = query;

    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isSearching = true;
    notifyListeners();

    try {
      _searchResults = await _productService.searchProducts(query);
      _isSearching = false;
      clearError();
    } catch (e) {
      _error = e.toString();
      _isSearching = false;
      notifyListeners();
    }
  }

  // Filter Products
  Future<void> filterProducts() async {
    setLoading(true);

    try {
      _filteredProducts = await _productService.filterProducts(
        category: _selectedCategory,
        size: _selectedSize,
        currency: _selectedCurrency,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
        location: _selectedLocation,
      );
      clearError();
    } catch (e) {
      setError(e.toString());
    }
  }

  // Update Filters
  void updateCategory(ProductCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void updateSize(ProductSize? size) {
    _selectedSize = size;
    notifyListeners();
  }

  void updateCurrency(Currency? currency) {
    _selectedCurrency = currency;
    notifyListeners();
  }

  void updatePriceRange(double? minPrice, double? maxPrice) {
    _minPrice = minPrice;
    _maxPrice = maxPrice;
    notifyListeners();
  }

  void updateLocation(String? location) {
    _selectedLocation = location;
    notifyListeners();
  }

  void clearFilters() {
    _selectedCategory = null;
    _selectedSize = null;
    _selectedCurrency = null;
    _minPrice = null;
    _maxPrice = null;
    _selectedLocation = null;
    _filteredProducts = [];
    notifyListeners();
  }

  // Load Products by Category
  Future<void> loadProductsByCategory(ProductCategory category) async {
    setLoading(true);

    try {
      _allProducts = await _productService.getProductsByCategory(category);
      clearError();
    } catch (e) {
      setError(e.toString());
    }
  }

  // Get Product by ID
  Future<void> getProductById(String productId) async {
    setLoading(true);

    try {
      _selectedProduct = await _productService.getProductById(productId);

      // Increment views
      if (_selectedProduct != null) {
        await _productService.incrementProductViews(productId);
      }

      clearError();
    } catch (e) {
      setError(e.toString());
    }
  }

  // Update Product
  Future<bool> updateProduct(ProductModel product) async {
    _isUpdating = true;
    _error = null;
    notifyListeners();

    try {
      await _productService.updateProduct(product);

      // Update local lists
      int allIndex = _allProducts.indexWhere((p) => p.id == product.id);
      if (allIndex != -1) {
        _allProducts[allIndex] = product;
      }

      int sellerIndex = _sellerProducts.indexWhere((p) => p.id == product.id);
      if (sellerIndex != -1) {
        _sellerProducts[sellerIndex] = product;
      }

      if (_selectedProduct?.id == product.id) {
        _selectedProduct = product;
      }

      _isUpdating = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isUpdating = false;
      notifyListeners();
      return false;
    }
  }

  // Delete Product
  Future<bool> deleteProduct(String productId) async {
    setLoading(true);

    try {
      await _productService.deleteProduct(productId);

      // Remove from local lists
      _allProducts.removeWhere((p) => p.id == productId);
      _sellerProducts.removeWhere((p) => p.id == productId);
      _searchResults.removeWhere((p) => p.id == productId);
      _filteredProducts.removeWhere((p) => p.id == productId);

      if (_selectedProduct?.id == productId) {
        _selectedProduct = null;
      }

      clearError();
      return true;
    } catch (e) {
      setError(e.toString());
      return false;
    }
  }

  // Update Product Status
  Future<bool> updateProductStatus(String productId, ProductStatus status) async {
    try {
      await _productService.updateProductStatus(productId, status);

      // Update local product
      ProductModel? product = _allProducts.firstWhere(
            (p) => p.id == productId,
        orElse: () => _sellerProducts.firstWhere((p) => p.id == productId),
      );

      if (product != null) {
        ProductModel updatedProduct = product.copyWith(status: status);
        await updateProduct(updatedProduct);
      }

      return true;
    } catch (e) {
      setError(e.toString());
      return false;
    }
  }

  // Update Product Quantity
  Future<bool> updateProductQuantity(String productId, int newQuantity) async {
    try {
      await _productService.updateProductQuantity(productId, newQuantity);

      // Update local product
      ProductModel? product = _allProducts.firstWhere(
            (p) => p.id == productId,
        orElse: () => _sellerProducts.firstWhere((p) => p.id == productId),
      );

      if (product != null) {
        ProductStatus newStatus = newQuantity <= 0 ? ProductStatus.soldOut : product.status;
        ProductModel updatedProduct = product.copyWith(
          quantity: newQuantity,
          status: newStatus,
        );
        await updateProduct(updatedProduct);
      }

      return true;
    } catch (e) {
      setError(e.toString());
      return false;
    }
  }

  // Load Seller Statistics
  Future<void> loadSellerStats(String sellerId) async {
    try {
      _sellerStats = await _productService.getSellerProductStats(sellerId);
      notifyListeners();
    } catch (e) {
      setError(e.toString());
    }
  }

  // Clear search results
  void clearSearchResults() {
    _searchResults = [];
    _searchQuery = '';
    notifyListeners();
  }

  // Clear selected product
  void clearSelectedProduct() {
    _selectedProduct = null;
    notifyListeners();
  }

  // Refresh all data
  Future<void> refreshAll() async {
    await loadAllProducts();
  }

  // Get products by specific criteria
  List<ProductModel> getProductsByPrice({double? min, double? max}) {
    return _allProducts.where((product) {
      if (min != null && product.price < min) return false;
      if (max != null && product.price > max) return false;
      return true;
    }).toList();
  }

  List<ProductModel> getProductsByLocation(String location) {
    return _allProducts.where((product) =>
    product.pincode == location ||
        (product.location?.toLowerCase().contains(location.toLowerCase()) ?? false)
    ).toList();
  }

  List<ProductModel> getRecentProducts({int limit = 10}) {
    List<ProductModel> sorted = List.from(_allProducts);
    sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.take(limit).toList();
  }

  List<ProductModel> getPopularProducts({int limit = 10}) {
    List<ProductModel> sorted = List.from(_allProducts);
    sorted.sort((a, b) => b.views.compareTo(a.views));
    return sorted.take(limit).toList();
  }
}