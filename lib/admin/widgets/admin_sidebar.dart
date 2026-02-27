import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../core/admin_colors.dart';
import '../providers/admin_provider.dart';
import '../screens/admin_main_screen.dart';

/// Modern admin sidebar navigation widget
class AdminSidebar extends StatefulWidget {
  final List<AdminMenuItem> menuItems;
  final int selectedIndex;
  final bool isExpanded;
  final Function(int) onItemSelected;
  final VoidCallback onToggleExpanded;
  final bool isDrawer;

  const AdminSidebar({
    super.key,
    required this.menuItems,
    required this.selectedIndex,
    required this.isExpanded,
    required this.onItemSelected,
    required this.onToggleExpanded,
    this.isDrawer = false,
  });

  @override
  State<AdminSidebar> createState() => _AdminSidebarState();
}

class _AdminSidebarState extends State<AdminSidebar> {
  int? _hoveredIndex;

  bool get _showLabels => widget.isExpanded || widget.isDrawer;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: widget.isDrawer ? 280 : (widget.isExpanded ? 260 : 80),
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: AdminColors.darkGradient,
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Logo section
            _buildLogoSection(),

            // Divider
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: _showLabels ? 20 : 16,
                vertical: 8,
              ),
              child: Divider(
                color: AdminColors.sidebarBorder.withOpacity(0.5),
                height: 1,
              ),
            ),

            // Menu section label
            if (_showLabels)
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'MAIN MENU',
                    style: TextStyle(
                      color: AdminColors.textMuted.withOpacity(0.5),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),

            // Menu items
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: _showLabels ? 12 : 12,
                  vertical: 4,
                ),
                itemCount: widget.menuItems.length,
                itemBuilder: (context, index) {
                  // Add section divider before settings
                  if (index == widget.menuItems.length - 1) {
                    return Column(
                      children: [
                        if (_showLabels) ...[
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, bottom: 8),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'PREFERENCES',
                                style: TextStyle(
                                  color: AdminColors.textMuted.withOpacity(0.5),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ] else
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Divider(
                              color: AdminColors.sidebarBorder.withOpacity(0.5),
                              height: 1,
                            ),
                          ),
                        _buildMenuItem(context, index),
                      ],
                    );
                  }
                  return _buildMenuItem(context, index);
                },
              ),
            ),

            // User profile section
            _buildUserSection(),

            // Collapse button (not for drawer)
            if (!widget.isDrawer) _buildCollapseButton(),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  /// Build logo section
  Widget _buildLogoSection() {
    return Container(
      height: 72,
      padding: EdgeInsets.symmetric(horizontal: _showLabels ? 20 : 0),
      child: Row(
        mainAxisAlignment: _showLabels
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        children: [
          // Logo
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: AdminColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Iconsax.chart_square5,
              color: Colors.white,
              size: 24,
            ),
          ),
          if (_showLabels) ...[
            const SizedBox(width: 14),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ShopEase',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'Admin Panel',
                  style: TextStyle(
                    color: AdminColors.textMuted.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// Build menu item with modern hover effects
  Widget _buildMenuItem(BuildContext context, int index) {
    final item = widget.menuItems[index];
    final isSelected = widget.selectedIndex == index;
    final isHovered = _hoveredIndex == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hoveredIndex = index),
        onExit: (_) => setState(() => _hoveredIndex = null),
        child: GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            widget.onItemSelected(index);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            padding: EdgeInsets.symmetric(
              horizontal: _showLabels ? 14 : 0,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [
                        AdminColors.sidebarActive.withOpacity(0.2),
                        AdminColors.sidebarActive.withOpacity(0.05),
                      ],
                    )
                  : null,
              color: isHovered && !isSelected
                  ? AdminColors.sidebarHover.withOpacity(0.5)
                  : null,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(
                      color: AdminColors.sidebarActive.withOpacity(0.3),
                      width: 1,
                    )
                  : null,
            ),
            child: Row(
              mainAxisAlignment: _showLabels
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                // Active indicator
                if (isSelected && _showLabels) ...[
                  Container(
                    width: 3,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AdminColors.sidebarActive,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],

                // Icon with animation
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: _showLabels
                      ? EdgeInsets.zero
                      : EdgeInsets.all(isSelected ? 8 : 0),
                  decoration: !_showLabels && isSelected
                      ? BoxDecoration(
                          color: AdminColors.sidebarActive.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        )
                      : null,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        isSelected ? item.activeIcon : item.icon,
                        color: isSelected
                            ? AdminColors.sidebarActive
                            : isHovered
                                ? Colors.white
                                : AdminColors.textMuted,
                        size: 22,
                      ),
                      // Badge for collapsed mode
                      if (item.badge != null && !_showLabels)
                        Positioned(
                          top: -6,
                          right: -6,
                          child: _buildBadge(item.badge!, small: true),
                        ),
                    ],
                  ),
                ),

                // Title and badge
                if (_showLabels) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.title,
                      style: TextStyle(
                        color: isSelected
                            ? AdminColors.sidebarActive
                            : isHovered
                                ? Colors.white
                                : AdminColors.textMuted,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  if (item.badge != null) _buildBadge(item.badge!),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build badge
  Widget _buildBadge(String badge, {bool small = false}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 5 : 8,
        vertical: small ? 2 : 4,
      ),
      decoration: BoxDecoration(
        gradient: AdminColors.errorGradient,
        borderRadius: BorderRadius.circular(small ? 8 : 10),
        boxShadow: [
          BoxShadow(
            color: AdminColors.error.withOpacity(0.4),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        badge,
        style: TextStyle(
          color: Colors.white,
          fontSize: small ? 9 : 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Build user section
  Widget _buildUserSection() {
    return Consumer<AdminProvider>(
      builder: (context, adminProvider, child) {
        final admin = adminProvider.currentAdmin;

        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: _showLabels ? 12 : 12,
            vertical: 8,
          ),
          padding: EdgeInsets.all(_showLabels ? 12 : 8),
          decoration: BoxDecoration(
            color: AdminColors.sidebarSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AdminColors.sidebarBorder.withOpacity(0.5),
            ),
          ),
          child: Row(
            mainAxisAlignment: _showLabels
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              // Avatar
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AdminColors.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AdminColors.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: _showLabels ? 18 : 16,
                  backgroundColor: Colors.transparent,
                  backgroundImage: admin?.avatarUrl != null
                      ? NetworkImage(admin!.avatarUrl!)
                      : null,
                  child: admin?.avatarUrl == null
                      ? Text(
                          admin?.name.substring(0, 1).toUpperCase() ?? 'A',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
              ),
              if (_showLabels) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        admin?.name ?? 'Admin User',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AdminColors.success.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Online',
                          style: TextStyle(
                            color: AdminColors.success,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Iconsax.more,
                  color: AdminColors.textMuted,
                  size: 18,
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  /// Build collapse button
  Widget _buildCollapseButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            widget.onToggleExpanded();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: widget.isExpanded ? 14 : 0,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: AdminColors.sidebarHover.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: widget.isExpanded
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                AnimatedRotation(
                  turns: widget.isExpanded ? 0 : 0.5,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Iconsax.arrow_left_2,
                    color: AdminColors.textMuted,
                    size: 18,
                  ),
                ),
                if (widget.isExpanded) ...[
                  const SizedBox(width: 10),
                  Text(
                    'Collapse',
                    style: TextStyle(
                      color: AdminColors.textMuted,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
