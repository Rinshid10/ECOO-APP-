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
/// Responsive: shows grid on desktop, horizontal scroll on mobile
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBannerIndex = 0;
  late PageController _bannerPageController;
  Timer? _autoPlayTimer;

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
    _bannerPageController = PageController(viewportFraction: 0.92);
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
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header (hide on desktop - nav bar handles it)
            if (!isDesktop)
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
              child: _buildProductSection(
                context,
                title: AppStrings.featuredProducts,
                products: ProductRepository.featuredProducts,
              ),
            ),

            // New arrivals section
            SliverToBoxAdapter(
              child: _buildProductSection(
                context,
                title: AppStrings.newArrivals,
                products: ProductRepository.newArrivals,
              ),
            ),

            // Best sellers section
            SliverToBoxAdapter(
              child: _buildProductSection(
                context,
                title: AppStrings.bestSellers,
                products: ProductRepository.bestSellers,
              ),
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

  /// Build header with logo, search, and notification (mobile only)
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding(context),
        vertical: 16,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
    final isDesktop = Responsive.isDesktop(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 8.0 : 0,
      ),
      child: Column(
        children: [
          if (isDesktop) const SizedBox(height: 16),
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
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 8.0 : 8.0,
                  ),
                  child: _buildBannerItem(context, banner),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
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
      ),
    );
  }

  /// Build individual banner item
  Widget _buildBannerItem(BuildContext context, Map<String, String> banner) {
    final isDesktop = Responsive.isDesktop(context);

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
            Positioned(
              left: isDesktop ? 48 : 20,
              bottom: isDesktop ? 48 : 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    banner['title']!,
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontSize: isDesktop ? 36 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    banner['subtitle']!,
                    style: TextStyle(
                      color: AppColors.textWhite.withOpacity(0.9),
                      fontSize: isDesktop ? 20 : 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 28 : 20,
                      vertical: isDesktop ? 14 : 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.textWhite,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      'Shop Now',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: isDesktop ? 16 : 14,
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

  /// Build categories section
  Widget _buildCategoriesSection(BuildContext context) {
    final categories = ProductRepository.categories;
    final isDesktop = Responsive.isDesktop(context);
    final displayCategories = categories.length > 8
        ? categories.sublist(0, 8)
        : categories;

    return Column(
      children: [
        SectionHeader(
          title: AppStrings.topCategories,
          actionText: AppStrings.viewAll,
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.horizontalPadding(context),
            vertical: 8,
          ),
          onActionPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CategoryScreen()),
            );
          },
        ),
        if (isDesktop)
          // Desktop: show all categories in a wrap layout
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.horizontalPadding(context),
            ),
            child: Wrap(
              spacing: 28,
              runSpacing: 16,
              children: displayCategories.map((category) {
                return CategoryCard(
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
                );
              }).toList(),
            ),
          )
        else
          // Mobile: horizontal scroll
          SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.horizontalPadding(context),
              ),
              itemCount: displayCategories.length,
              itemBuilder: (context, index) {
                final category = displayCategories[index];
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

  /// Build product section - grid on desktop, horizontal scroll on mobile
  Widget _buildProductSection(
    BuildContext context, {
    required String title,
    required List<Product> products,
  }) {
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);

    return Column(
      children: [
        const SizedBox(height: 16),
        SectionHeader(
          title: title,
          actionText: AppStrings.viewAll,
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.horizontalPadding(context),
            vertical: 8,
          ),
          onActionPressed: () {},
        ),
        if (isDesktop || isTablet)
          // Grid layout for desktop/tablet
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.horizontalPadding(context),
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Responsive.productGridColumns(context),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: isDesktop ? 0.62 : 0.68,
              ),
              itemCount: products.length > (isDesktop ? 5 : 3)
                  ? (isDesktop ? 5 : 3)
                  : products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(
                  product: product,
                  onTap: () => _navigateToProductDetail(product),
                );
              },
            ),
          )
        else
          // Horizontal scroll for mobile
          SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.horizontalPadding(context),
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
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
