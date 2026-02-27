import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../core/admin_colors.dart';
import '../../providers/admin_provider.dart';
import '../admin_login_screen.dart';
import 'widgets/settings_section.dart';
import 'widgets/settings_text_field.dart';
import 'widgets/settings_dropdown.dart';
import 'widgets/settings_switch.dart';
import 'widgets/settings_action_button.dart';
import 'widgets/settings_account_section.dart';

/// Admin settings screen
class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  // Settings values
  bool _emailNotifications = true;
  bool _orderAlerts = true;
  bool _lowStockAlerts = true;
  bool _twoFactorAuth = false;
  String _currency = 'USD';
  String _timezone = 'UTC-5 (Eastern)';

  void _showConfirmDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$title completed'),
                  backgroundColor: AdminColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AdminColors.error),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showSaveSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Iconsax.tick_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('Settings saved successfully!'),
          ],
        ),
        backgroundColor: AdminColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showLogoutDialog() {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AdminColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Iconsax.logout, color: AdminColors.error, size: 20),
            ),
            const SizedBox(width: 12),
            const Text('Sign Out'),
          ],
        ),
        content: const Text(
          'Are you sure you want to sign out? You will need to sign in again to access the admin panel.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AdminColors.textSecondary),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.pop(context);
              await context.read<AdminProvider>().logout();
              if (mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const AdminLoginScreen(),
                  ),
                  (route) => false,
                );
              }
            },
            icon: const Icon(Iconsax.logout, size: 18),
            label: const Text('Sign Out'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AdminColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store Settings
          SettingsSection(
            title: 'Store Settings',
            icon: Iconsax.shop,
            color: AdminColors.accent,
            children: [
              SettingsTextField(
                label: 'Store Name',
                value: 'ShopEase',
                icon: Iconsax.shop,
              ),
              SettingsTextField(
                label: 'Store Email',
                value: 'contact@shopease.com',
                icon: Iconsax.sms,
              ),
              SettingsTextField(
                label: 'Store Phone',
                value: '+1 234 567 8900',
                icon: Iconsax.call,
              ),
              SettingsTextField(
                label: 'Store Address',
                value: '123 Commerce St, New York, NY',
                icon: Iconsax.location,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Regional Settings
          SettingsSection(
            title: 'Regional Settings',
            icon: Iconsax.global,
            color: AdminColors.info,
            children: [
              SettingsDropdown(
                label: 'Currency',
                value: _currency,
                options: ['USD', 'EUR', 'GBP', 'INR', 'AED'],
                onChanged: (v) => setState(() => _currency = v!),
              ),
              const SizedBox(height: 16),
              SettingsDropdown(
                label: 'Timezone',
                value: _timezone,
                options: ['UTC-5 (Eastern)', 'UTC-8 (Pacific)', 'UTC+0 (GMT)', 'UTC+5:30 (IST)'],
                onChanged: (v) => setState(() => _timezone = v!),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Notification Settings
          SettingsSection(
            title: 'Notification Settings',
            icon: Iconsax.notification,
            color: AdminColors.warning,
            children: [
              SettingsSwitch(
                title: 'Email Notifications',
                subtitle: 'Receive order and system emails',
                value: _emailNotifications,
                onChanged: (v) => setState(() => _emailNotifications = v),
              ),
              SettingsSwitch(
                title: 'Order Alerts',
                subtitle: 'Get notified for new orders',
                value: _orderAlerts,
                onChanged: (v) => setState(() => _orderAlerts = v),
              ),
              SettingsSwitch(
                title: 'Low Stock Alerts',
                subtitle: 'Alert when products are low',
                value: _lowStockAlerts,
                onChanged: (v) => setState(() => _lowStockAlerts = v),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Security Settings
          SettingsSection(
            title: 'Security Settings',
            icon: Iconsax.security_safe,
            color: AdminColors.success,
            children: [
              SettingsSwitch(
                title: 'Two-Factor Authentication',
                subtitle: 'Add extra security to your account',
                value: _twoFactorAuth,
                onChanged: (v) => setState(() => _twoFactorAuth = v),
              ),
              const SizedBox(height: 16),
              SettingsActionButton(
                title: 'Change Password',
                icon: Iconsax.lock,
                color: AdminColors.accent,
                onPressed: () {},
              ),
              const SizedBox(height: 12),
              SettingsActionButton(
                title: 'View Login History',
                icon: Iconsax.eye,
                color: AdminColors.info,
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Danger Zone
          SettingsSection(
            title: 'Danger Zone',
            icon: Iconsax.warning_2,
            color: AdminColors.error,
            children: [
              SettingsActionButton(
                title: 'Clear All Cache',
                icon: Iconsax.trash,
                color: AdminColors.warning,
                onPressed: () => _showConfirmDialog('Clear Cache', 'This will clear all cached data.'),
              ),
              const SizedBox(height: 12),
              SettingsActionButton(
                title: 'Reset Store Settings',
                icon: Iconsax.refresh,
                color: AdminColors.error,
                onPressed: () => _showConfirmDialog('Reset Settings', 'This will reset all settings to default.'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Account Section
          SettingsSection(
            title: 'Account',
            icon: Iconsax.user,
            color: AdminColors.primary,
            children: [
              SettingsAccountSection(onLogout: _showLogoutDialog),
            ],
          ),
          const SizedBox(height: 40),

          // Save button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _showSaveSuccess,
              icon: const Icon(Iconsax.tick_circle),
              label: const Text('Save Changes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AdminColors.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
