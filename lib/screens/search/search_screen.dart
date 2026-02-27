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

/// Search screen - responsive layout
class SearchScreen extends StatefulWidget {
  final String? initialQuery;

  const SearchScreen({
    super.key,
    this.initialQuery,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<Product> _searchResults = [];
  bool _isSearching = false;

  final List<String> _recentSearches = [
    'Wireless Headphones',
    'Summer Dress',
    'Running Shoes',
    'Smart Watch',
  ];

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

    // If initial query is provided, perform search
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      _searchController.text = widget.initialQuery!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _performSearch(widget.initialQuery!);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: isDesktop
          ? null
          : AppBar(
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
      body: Column(
            children: [
              // Desktop search bar
              if (isDesktop)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Row(
                    children: [
                      TextButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Iconsax.arrow_left),
                        label: const Text('Back'),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: SearchField(
                          controller: _searchController,
                          focusNode: _focusNode,
                          autofocus: true,
                          hintText: AppStrings.searchProducts,
                          onChanged: _performSearch,
                          onSubmitted: (value) => _performSearch(value),
                        ),
                      ),
                      const SizedBox(width: 16),
                      if (_searchController.text.isNotEmpty)
                        TextButton(
                          onPressed: _clearSearch,
                          child: const Text('Clear'),
                        ),
                    ],
                  ),
                ),

              // Content
              Expanded(
                child: _isSearching
                    ? _buildSearchResults(context)
                    : _buildSearchSuggestions(context),
              ),
            ],
      ),
    );
  }

  Widget _buildSearchSuggestions(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(Responsive.horizontalPadding(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_recentSearches.isNotEmpty) ...[
            _buildSectionHeader(context, AppStrings.recentSearches,
                onClear: () {
              setState(() {
                _recentSearches.clear();
              });
            }),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _recentSearches.map((search) {
                return _buildSearchChip(context, search,
                    icon: Iconsax.clock,
                    onTap: () => _setSearchText(search),
                    onDelete: () {
                  setState(() {
                    _recentSearches.remove(search);
                  });
                });
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],
          _buildSectionHeader(context, AppStrings.popularSearches),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _popularSearches.map((search) {
              return _buildSearchChip(context, search,
                  icon: Iconsax.trend_up,
                  onTap: () => _setSearchText(search));
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title,
      {VoidCallback? onClear}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold)),
        if (onClear != null)
          TextButton(
            onPressed: onClear,
            child: Text(AppStrings.clearAll,
                style: TextStyle(color: AppColors.primary)),
          ),
      ],
    );
  }

  Widget _buildSearchChip(BuildContext context, String label,
      {IconData? icon, required VoidCallback onTap, VoidCallback? onDelete}) {
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
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            if (onDelete != null) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onDelete,
                child: const Icon(Icons.close, size: 16,
                    color: AppColors.textLight),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    if (_searchResults.isEmpty) {
      return _buildNoResults(context);
    }

    final columns = Responsive.productGridColumns(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(Responsive.horizontalPadding(context)),
          child: Text('${_searchResults.length} results found',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary)),
        ),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.symmetric(
                horizontal: Responsive.horizontalPadding(context)),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: Responsive.isDesktop(context) ? 0.62 : 0.65,
            ),
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final product = _searchResults[index];
              return ProductCard(
                product: product,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailScreen(product: product)));
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNoResults(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100, height: 100,
            decoration: BoxDecoration(
              color: AppColors.grey100, shape: BoxShape.circle,
            ),
            child: const Icon(Iconsax.search_normal, size: 50,
                color: AppColors.grey400),
          ),
          const SizedBox(height: 24),
          Text(AppStrings.noResults,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Try a different search term',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textLight)),
        ],
      ),
    );
  }

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

  void _setSearchText(String text) {
    _searchController.text = text;
    _performSearch(text);
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      _searchResults = [];
    });
    _focusNode.requestFocus();
  }
}
