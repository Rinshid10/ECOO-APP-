import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../../core/constants/app_colors.dart';

/// Product repository providing sample data
/// In a real app, this would fetch from an API
class ProductRepository {
  ProductRepository._(); // Private constructor

  /// Sample categories with network images
  static List<Category> get categories => [
        Category(
          id: 'cat_1',
          name: 'Dresses',
          imageUrl: 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=400',
          icon: Iconsax.woman,
          color: AppColors.categoryDress,
          productCount: 156,
          subCategories: ['Casual', 'Formal', 'Party', 'Maxi', 'Mini'],
        ),
        Category(
          id: 'cat_2',
          name: 'Electronics',
          imageUrl: 'https://images.unsplash.com/photo-1498049794561-7780e7231661?w=400',
          icon: Iconsax.cpu,
          color: AppColors.categoryElectronics,
          productCount: 243,
          subCategories: ['Laptops', 'Tablets', 'Cameras', 'Headphones', 'Speakers'],
        ),
        Category(
          id: 'cat_3',
          name: 'Phones',
          imageUrl: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400',
          icon: Iconsax.mobile,
          color: AppColors.categoryPhones,
          productCount: 89,
          subCategories: ['Smartphones', 'Cases', 'Chargers', 'Screen Protectors'],
        ),
        Category(
          id: 'cat_4',
          name: 'Shoes',
          imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
          icon: Iconsax.activity,
          color: AppColors.categoryShoes,
          productCount: 178,
          subCategories: ['Sneakers', 'Boots', 'Heels', 'Sandals', 'Sports'],
        ),
        Category(
          id: 'cat_5',
          name: 'Room Items',
          imageUrl: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=400',
          icon: Iconsax.home,
          color: AppColors.categoryFurniture,
          productCount: 134,
          subCategories: ['Furniture', 'Decor', 'Lighting', 'Bedding', 'Storage'],
        ),
        Category(
          id: 'cat_6',
          name: 'Fabrication',
          imageUrl: 'https://images.unsplash.com/photo-1558171813-4c088753af8f?w=400',
          icon: Iconsax.scissor,
          color: AppColors.categoryFabrication,
          productCount: 92,
          subCategories: ['Cotton', 'Silk', 'Linen', 'Wool', 'Synthetic'],
        ),
        Category(
          id: 'cat_7',
          name: 'Watches',
          imageUrl: 'https://images.unsplash.com/photo-1524592094714-0f0654e20314?w=400',
          icon: Iconsax.watch,
          color: const Color(0xFF9B59B6),
          productCount: 67,
          subCategories: ['Smart Watch', 'Analog', 'Digital', 'Luxury'],
        ),
        Category(
          id: 'cat_8',
          name: 'Bags',
          imageUrl: 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=400',
          icon: Iconsax.bag_2,
          color: const Color(0xFFE67E22),
          productCount: 145,
          subCategories: ['Backpacks', 'Handbags', 'Tote', 'Clutch', 'Travel'],
        ),
        Category(
          id: 'cat_9',
          name: 'Beauty',
          imageUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=400',
          icon: Iconsax.brush_2,
          color: const Color(0xFFFF69B4),
          productCount: 203,
          subCategories: ['Makeup', 'Skincare', 'Haircare', 'Fragrance'],
        ),
        Category(
          id: 'cat_10',
          name: 'Sports',
          imageUrl: 'https://images.unsplash.com/photo-1461896836934- voices?w=400',
          icon: Iconsax.weight,
          color: const Color(0xFF27AE60),
          productCount: 167,
          subCategories: ['Fitness', 'Outdoor', 'Team Sports', 'Yoga'],
        ),
        Category(
          id: 'cat_11',
          name: 'Jewelry',
          imageUrl: 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=400',
          icon: Iconsax.diamonds,
          color: const Color(0xFFFFD700),
          productCount: 89,
          subCategories: ['Necklaces', 'Rings', 'Earrings', 'Bracelets'],
        ),
        Category(
          id: 'cat_12',
          name: 'Books',
          imageUrl: 'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=400',
          icon: Iconsax.book_1,
          color: const Color(0xFF8B4513),
          productCount: 312,
          subCategories: ['Fiction', 'Non-Fiction', 'Educational', 'Children'],
        ),
      ];

