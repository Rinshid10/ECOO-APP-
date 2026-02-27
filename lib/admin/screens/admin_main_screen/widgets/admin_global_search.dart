import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/admin_colors.dart';

/// Global search bar with suggestions
class AdminGlobalSearch extends StatefulWidget {
  const AdminGlobalSearch({super.key});

  @override
  State<AdminGlobalSearch> createState() => _AdminGlobalSearchState();
}

class _AdminGlobalSearchState extends State<AdminGlobalSearch> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _isFocused = false;
  bool _showSuggestions = false;

  final List<Map<String, dynamic>> _recentSearches = [
    {'type': 'order', 'text': '#ORD-2024-001', 'icon': Iconsax.receipt_1},
    {'type': 'product', 'text': 'Wireless Earbuds', 'icon': Iconsax.box},
    {'type': 'customer', 'text': 'John Doe', 'icon': Iconsax.user},
  ];

  final List<Map<String, dynamic>> _quickLinks = [
    {'text': 'Add Product', 'icon': Iconsax.add_circle, 'color': AdminColors.primary},
    {'text': 'New Order', 'icon': Iconsax.shopping_cart, 'color': AdminColors.success},
    {'text': 'Reports', 'icon': Iconsax.chart_2, 'color': AdminColors.info},
  ];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
        _showSuggestions = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Search input
            Container(
              height: 44,
              decoration: BoxDecoration(
                color: _isFocused ? AdminColors.surface : AdminColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isFocused ? AdminColors.primary : AdminColors.border,
                  width: _isFocused ? 2 : 1,
                ),
                boxShadow: _isFocused
                    ? [
                        BoxShadow(
                          color: AdminColors.primary.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  const SizedBox(width: 14),
                  Icon(
                    Iconsax.search_normal,
                    color: _isFocused ? AdminColors.primary : AdminColors.textTertiary,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText: 'Search products, orders, customers...',
                        hintStyle: TextStyle(
                          color: AdminColors.textTertiary,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onChanged: (value) => setState(() {}),
                    ),
                  ),
                  // Keyboard shortcut hint
                  if (!_isFocused)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: AdminColors.background,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AdminColors.border),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.keyboard_command_key, size: 12, color: AdminColors.textTertiary),
                          const SizedBox(width: 2),
                          Text(
                            'K',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AdminColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Clear button
                  if (_controller.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _controller.clear();
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(
                          Iconsax.close_circle5,
                          size: 18,
                          color: AdminColors.textTertiary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Suggestions dropdown
            if (_showSuggestions)
              TapRegion(
                onTapOutside: (_) {
                  _focusNode.unfocus();
                  setState(() => _showSuggestions = false);
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AdminColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AdminColors.border),
                    boxShadow: AdminColors.elevatedShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Recent searches
                      if (_controller.text.isEmpty) ...[
                        _buildSectionHeader('Recent Searches', Iconsax.clock),
                        const SizedBox(height: 8),
                        ..._recentSearches.map((item) => _buildSearchItem(item)),
                        const SizedBox(height: 16),
                        _buildSectionHeader('Quick Links', Iconsax.flash_1),
                        const SizedBox(height: 8),
                        Row(
                          children: _quickLinks.map((item) => _buildQuickLink(item)).toList(),
                        ),
                      ] else ...[
                        // Search results
                        _buildSearchResults(),
                      ],
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AdminColors.textTertiary),
        const SizedBox(width: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AdminColors.textTertiary,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchItem(Map<String, dynamic> item) {
    return InkWell(
      onTap: () {
        _controller.text = item['text'];
        _focusNode.unfocus();
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AdminColors.surfaceVariant,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(item['icon'], size: 14, color: AdminColors.textSecondary),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                item['text'],
                style: TextStyle(
                  fontSize: 13,
                  color: AdminColors.textPrimary,
                ),
              ),
            ),
            Icon(Icons.north_west, size: 14, color: AdminColors.textTertiary),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickLink(Map<String, dynamic> item) {
    return Expanded(
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          _focusNode.unfocus();
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: (item['color'] as Color).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(item['icon'], size: 18, color: item['color']),
              const SizedBox(height: 4),
              Text(
                item['text'],
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: item['color'],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    final query = _controller.text.toLowerCase();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Results for "$query"', Iconsax.search_normal),
        const SizedBox(height: 8),
        _buildResultItem('Products', '3 matches', Iconsax.box, AdminColors.primary),
        _buildResultItem('Orders', '1 match', Iconsax.receipt_1, AdminColors.success),
        _buildResultItem('Customers', '2 matches', Iconsax.people, AdminColors.info),
      ],
    );
  }

  Widget _buildResultItem(String title, String count, IconData icon, Color color) {
    return InkWell(
      onTap: () => _focusNode.unfocus(),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    count,
                    style: TextStyle(
                      fontSize: 11,
                      color: AdminColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 18, color: AdminColors.textTertiary),
          ],
        ),
      ),
    );
  }
}
