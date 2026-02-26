import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/common/custom_app_bar.dart';

/// Settings screen for app preferences
/// Includes theme toggle, notifications, and other settings
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  String _selectedLanguage = 'English';
  String _selectedCurrency = 'USD (\$)';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: AppStrings.appSettings,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Appearance section
          _buildSectionTitle(context, 'Appearance'),
          _buildSettingsCard(context, [
            // Dark mode toggle
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return _buildSwitchTile(
                  context: context,
                  icon: Iconsax.moon,
                  title: AppStrings.darkMode,
                  subtitle: 'Switch between light and dark theme',
                  value: themeProvider.isDarkMode,
                  onChanged: (value) => themeProvider.toggleTheme(),
                );
              },
            ),
          ]),
          const SizedBox(height: 16),

          // Localization section
          _buildSectionTitle(context, 'Localization'),
          _buildSettingsCard(context, [
            _buildListTile(
              context: context,
              icon: Iconsax.global,
              title: AppStrings.language,
              value: _selectedLanguage,
              onTap: () => _showLanguageBottomSheet(context),
            ),
            const Divider(height: 1, indent: 60),
            _buildListTile(
              context: context,
              icon: Iconsax.dollar_circle,
              title: AppStrings.currency,
              value: _selectedCurrency,
              onTap: () => _showCurrencyBottomSheet(context),
            ),
          ]),
          const SizedBox(height: 16),

          // Notifications section
          _buildSectionTitle(context, 'Notifications'),
          _buildSettingsCard(context, [
            _buildSwitchTile(
              context: context,
              icon: Iconsax.notification,
              title: AppStrings.pushNotifications,
              subtitle: 'Receive push notifications',
              value: _pushNotifications,
              onChanged: (value) => setState(() => _pushNotifications = value),
            ),
            const Divider(height: 1, indent: 60),
            _buildSwitchTile(
              context: context,
              icon: Iconsax.sms,
              title: AppStrings.emailNotifications,
              subtitle: 'Receive email updates',
              value: _emailNotifications,
              onChanged: (value) => setState(() => _emailNotifications = value),
            ),
          ]),
          const SizedBox(height: 16),

          // Legal section
          _buildSectionTitle(context, 'Legal'),
          _buildSettingsCard(context, [
            _buildListTile(
              context: context,
              icon: Iconsax.shield_tick,
              title: AppStrings.privacyPolicy,
              onTap: () {},
            ),
            const Divider(height: 1, indent: 60),
            _buildListTile(
              context: context,
              icon: Iconsax.document_text,
              title: AppStrings.termsConditions,
              onTap: () {},
            ),
          ]),
          const SizedBox(height: 16),

          // App info section
          _buildSectionTitle(context, 'About'),
          _buildSettingsCard(context, [
            _buildListTile(
              context: context,
              icon: Iconsax.info_circle,
              title: AppStrings.version,
              value: '1.0.0',
              showArrow: false,
            ),
          ]),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  /// Build section title
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  /// Build settings card container
  Widget _buildSettingsCard(BuildContext context, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  /// Build switch tile
  Widget _buildSwitchTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.primary, size: 22),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textLight,
                  ),
            )
          : null,
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }

  /// Build list tile with value
  Widget _buildListTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? value,
    VoidCallback? onTap,
    bool showArrow = true,
  }) {
    return ListTile(
      leading: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.primary, size: 22),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null)
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textLight,
                  ),
            ),
          if (showArrow) ...[
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppColors.textLight,
            ),
          ],
        ],
      ),
      onTap: onTap,
    );
  }

  /// Show language selection bottom sheet
  void _showLanguageBottomSheet(BuildContext context) {
    final languages = ['English', 'Spanish', 'French', 'German', 'Arabic'];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Language',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              ...languages.map((language) {
                return ListTile(
                  title: Text(language),
                  trailing: _selectedLanguage == language
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() => _selectedLanguage = language);
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  /// Show currency selection bottom sheet
  void _showCurrencyBottomSheet(BuildContext context) {
    final currencies = [
      'USD (\$)',
      'EUR (€)',
      'GBP (£)',
      'INR (₹)',
      'AED (د.إ)'
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Currency',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              ...currencies.map((currency) {
                return ListTile(
                  title: Text(currency),
                  trailing: _selectedCurrency == currency
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() => _selectedCurrency = currency);
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
