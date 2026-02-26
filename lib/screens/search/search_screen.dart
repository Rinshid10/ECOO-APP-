import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';
import '../../widgets/common/search_field.dart';
import '../../widgets/product/product_card.dart';
import '../product_detail/product_detail_screen.dart';

/// Search screen for finding products
/// Features real-time search, recent searches, and popular suggestions
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<Product> _searchResults = [];
  bool _isSearching = false;

  // Recent searches (would be stored in local storage in production)
  final List<String> _recentSearches = [
    'Wireless Headphones',
    'Summer Dress',
    'Running Shoes',
    'Smart Watch',
  ];

  // Popular searches
  final List<String> _popularSearches = [
    'Electronics',
    'Fashion',
    'Home Decor',
    'Sports',
    'Beauty',
    'Phones',
  ];

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Iconsax.arrow_left),
        ),
        title: SearchField(
          controller: _searchController,
          focusNode: _focusNode,
          autofocus: true,
          hintText: AppStrings.searchProducts,
          onChanged: _performSearch,
          onSubmitted: (value) => _performSearch(value),
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              onPressed: _clearSearch,
              icon: const Icon(Iconsax.close_circle),
            ),
        ],
      ),
      body: _isSearching
          ? _buildSearchResults(context)
          : _buildSearchSuggestions(context),
    );
  }

  /// Build search suggestions (when not searching)
  Widget _buildSearchSuggestions(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent searches
          if (_recentSearches.isNotEmpty) ...[
            _buildSectionHeader(
              context,
              AppStrings.recentSearches,
              onClear: () {
                setState(() {
                  _recentSearches.clear();
                });
              },
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _recentSearches.map((search) {
                return _buildSearchChip(
                  context,
                  search,
                  icon: Iconsax.clock,
                  onTap: () => _setSearchText(search),
                  onDelete: () {
                    setState(() {
                      _recentSearches.remove(search);
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],

          // Popular searches
          _buildSectionHeader(context, AppStrings.popularSearches),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _popularSearches.map((search) {
              return _buildSearchChip(
                context,
                search,
                icon: Iconsax.trend_up,
                onTap: () => _setSearchText(search),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// Build section header
  Widget _buildSectionHeader(BuildContext context, String title,
      {VoidCallback? onClear}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        if (onClear != null)
          TextButton(
            onPressed: onClear,
            child: Text(
              AppStrings.clearAll,
              style: TextStyle(color: AppColors.primary),
            ),
          ),
      ],
    );
  }

  /// Build search chip
  Widget _buildSearchChip(
    BuildContext context,
    String label, {
    IconData? icon,
    required VoidCallback onTap,
    VoidCallback? onDelete,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.grey100,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: AppColors.textLight),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (onDelete != null) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onDelete,
                child: const Icon(
                  Icons.close,
                  size: 16,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Build search results
  Widget _buildSearchResults(BuildContext context) {
    if (_searchResults.isEmpty) {
      return _buildNoResults(context);
    }

    final columns = Responsive.gridColumns(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Results count
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            '${_searchResults.length} results found',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ),

        // Results grid
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.horizontalPadding(context),
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.65,
            ),
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final product = _searchResults[index];
              return ProductCard(
                product: product,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailScreen(product: product),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  /// Build no results state
  Widget _buildNoResults(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.grey100,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Iconsax.search_normal,
              size: 50,
              color: AppColors.grey400,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppStrings.noResults,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search term',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textLight,
                ),
          ),
        ],
      ),
    );
  }

  /// Perform search
  void _performSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _isSearching = false;
        _searchResults = [];
      } else {
        _isSearching = true;
        _searchResults = ProductRepository.searchProducts(query);
      }
    });
  }

  /// Set search text from suggestion
  void _setSearchText(String text) {
    _searchController.text = text;
    _performSearch(text);
  }

  /// Clear search
  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      _searchResults = [];
    });
    _focusNode.requestFocus();
  }
}
