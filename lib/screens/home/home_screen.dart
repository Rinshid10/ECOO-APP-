import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconsax/iconsax.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';
import '../../widgets/common/search_field.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/product/product_card.dart';
import '../../widgets/category/category_card.dart';
import '../search/search_screen.dart';
import '../category/category_screen.dart';
import '../category/category_products_screen.dart';
import '../product_detail/product_detail_screen.dart';
import '../notifications/notifications_screen.dart';

/// Home screen - Main landing page of the app
/// Displays banners, categories, featured products, and more
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBannerIndex = 0;
  late PageController _bannerPageController;
  Timer? _autoPlayTimer;

  // Banner data with network images
  final List<Map<String, String>> _banners = [
    {
      'image': 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=800',
      'title': 'Summer Sale',
      'subtitle': 'Up to 50% Off',
    },
    {
      'image': 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800',
      'title': 'New Collection',
      'subtitle': 'Shop Latest Trends',
    },
    {
      'image': 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800',
      'title': 'Flash Deals',
      'subtitle': 'Limited Time Only',
    },
  ];

  @override
  void initState() {
    super.initState();
    _bannerPageController = PageController(viewportFraction: 0.9);
    _startAutoPlay();
  }

  @override
  void dispose() {
    _bannerPageController.dispose();
    _autoPlayTimer?.cancel();
    super.dispose();
  }

  void _startAutoPlay() {
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_bannerPageController.hasClients) {
        if (_currentBannerIndex < _banners.length - 1) {
          _currentBannerIndex++;
        } else {
          _currentBannerIndex = 0;
        }
        _bannerPageController.animateToPage(
          _currentBannerIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App bar with search
            SliverToBoxAdapter(
              child: _buildHeader(context),
            ),

            // Banner carousel
            SliverToBoxAdapter(
              child: _buildBannerCarousel(context),
            ),

            // Categories section
            SliverToBoxAdapter(
              child: _buildCategoriesSection(context),
            ),

            // Featured products section
            SliverToBoxAdapter(
              child: _buildFeaturedSection(context),
            ),

            // New arrivals section
            SliverToBoxAdapter(
              child: _buildNewArrivalsSection(context),
            ),

            // Best sellers section
            SliverToBoxAdapter(
              child: _buildBestSellersSection(context),
            ),

            // Bottom padding
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }

  /// Build header with logo, search, and notification
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding(context),
        vertical: 16,
      ),
      child: Column(
        children: [
          // Logo and notification row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo and app name
              Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Iconsax.shop,
                      color: AppColors.textWhite,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.appName,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        AppStrings.appTagline,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textLight,
                            ),
                      ),
                    ],
                  ),
                ],
              ),

              // Notification button
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationsScreen(),
                    ),
                  );
                },
                icon: const Icon(Iconsax.notification),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Search bar
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
            child: const SearchField(
              readOnly: true,
              hintText: AppStrings.searchProducts,
            ),
          ),
        ],
      ),
    );
  }

  /// Build banner carousel slider
  Widget _buildBannerCarousel(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: Responsive.bannerHeight(context),
          child: PageView.builder(
            controller: _bannerPageController,
            onPageChanged: (index) {
              setState(() {
                _currentBannerIndex = index;
              });
            },
            itemCount: _banners.length,
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: _buildBannerItem(context, banner),
              );
            },
          ),
        ),
        const SizedBox(height: 16),

        // Page indicator
        AnimatedSmoothIndicator(
          activeIndex: _currentBannerIndex,
          count: _banners.length,
          effect: const ExpandingDotsEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: AppColors.primary,
            dotColor: AppColors.grey300,
          ),
        ),
      ],
    );
  }

  /// Build individual banner item
  Widget _buildBannerItem(BuildContext context, Map<String, String> banner) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            CachedNetworkImage(
              imageUrl: banner['image']!,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppColors.grey200,
              ),
              errorWidget: (context, url, error) => Container(
                color: AppColors.primary.withOpacity(0.2),
              ),
            ),

            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            // Banner text
            Positioned(
              left: 20,
              bottom: 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    banner['title']!,
                    style: const TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    banner['subtitle']!,
                    style: TextStyle(
                      color: AppColors.textWhite.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.textWhite,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Text(
                      'Shop Now',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build categories section with horizontal scroll
  Widget _buildCategoriesSection(BuildContext context) {
    final categories = ProductRepository.categories;

    return Column(
      children: [
        SectionHeader(
          title: AppStrings.topCategories,
          actionText: AppStrings.viewAll,
          onActionPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CategoryScreen()),
            );
          },
        ),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.horizontalPadding(context),
            ),
            itemCount: categories.length > 8 ? 8 : categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: CategoryCard(
                  category: category,
                  showProductCount: false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryProductsScreen(
                          category: category,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Build featured products section
  Widget _buildFeaturedSection(BuildContext context) {
    final featuredProducts = ProductRepository.featuredProducts;

    return Column(
      children: [
        const SizedBox(height: 16),
        SectionHeader(
          title: AppStrings.featuredProducts,
          actionText: AppStrings.viewAll,
          onActionPressed: () {
            // Navigate to all featured products
          },
        ),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.horizontalPadding(context),
            ),
            itemCount: featuredProducts.length,
            itemBuilder: (context, index) {
              final product = featuredProducts[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: SizedBox(
                  width: 180,
                  child: ProductCard(
                    product: product,
                    onTap: () => _navigateToProductDetail(product),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Build new arrivals section
  Widget _buildNewArrivalsSection(BuildContext context) {
    final newArrivals = ProductRepository.newArrivals;

    return Column(
      children: [
        const SizedBox(height: 16),
        SectionHeader(
          title: AppStrings.newArrivals,
          actionText: AppStrings.viewAll,
          onActionPressed: () {},
        ),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.horizontalPadding(context),
            ),
            itemCount: newArrivals.length,
            itemBuilder: (context, index) {
              final product = newArrivals[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: SizedBox(
                  width: 180,
                  child: ProductCard(
                    product: product,
                    onTap: () => _navigateToProductDetail(product),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Build best sellers section
  Widget _buildBestSellersSection(BuildContext context) {
    final bestSellers = ProductRepository.bestSellers;

    return Column(
      children: [
        const SizedBox(height: 16),
        SectionHeader(
          title: AppStrings.bestSellers,
          actionText: AppStrings.viewAll,
          onActionPressed: () {},
        ),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.horizontalPadding(context),
            ),
            itemCount: bestSellers.length,
            itemBuilder: (context, index) {
              final product = bestSellers[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: SizedBox(
                  width: 180,
                  child: ProductCard(
                    product: product,
                    onTap: () => _navigateToProductDetail(product),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Navigate to product detail screen
  void _navigateToProductDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }
}
