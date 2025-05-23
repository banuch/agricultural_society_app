import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'products';

  // Create Product
  Future<String> createProduct(ProductModel product) async {
    try {
      DocumentReference docRef = await _firestore.collection(_collection).add(product.toMap());

      // Update the product with the generated ID
      await docRef.update({'id': docRef.id});

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create product: ${e.toString()}');
    }
  }

  // Get Product by ID
  Future<ProductModel?> getProductById(String productId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(_collection).doc(productId).get();
      if (doc.exists) {
        return ProductModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch product: ${e.toString()}');
    }
  }

  // Update Product
  Future<void> updateProduct(ProductModel product) async {
    try {
      await _firestore.collection(_collection).doc(product.id).update(product.toMap());
    } catch (e) {
      throw Exception('Failed to update product: ${e.toString()}');
    }
  }

  // Delete Product
  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection(_collection).doc(productId).delete();
    } catch (e) {
      throw Exception('Failed to delete product: ${e.toString()}');
    }
  }

  // Get Products by Seller
  Future<List<ProductModel>> getProductsBySeller(String sellerId) async {
    try {
      QuerySnapshot query = await _firestore
          .collection(_collection)
          .where('sellerId', isEqualTo: sellerId)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs
          .map((doc) => ProductModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch seller products: ${e.toString()}');
    }
  }

  // Get All Active Products
  Future<List<ProductModel>> getAllActiveProducts({int limit = 20}) async {
    try {
      QuerySnapshot query = await _firestore
          .collection(_collection)
          .where('status', isEqualTo: 'active')
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return query.docs
          .map((doc) => ProductModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch products: ${e.toString()}');
    }
  }

  // Search Products
  Future<List<ProductModel>> searchProducts(String searchTerm) async {
    try {
      // Search by name (case insensitive)
      QuerySnapshot nameQuery = await _firestore
          .collection(_collection)
          .where('status', isEqualTo: 'active')
          .orderBy('name')
          .startAt([searchTerm.toLowerCase()])
          .endAt([searchTerm.toLowerCase() + '\uf8ff'])
          .get();

      // Search by tags
      QuerySnapshot tagQuery = await _firestore
          .collection(_collection)
          .where('status', isEqualTo: 'active')
          .where('tags', arrayContains: searchTerm.toLowerCase())
          .get();

      // Combine results and remove duplicates
      Set<String> seenIds = {};
      List<ProductModel> results = [];

      for (var doc in nameQuery.docs) {
        if (!seenIds.contains(doc.id)) {
          results.add(ProductModel.fromMap(doc.data() as Map<String, dynamic>));
          seenIds.add(doc.id);
        }
      }

      for (var doc in tagQuery.docs) {
        if (!seenIds.contains(doc.id)) {
          results.add(ProductModel.fromMap(doc.data() as Map<String, dynamic>));
          seenIds.add(doc.id);
        }
      }

      return results;
    } catch (e) {
      throw Exception('Failed to search products: ${e.toString()}');
    }
  }

  // Get Products by Category
  Future<List<ProductModel>> getProductsByCategory(ProductCategory category, {int limit = 20}) async {
    try {
      QuerySnapshot query = await _firestore
          .collection(_collection)
          .where('status', isEqualTo: 'active')
          .where('category', isEqualTo: category.toString().split('.').last)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return query.docs
          .map((doc) => ProductModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch products by category: ${e.toString()}');
    }
  }

  // Get Products by Location (Pincode)
  Future<List<ProductModel>> getProductsByLocation(String pincode, {int limit = 20}) async {
    try {
      QuerySnapshot query = await _firestore
          .collection(_collection)
          .where('status', isEqualTo: 'active')
          .where('pincode', isEqualTo: pincode)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return query.docs
          .map((doc) => ProductModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch products by location: ${e.toString()}');
    }
  }

  // Filter Products
  Future<List<ProductModel>> filterProducts({
    ProductCategory? category,
    ProductSize? size,
    Currency? currency,
    double? minPrice,
    double? maxPrice,
    String? location,
    int limit = 20,
  }) async {
    try {
      Query query = _firestore
          .collection(_collection)
          .where('status', isEqualTo: 'active');

      if (category != null) {
        query = query.where('category', isEqualTo: category.toString().split('.').last);
      }

      if (size != null) {
        query = query.where('size', isEqualTo: size.toString().split('.').last);
      }

      if (currency != null) {
        query = query.where('currency', isEqualTo: currency.toString().split('.').last);
      }

      if (location != null) {
        query = query.where('pincode', isEqualTo: location);
      }

      QuerySnapshot result = await query
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      List<ProductModel> products = result.docs
          .map((doc) => ProductModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      // Apply price filtering (done client-side since Firestore doesn't support range queries with other conditions)
      if (minPrice != null || maxPrice != null) {
        products = products.where((product) {
          if (minPrice != null && product.price < minPrice) return false;
          if (maxPrice != null && product.price > maxPrice) return false;
          return true;
        }).toList();
      }

      return products;
    } catch (e) {
      throw Exception('Failed to filter products: ${e.toString()}');
    }
  }

  // Increment Product Views
  Future<void> incrementProductViews(String productId) async {
    try {
      await _firestore.collection(_collection).doc(productId).update({
        'views': FieldValue.increment(1),
      });
    } catch (e) {
      throw Exception('Failed to increment views: ${e.toString()}');
    }
  }

  // Update Product Status
  Future<void> updateProductStatus(String productId, ProductStatus status) async {
    try {
      await _firestore.collection(_collection).doc(productId).update({
        'status': status.toString().split('.').last,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      throw Exception('Failed to update product status: ${e.toString()}');
    }
  }

  // Update Product Quantity
  Future<void> updateProductQuantity(String productId, int newQuantity) async {
    try {
      Map<String, dynamic> updates = {
        'quantity': newQuantity,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      };

      // If quantity is 0, mark as sold out
      if (newQuantity <= 0) {
        updates['status'] = ProductStatus.soldOut.toString().split('.').last;
      }

      await _firestore.collection(_collection).doc(productId).update(updates);
    } catch (e) {
      throw Exception('Failed to update product quantity: ${e.toString()}');
    }
  }

  // Get Product Statistics for Seller
  Future<Map<String, dynamic>> getSellerProductStats(String sellerId) async {
    try {
      QuerySnapshot allProducts = await _firestore
          .collection(_collection)
          .where('sellerId', isEqualTo: sellerId)
          .get();

      int totalProducts = allProducts.docs.length;
      int activeProducts = 0;
      int soldOutProducts = 0;
      int totalViews = 0;

      for (var doc in allProducts.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String status = data['status'] ?? 'active';
        int views = data['views'] ?? 0;

        totalViews += views;

        if (status == 'active') {
          activeProducts++;
        } else if (status == 'soldOut') {
          soldOutProducts++;
        }
      }

      return {
        'totalProducts': totalProducts,
        'activeProducts': activeProducts,
        'soldOutProducts': soldOutProducts,
        'totalViews': totalViews,
      };
    } catch (e) {
      throw Exception('Failed to fetch product statistics: ${e.toString()}');
    }
  }

  // Get Recent Products Stream (for real-time updates)
  Stream<List<ProductModel>> getRecentProductsStream({int limit = 10}) {
    return _firestore
        .collection(_collection)
        .where('status', isEqualTo: 'active')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ProductModel.fromMap(doc.data()))
        .toList());
  }

  // Get Seller Products Stream
  Stream<List<ProductModel>> getSellerProductsStream(String sellerId) {
    return _firestore
        .collection(_collection)
        .where('sellerId', isEqualTo: sellerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ProductModel.fromMap(doc.data()))
        .toList());
  }
}