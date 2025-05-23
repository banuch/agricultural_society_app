import 'package:agricultural_society_app/utils/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';
import '../../providers/product_provider.dart';
import '../../providers/user_provider.dart';

import 'add_product_screen.dart';
import 'product_detail_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadInitialData();
  }

  void _loadInitialData() {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    productProvider.loadAllProducts();

    if (userProvider.user != null && userProvider.isSeller) {
      productProvider.loadSellerProducts(userProvider.user!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {

    final localizations = AppLocalizations.of(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(localizations.marketplace),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: userProvider.isSeller ? TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Browse Products'),
            Tab(text: 'My Products'),
          ],
        ) : null,
      ),
      body: userProvider.isSeller ? TabBarView(
        controller: _tabController,
        children: [
          _buildBrowseProductsTab(),
          _buildMyProductsTab(),
        ],
      ) : _buildBrowseProductsTab(),
      floatingActionButton: userProvider.isSeller ? FloatingActionButton(
        onPressed: () => _navigateToAddProduct(),
        backgroundColor: Colors.green.shade600,
        child: const Icon(Icons.add, color: Colors.white),
      ) : null,
    );
  }

  Widget _buildBrowseProductsTab() {
    return Column(
      children: [
        _buildSearchAndFilter(),
        Expanded(child: _buildProductsList()),
      ],
    );
  }

  Widget _buildMyProductsTab() {
    return Column(
      children: [
        _buildSellerStats(),
        Expanded(child: _buildSellerProductsList()),
      ],
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  context.read<ProductProvider>().clearSearchResults();
                },
              )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                context.read<ProductProvider>().searchProducts(value);
              } else {
                context.read<ProductProvider>().clearSearchResults();
              }
            },
          ),
          const SizedBox(height: 12),
          // Filter Chips
          _buildFilterChips(),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // Category Filter
              _buildFilterChip(
                'Category',
                productProvider.selectedCategory?.toString().split('.').last ?? 'All',
                    () => _showCategoryFilter(),
                productProvider.selectedCategory != null,
              ),
              const SizedBox(width: 8),
              // Size Filter
              _buildFilterChip(
                'Size',
                productProvider.selectedSize?.toString().split('.').last ?? 'All',
                    () => _showSizeFilter(),
                productProvider.selectedSize != null,
              ),
              const SizedBox(width: 8),
              // Currency Filter
              _buildFilterChip(
                'Currency',
                productProvider.selectedCurrency?.toString().split('.').last.toUpperCase() ?? 'All',
                    () => _showCurrencyFilter(),
                productProvider.selectedCurrency != null,
              ),
              const SizedBox(width: 8),
              // Clear Filters
              if (productProvider.selectedCategory != null ||
                  productProvider.selectedSize != null ||
                  productProvider.selectedCurrency != null)
                ActionChip(
                  label: const Text('Clear Filters'),
                  onPressed: () {
                    productProvider.clearFilters();
                  },
                  backgroundColor: Colors.red.shade100,
                  side: BorderSide(color: Colors.red.shade300),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String label, String value, VoidCallback onTap, bool isSelected) {
    return FilterChip(
      label: Text('$label: $value'),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: Colors.grey.shade100,
      selectedColor: Colors.green.shade100,
      side: BorderSide(
        color: isSelected ? Colors.green.shade400 : Colors.grey.shade300,
      ),
    );
  }

  Widget _buildProductsList() {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        if (productProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (productProvider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
                const SizedBox(height: 16),
                Text('Error: ${productProvider.error}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => productProvider.loadAllProducts(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        List<ProductModel> products = _searchController.text.isNotEmpty
            ? productProvider.searchResults
            : productProvider.allProducts;

        if (products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  _searchController.text.isNotEmpty
                      ? 'No products found for "${_searchController.text}"'
                      : 'No products available',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => productProvider.loadAllProducts(),
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return _buildProductCard(products[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildSellerStats() {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        final stats = productProvider.sellerStats;

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Total', '${stats['totalProducts'] ?? 0}', Icons.inventory),
              _buildStatItem('Active', '${stats['activeProducts'] ?? 0}', Icons.check_circle),
              _buildStatItem('Sold Out', '${stats['soldOutProducts'] ?? 0}', Icons.remove_circle),
              _buildStatItem('Views', '${stats['totalViews'] ?? 0}', Icons.visibility),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.green.shade600),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildSellerProductsList() {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        if (productProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (productProvider.sellerProducts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_business, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                const Text('No products added yet'),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _navigateToAddProduct(),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Your First Product'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: productProvider.sellerProducts.length,
          itemBuilder: (context, index) {
            return _buildSellerProductCard(productProvider.sellerProducts[index]);
          },
        );
      },
    );
  }

  Widget _buildProductCard(ProductModel product) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _navigateToProductDetail(product),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  color: Colors.grey.shade200,
                ),
                child: product.imageUrls.isNotEmpty
                    ? ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    product.imageUrls.first,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildPlaceholderImage(),
                  ),
                )
                    : _buildPlaceholderImage(),
              ),
            ),
            // Product Details
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.formattedPrice,
                      style: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.formattedQuantity,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 12, color: Colors.grey.shade500),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            product.location ?? 'Location not set',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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

  Widget _buildSellerProductCard(ProductModel product) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade200,
          ),
          child: product.imageUrls.isNotEmpty
              ? ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              product.imageUrls.first,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.image, color: Colors.grey.shade400),
            ),
          )
              : Icon(Icons.image, color: Colors.grey.shade400),
        ),
        title: Text(product.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.formattedPrice),
            Text('${product.quantity} ${product.unit.displayName}'),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: const Row(
                children: [Icon(Icons.edit), SizedBox(width: 8), Text('Edit')],
              ),
            ),
            PopupMenuItem(
              value: 'status',
              child: Row(
                children: [
                  Icon(product.status == ProductStatus.active
                      ? Icons.pause : Icons.play_arrow),
                  const SizedBox(width: 8),
                  Text(product.status == ProductStatus.active
                      ? 'Deactivate' : 'Activate'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: const Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) => _handleProductAction(value, product),
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Icon(
        Icons.image,
        size: 40,
        color: Colors.grey.shade400,
      ),
    );
  }

  void _handleProductAction(String action, ProductModel product) async {
    final productProvider = context.read<ProductProvider>();

    switch (action) {
      case 'edit':
        _navigateToEditProduct(product);
        break;
      case 'status':
        ProductStatus newStatus = product.status == ProductStatus.active
            ? ProductStatus.inactive
            : ProductStatus.active;
        await productProvider.updateProductStatus(product.id, newStatus);
        break;
      case 'delete':
        _showDeleteConfirmation(product);
        break;
    }
  }

  void _showDeleteConfirmation(ProductModel product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete "${product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ProductProvider>().deleteProduct(product.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showCategoryFilter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('All Categories'),
              onTap: () {
                context.read<ProductProvider>().updateCategory(null);
                Navigator.pop(context);
              },
            ),
            ...ProductCategory.values.map((category) => ListTile(
              title: Text(category.toString().split('.').last),
              onTap: () {
                context.read<ProductProvider>().updateCategory(category);
                Navigator.pop(context);
              },
            )),
          ],
        ),
      ),
    );
  }

  void _showSizeFilter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Size'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('All Sizes'),
              onTap: () {
                context.read<ProductProvider>().updateSize(null);
                Navigator.pop(context);
              },
            ),
            ...ProductSize.values.map((size) => ListTile(
              title: Text(size.toString().split('.').last),
              onTap: () {
                context.read<ProductProvider>().updateSize(size);
                Navigator.pop(context);
              },
            )),
          ],
        ),
      ),
    );
  }

  void _showCurrencyFilter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Currency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('All Currencies'),
              onTap: () {
                context.read<ProductProvider>().updateCurrency(null);
                Navigator.pop(context);
              },
            ),
            ...Currency.values.map((currency) => ListTile(
              title: Text(currency.toString().split('.').last.toUpperCase()),
              onTap: () {
                context.read<ProductProvider>().updateCurrency(currency);
                Navigator.pop(context);
              },
            )),
          ],
        ),
      ),
    );
  }

  void _navigateToAddProduct() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddProductScreen()),
    );

    if (result == true) {
      _loadInitialData();
    }
  }

  void _navigateToEditProduct(ProductModel product) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProductScreen(product: product),
      ),
    );

    if (result == true) {
      _loadInitialData();
    }
  }

  void _navigateToProductDetail(ProductModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}