  /// Sample products with network images
  static List<Product> get products => [
        // Dresses
        Product(
          id: 'prod_1',
          name: 'Elegant Evening Dress',
          description: 'A stunning evening dress perfect for special occasions. Made with premium fabric that ensures comfort and elegance. Features a flattering silhouette and intricate detailing.',
          price: 89.99,
          originalPrice: 129.99,
          imageUrl: 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=500',
          images: [
            'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=500',
            'https://images.unsplash.com/photo-1566174053879-31528523f8ae?w=500',
            'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=500',
          ],
          category: 'Dresses',
          brand: 'Elegance',
          rating: 4.8,
          reviewCount: 234,
          isInStock: true,
          stockQuantity: 45,
          sizes: ['XS', 'S', 'M', 'L', 'XL'],
          colors: ['Black', 'Red', 'Navy'],
          isFeatured: true,
          isBestSeller: true,
          specifications: {
            'Material': '95% Polyester, 5% Spandex',
            'Care': 'Dry clean only',
            'Length': 'Midi',
          },
        ),
        Product(
          id: 'prod_2',
          name: 'Casual Summer Dress',
          description: 'Light and breezy summer dress ideal for casual outings. Features a comfortable fit and vibrant colors that are perfect for sunny days.',
          price: 45.99,
          originalPrice: 59.99,
          imageUrl: 'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=500',
          images: [
            'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=500',
            'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=500',
          ],
          category: 'Dresses',
          brand: 'SummerVibes',
          rating: 4.5,
          reviewCount: 156,
          isInStock: true,
          stockQuantity: 78,
          sizes: ['S', 'M', 'L', 'XL'],
          colors: ['White', 'Yellow', 'Pink'],
          isNewArrival: true,
        ),

        // Electronics
        Product(
          id: 'prod_3',
          name: 'Wireless Bluetooth Headphones',
          description: 'Premium wireless headphones with active noise cancellation. Experience crystal-clear audio with up to 30 hours of battery life.',
          price: 199.99,
          originalPrice: 249.99,
          imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500',
          images: [
            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500',
            'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=500',
          ],
          category: 'Electronics',
          brand: 'SoundMax',
          rating: 4.7,
          reviewCount: 892,
          isInStock: true,
          stockQuantity: 156,
          colors: ['Black', 'White', 'Silver'],
          isFeatured: true,
          isBestSeller: true,
          specifications: {
            'Battery Life': '30 hours',
            'Connectivity': 'Bluetooth 5.0',
            'Driver Size': '40mm',
            'Weight': '250g',
          },
        ),
        Product(
          id: 'prod_4',
          name: '4K Smart TV 55"',
          description: 'Immersive 55-inch 4K UHD Smart TV with HDR support. Features built-in streaming apps and voice control for a seamless entertainment experience.',
          price: 599.99,
          originalPrice: 799.99,
          imageUrl: 'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?w=500',
          images: [
            'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?w=500',
            'https://images.unsplash.com/photo-1461151304267-38535e780c79?w=500',
          ],
          category: 'Electronics',
          brand: 'VisionPro',
          rating: 4.6,
          reviewCount: 445,
          isInStock: true,
          stockQuantity: 34,
          isFeatured: true,
          specifications: {
            'Resolution': '3840 x 2160',
            'Refresh Rate': '120Hz',
            'HDR': 'HDR10+, Dolby Vision',
            'Smart TV': 'Yes',
          },
        ),

        // Phones
        Product(
          id: 'prod_5',
          name: 'Pro Max Smartphone',
          description: 'Flagship smartphone with advanced camera system, powerful processor, and all-day battery life. Experience the future of mobile technology.',
          price: 999.99,
          originalPrice: 1099.99,
          imageUrl: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=500',
          images: [
            'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=500',
            'https://images.unsplash.com/photo-1592899677977-9c10ca588bbd?w=500',
          ],
          category: 'Phones',
          brand: 'TechPro',
          rating: 4.9,
          reviewCount: 2341,
          isInStock: true,
          stockQuantity: 89,
          colors: ['Midnight Black', 'Silver', 'Gold', 'Blue'],
          isFeatured: true,
          isBestSeller: true,
          isNewArrival: true,
          specifications: {
            'Display': '6.7" OLED',
            'Storage': '256GB',
            'Camera': '48MP Triple',
            'Battery': '5000mAh',
          },
        ),
        Product(
          id: 'prod_6',
          name: 'Budget Smartphone',
          description: 'Affordable smartphone with great features. Perfect for everyday use with a reliable camera and long-lasting battery.',
          price: 299.99,
          imageUrl: 'https://images.unsplash.com/photo-1598327105666-5b89351aff97?w=500',
          images: [
            'https://images.unsplash.com/photo-1598327105666-5b89351aff97?w=500',
          ],
          category: 'Phones',
          brand: 'ValueTech',
          rating: 4.3,
          reviewCount: 567,
          isInStock: true,
          stockQuantity: 234,
          colors: ['Black', 'Blue', 'Green'],
          isNewArrival: true,
        ),

        // Shoes
        Product(
          id: 'prod_7',
          name: 'Running Sneakers',
          description: 'Lightweight running shoes with responsive cushioning and breathable mesh upper. Designed for comfort during your daily runs.',
          price: 129.99,
          originalPrice: 159.99,
          imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500',
          images: [
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500',
            'https://images.unsplash.com/photo-1460353581641-37baddab0fa2?w=500',
          ],
          category: 'Shoes',
          brand: 'SpeedRun',
          rating: 4.6,
          reviewCount: 789,
          isInStock: true,
          stockQuantity: 167,
          sizes: ['7', '8', '9', '10', '11', '12'],
          colors: ['Red/Black', 'Blue/White', 'Black/Gray'],
          isFeatured: true,
          isBestSeller: true,
          specifications: {
            'Upper': 'Breathable Mesh',
            'Sole': 'Rubber',
            'Cushioning': 'Foam',
          },
        ),
        Product(
          id: 'prod_8',
          name: 'Classic Leather Boots',
          description: 'Timeless leather boots crafted with premium materials. Perfect for both casual and formal occasions.',
          price: 189.99,
          originalPrice: 229.99,
          imageUrl: 'https://images.unsplash.com/photo-1608256246200-53e635b5b65f?w=500',
          images: [
            'https://images.unsplash.com/photo-1608256246200-53e635b5b65f?w=500',
          ],
          category: 'Shoes',
          brand: 'Heritage',
          rating: 4.7,
          reviewCount: 234,
          isInStock: true,
          stockQuantity: 45,
          sizes: ['7', '8', '9', '10', '11'],
          colors: ['Brown', 'Black'],
        ),

        // Room Items / Furniture
        Product(
          id: 'prod_9',
          name: 'Modern Sofa Set',
          description: 'Elegant modern sofa with premium upholstery. Features comfortable cushioning and sleek design that complements any living space.',
          price: 899.99,
          originalPrice: 1199.99,
          imageUrl: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=500',
          images: [
            'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=500',
            'https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e?w=500',
          ],
          category: 'Room Items',
          brand: 'HomeLux',
          rating: 4.5,
          reviewCount: 123,
          isInStock: true,
          stockQuantity: 12,
          colors: ['Gray', 'Beige', 'Navy'],
          isFeatured: true,
          specifications: {
            'Material': 'Fabric',
            'Seating': '3-Seater',
            'Frame': 'Wood',
          },
        ),
        Product(
          id: 'prod_10',
          name: 'LED Desk Lamp',
          description: 'Adjustable LED desk lamp with multiple brightness levels and color temperatures. USB charging port included.',
          price: 49.99,
          imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500',
          images: [
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500',
          ],
          category: 'Room Items',
          brand: 'BrightLife',
          rating: 4.4,
          reviewCount: 456,
          isInStock: true,
          stockQuantity: 234,
          colors: ['White', 'Black'],
          isNewArrival: true,
        ),

        // Fabrication
        Product(
          id: 'prod_11',
          name: 'Premium Cotton Fabric',
          description: 'High-quality cotton fabric perfect for clothing and home projects. Soft, breathable, and easy to work with.',
          price: 12.99,
          imageUrl: 'https://images.unsplash.com/photo-1558171813-4c088753af8f?w=500',
          images: [
            'https://images.unsplash.com/photo-1558171813-4c088753af8f?w=500',
          ],
          category: 'Fabrication',
          brand: 'FabricWorld',
          rating: 4.6,
          reviewCount: 89,
          isInStock: true,
          stockQuantity: 567,
          colors: ['White', 'Blue', 'Pink', 'Gray'],
        ),
        Product(
          id: 'prod_12',
          name: 'Silk Blend Fabric',
          description: 'Luxurious silk blend fabric with beautiful drape and sheen. Ideal for elegant garments and special occasions.',
          price: 29.99,
          originalPrice: 39.99,
          imageUrl: 'https://images.unsplash.com/photo-1528459801416-a9e53bbf4e17?w=500',
          images: [
            'https://images.unsplash.com/photo-1528459801416-a9e53bbf4e17?w=500',
          ],
          category: 'Fabrication',
          brand: 'SilkTouch',
          rating: 4.8,
          reviewCount: 67,
          isInStock: true,
          stockQuantity: 123,
          colors: ['Champagne', 'Rose', 'Ivory'],
          isFeatured: true,
        ),

        // Watches
        Product(
          id: 'prod_13',
          name: 'Smart Watch Pro',
          description: 'Advanced smartwatch with health monitoring, GPS, and customizable watch faces. Stay connected on the go.',
          price: 349.99,
          originalPrice: 399.99,
          imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500',
          images: [
            'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500',
            'https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=500',
          ],
          category: 'Watches',
          brand: 'TechTime',
          rating: 4.7,
          reviewCount: 892,
          isInStock: true,
          stockQuantity: 78,
          colors: ['Black', 'Silver', 'Rose Gold'],
          isFeatured: true,
          isBestSeller: true,
          specifications: {
            'Display': 'AMOLED',
            'Battery': '7 days',
            'Water Resistance': '50m',
          },
        ),

        // Bags
        Product(
          id: 'prod_14',
          name: 'Leather Backpack',
          description: 'Stylish leather backpack with laptop compartment and multiple pockets. Perfect for work or travel.',
          price: 159.99,
          originalPrice: 199.99,
          imageUrl: 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=500',
          images: [
            'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=500',
          ],
          category: 'Bags',
          brand: 'UrbanCarry',
          rating: 4.5,
          reviewCount: 345,
          isInStock: true,
          stockQuantity: 89,
          colors: ['Brown', 'Black', 'Tan'],
          isFeatured: true,
        ),

        // Beauty
        Product(
          id: 'prod_15',
          name: 'Skincare Set',
          description: 'Complete skincare routine set including cleanser, toner, serum, and moisturizer. For radiant, healthy skin.',
          price: 79.99,
          originalPrice: 99.99,
          imageUrl: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=500',
          images: [
            'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=500',
          ],
          category: 'Beauty',
          brand: 'GlowUp',
          rating: 4.6,
          reviewCount: 567,
          isInStock: true,
          stockQuantity: 234,
          isBestSeller: true,
          isNewArrival: true,
        ),

        // Sports
        Product(
          id: 'prod_16',
          name: 'Yoga Mat Premium',
          description: 'Non-slip yoga mat with extra cushioning for joint support. Includes carrying strap.',
          price: 39.99,
          imageUrl: 'https://images.unsplash.com/photo-1601925260368-ae2f83cf8b7f?w=500',
          images: [
            'https://images.unsplash.com/photo-1601925260368-ae2f83cf8b7f?w=500',
          ],
          category: 'Sports',
          brand: 'ZenFit',
          rating: 4.4,
          reviewCount: 234,
          isInStock: true,
          stockQuantity: 345,
          colors: ['Purple', 'Blue', 'Pink', 'Black'],
        ),

        // Jewelry
        Product(
          id: 'prod_17',
          name: 'Gold Pendant Necklace',
          description: 'Elegant gold-plated pendant necklace with delicate chain. A timeless piece for any occasion.',
          price: 59.99,
          originalPrice: 79.99,
          imageUrl: 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=500',
          images: [
            'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=500',
          ],
          category: 'Jewelry',
          brand: 'GoldCraft',
          rating: 4.7,
          reviewCount: 178,
          isInStock: true,
          stockQuantity: 67,
          isFeatured: true,
        ),

        // Books
        Product(
          id: 'prod_18',
          name: 'Bestseller Book Set',
          description: 'Collection of top bestselling novels from renowned authors. Perfect gift for book lovers.',
          price: 49.99,
          originalPrice: 69.99,
          imageUrl: 'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=500',
          images: [
            'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=500',
          ],
          category: 'Books',
          brand: 'BookWorld',
          rating: 4.8,
          reviewCount: 456,
          isInStock: true,
          stockQuantity: 567,
          isBestSeller: true,
        ),
      ];

  /// Get featured products
  static List<Product> get featuredProducts =>
      products.where((p) => p.isFeatured).toList();

  /// Get new arrival products
  static List<Product> get newArrivals =>
      products.where((p) => p.isNewArrival).toList();

  /// Get best seller products
  static List<Product> get bestSellers =>
      products.where((p) => p.isBestSeller).toList();

  /// Get products by category
  static List<Product> getProductsByCategory(String category) =>
      products.where((p) => p.category == category).toList();

  /// Search products
  static List<Product> searchProducts(String query) {
    final lowerQuery = query.toLowerCase();
    return products.where((p) =>
        p.name.toLowerCase().contains(lowerQuery) ||
        p.description.toLowerCase().contains(lowerQuery) ||
        p.brand.toLowerCase().contains(lowerQuery) ||
        p.category.toLowerCase().contains(lowerQuery)).toList();
  }

  /// Get product by ID
  static Product? getProductById(String id) {
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}
