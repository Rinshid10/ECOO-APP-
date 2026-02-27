import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/responsive.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/common/custom_snackbar.dart';
import '../../admin/screens/admin_login_screen.dart';

/// Settings screen with modern UI design
/// Features animated toggles, organized sections, and smooth interactions
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  // Notification settings
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _smsNotifications = false;
  bool _orderUpdates = true;
  bool _promotionalAlerts = true;

  // Privacy settings
  bool _biometricAuth = false;
  bool _saveLoginInfo = true;

  // Data settings
  bool _autoDownloadImages = true;
  bool _dataSaver = false;

  // Selected values
  String _selectedLanguage = 'English';
  String _selectedCurrency = 'USD (\$)';

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          if (!isDesktop) _buildSliverAppBar(context),

          if (isDesktop)
            SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: Responsive.narrowContentWidth,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                    child: Row(
                      children: [
                        TextButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Iconsax.arrow_left),
                          label: const Text('Back'),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          AppStrings.settings,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: Responsive.narrowContentWidth,
                ),
                child: Padding(
                  padding: EdgeInsets.all(isDesktop ? 24 : 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAnimatedSection(
                        delay: 0,
                        child: _buildAppearanceSection(context),
                      ),
                      const SizedBox(height: 24),
                      _buildAnimatedSection(
                        delay: 100,
                        child: _buildNotificationsSection(context),
                      ),
                      const SizedBox(height: 24),
                      _buildAnimatedSection(
                        delay: 200,
                        child: _buildPrivacySection(context),
                      ),
                      const SizedBox(height: 24),
                      _buildAnimatedSection(
                        delay: 300,
                        child: _buildLocalizationSection(context),
                      ),
                      const SizedBox(height: 24),
                      _buildAnimatedSection(
                        delay: 400,
                        child: _buildDataSection(context),
                      ),
                      const SizedBox(height: 24),
                      _buildAnimatedSection(
                        delay: 500,
                        child: _buildAboutSection(context),
                      ),
                      const SizedBox(height: 24),
                      _buildAnimatedSection(
                        delay: 600,
                        child: _buildDangerZone(context),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build sliver app bar with gradient
  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 140,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
          ),
          child: Stack(
            children: [
              // Decorative circles
              Positioned(
                top: -30,
                right: -30,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                bottom: -20,
                left: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),
              // Title content
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Settings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Customize your app experience',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build animated section wrapper
  Widget _buildAnimatedSection({required int delay, required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
    );
  }

  /// Build section header with icon
  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  /// Build settings card container
  Widget _buildSettingsCard(BuildContext context, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(children: children),
      ),
    );
  }

  /// Build appearance section
  Widget _buildAppearanceSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          context,
          title: 'Appearance',
          icon: Iconsax.paintbucket,
          color: AppColors.accent,
        ),
        _buildSettingsCard(context, [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return _buildSwitchTile(
                context: context,
                icon: themeProvider.isDarkMode ? Iconsax.moon5 : Iconsax.sun_15,
                iconColor: themeProvider.isDarkMode
                    ? AppColors.warning
                    : AppColors.accent,
                title: AppStrings.darkMode,
                subtitle: themeProvider.isDarkMode
                    ? 'Dark theme is enabled'
                    : 'Light theme is enabled',
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  HapticFeedback.lightImpact();
                  themeProvider.toggleTheme();
                },
              );
            },
          ),
        ]),
      ],
    );
  }

  /// Build notifications section
  Widget _buildNotificationsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          context,
          title: 'Notifications',
          icon: Iconsax.notification,
          color: AppColors.secondary,
        ),
        _buildSettingsCard(context, [
          _buildSwitchTile(
            context: context,
            icon: Iconsax.notification_bing,
            iconColor: AppColors.primary,
            title: AppStrings.pushNotifications,
            subtitle: 'Receive push notifications',
            value: _pushNotifications,
            onChanged: (value) {
              HapticFeedback.lightImpact();
              setState(() => _pushNotifications = value);
            },
          ),
          _buildDivider(),
          _buildSwitchTile(
            context: context,
            icon: Iconsax.sms,
            iconColor: AppColors.info,
            title: AppStrings.emailNotifications,
            subtitle: 'Receive email updates',
            value: _emailNotifications,
            onChanged: (value) {
              HapticFeedback.lightImpact();
              setState(() => _emailNotifications = value);
            },
          ),
          _buildDivider(),
          _buildSwitchTile(
            context: context,
            icon: Iconsax.message,
            iconColor: AppColors.success,
            title: 'SMS Notifications',
            subtitle: 'Receive SMS alerts',
            value: _smsNotifications,
            onChanged: (value) {
              HapticFeedback.lightImpact();
              setState(() => _smsNotifications = value);
            },
          ),
          _buildDivider(),
          _buildSwitchTile(
            context: context,
            icon: Iconsax.box,
            iconColor: AppColors.warning,
            title: 'Order Updates',
            subtitle: 'Get notified about order status',
            value: _orderUpdates,
            onChanged: (value) {
              HapticFeedback.lightImpact();
              setState(() => _orderUpdates = value);
            },
          ),
          _buildDivider(),
          _buildSwitchTile(
            context: context,
            icon: Iconsax.discount_shape,
            iconColor: AppColors.secondary,
            title: 'Promotional Alerts',
            subtitle: 'Receive deals and offers',
            value: _promotionalAlerts,
            onChanged: (value) {
              HapticFeedback.lightImpact();
              setState(() => _promotionalAlerts = value);
            },
          ),
        ]),
      ],
    );
  }

  /// Build privacy & security section
  Widget _buildPrivacySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          context,
          title: 'Privacy & Security',
          icon: Iconsax.shield_tick,
          color: AppColors.success,
        ),
        _buildSettingsCard(context, [
          _buildSwitchTile(
            context: context,
            icon: Iconsax.finger_scan,
            iconColor: AppColors.primary,
            title: 'Biometric Authentication',
            subtitle: 'Use fingerprint or Face ID',
            value: _biometricAuth,
            onChanged: (value) {
              HapticFeedback.lightImpact();
              setState(() => _biometricAuth = value);
            },
          ),
          _buildDivider(),
          _buildSwitchTile(
            context: context,
            icon: Iconsax.key,
            iconColor: AppColors.warning,
            title: 'Remember Login',
            subtitle: 'Stay signed in on this device',
            value: _saveLoginInfo,
            onChanged: (value) {
              HapticFeedback.lightImpact();
              setState(() => _saveLoginInfo = value);
            },
          ),
          _buildDivider(),
          _buildActionTile(
            context: context,
            icon: Iconsax.lock,
            iconColor: AppColors.info,
            title: 'Change Password',
            subtitle: 'Update your account password',
            onTap: () {
              HapticFeedback.lightImpact();
              _showChangePasswordDialog(context);
            },
          ),
        ]),
      ],
    );
  }

  /// Build localization section
  Widget _buildLocalizationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          context,
          title: 'Localization',
          icon: Iconsax.global,
          color: AppColors.info,
        ),
        _buildSettingsCard(context, [
          _buildValueTile(
            context: context,
            icon: Iconsax.translate,
            iconColor: AppColors.primary,
            title: AppStrings.language,
            value: _selectedLanguage,
            onTap: () => _showLanguageBottomSheet(context),
          ),
          _buildDivider(),
          _buildValueTile(
            context: context,
            icon: Iconsax.dollar_circle,
            iconColor: AppColors.success,
            title: AppStrings.currency,
            value: _selectedCurrency,
            onTap: () => _showCurrencyBottomSheet(context),
          ),
          _buildDivider(),
          _buildValueTile(
            context: context,
            icon: Iconsax.ruler,
            iconColor: AppColors.accent,
            title: 'Measurement Unit',
            value: 'Metric (cm, kg)',
            onTap: () => _showMeasurementBottomSheet(context),
          ),
        ]),
      ],
    );
  }

  /// Build data & storage section
  Widget _buildDataSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          context,
          title: 'Data & Storage',
          icon: Iconsax.document_download,
          color: AppColors.warning,
        ),
        _buildSettingsCard(context, [
          _buildSwitchTile(
            context: context,
            icon: Iconsax.image,
            iconColor: AppColors.primary,
            title: 'Auto-download Images',
            subtitle: 'Download images automatically',
            value: _autoDownloadImages,
            onChanged: (value) {
              HapticFeedback.lightImpact();
              setState(() => _autoDownloadImages = value);
            },
          ),
          _buildDivider(),
          _buildSwitchTile(
            context: context,
            icon: Iconsax.flash,
            iconColor: AppColors.success,
            title: 'Data Saver',
            subtitle: 'Reduce data usage',
            value: _dataSaver,
            onChanged: (value) {
              HapticFeedback.lightImpact();
              setState(() => _dataSaver = value);
            },
          ),
          _buildDivider(),
          _buildActionTile(
            context: context,
            icon: Iconsax.trash,
            iconColor: AppColors.error,
            title: 'Clear Cache',
            subtitle: 'Free up storage space',
            onTap: () {
              HapticFeedback.mediumImpact();
              _showClearCacheDialog(context);
            },
          ),
        ]),
      ],
    );
  }

  /// Build about & legal section
  Widget _buildAboutSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          context,
          title: 'About & Legal',
          icon: Iconsax.info_circle,
          color: AppColors.textSecondary,
        ),
        _buildSettingsCard(context, [
          _buildValueTile(
            context: context,
            icon: Iconsax.code,
            iconColor: AppColors.primary,
            title: AppStrings.version,
            value: '1.0.0 (Build 42)',
            showArrow: false,
          ),
          _buildDivider(),
          _buildActionTile(
            context: context,
            icon: Iconsax.shield_tick,
            iconColor: AppColors.success,
            title: AppStrings.privacyPolicy,
            onTap: () {
              HapticFeedback.lightImpact();
              // Navigate to privacy policy
            },
          ),
          _buildDivider(),
          _buildActionTile(
            context: context,
            icon: Iconsax.document_text,
            iconColor: AppColors.info,
            title: AppStrings.termsConditions,
            onTap: () {
              HapticFeedback.lightImpact();
              // Navigate to terms
            },
          ),
          _buildDivider(),
          _buildActionTile(
            context: context,
            icon: Iconsax.document,
            iconColor: AppColors.warning,
            title: 'Open Source Licenses',
            onTap: () {
              HapticFeedback.lightImpact();
              showLicensePage(context: context);
            },
          ),
          _buildDivider(),
          _buildActionTile(
            context: context,
            icon: Iconsax.star,
            iconColor: AppColors.accent,
            title: 'Rate This App',
            onTap: () {
              HapticFeedback.lightImpact();
              // Open app store
            },
          ),
          _buildDivider(),
          _buildActionTile(
            context: context,
            icon: Iconsax.security_user,
            iconColor: AppColors.primary,
            title: 'Admin Panel',
            subtitle: 'Access store management',
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminLoginScreen(),
                ),
              );
            },
          ),
        ]),
      ],
    );
  }

  /// Build danger zone section
  Widget _buildDangerZone(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          context,
          title: 'Account Actions',
          icon: Iconsax.warning_2,
          color: AppColors.error,
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.error.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              _buildActionTile(
                context: context,
                icon: Iconsax.logout,
                iconColor: AppColors.error,
                title: 'Log Out',
                subtitle: 'Sign out of your account',
                textColor: AppColors.error,
                onTap: () {
                  HapticFeedback.mediumImpact();
                  _showLogoutDialog(context);
                },
              ),
              Divider(
                height: 1,
                indent: 70,
                endIndent: 20,
                color: AppColors.error.withOpacity(0.2),
              ),
              _buildActionTile(
                context: context,
                icon: Iconsax.profile_delete,
                iconColor: AppColors.error,
                title: 'Delete Account',
                subtitle: 'Permanently delete your account',
                textColor: AppColors.error,
                onTap: () {
                  HapticFeedback.heavyImpact();
                  _showDeleteAccountDialog(context);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build divider
  Widget _buildDivider() {
    return Divider(
      height: 1,
      indent: 70,
      endIndent: 20,
      color: AppColors.grey200,
    );
  }

  /// Build switch tile
  Widget _buildSwitchTile({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textLight,
                        ),
                  ),
                ],
              ],
            ),
          ),
          _buildAnimatedSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  /// Build animated switch
  Widget _buildAnimatedSwitch({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 52,
        height: 30,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: value
              ? const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                )
              : null,
          color: value ? null : AppColors.grey300,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build value tile (shows current value)
  Widget _buildValueTile({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    VoidCallback? onTap,
    bool showArrow = true,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (onTap != null) {
            HapticFeedback.lightImpact();
            onTap();
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              if (showArrow) ...[
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: AppColors.textLight,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Build action tile (navigates or performs action)
  Widget _buildActionTile({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: textColor?.withOpacity(0.7) ??
                                  AppColors.textLight,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: textColor ?? AppColors.textLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show language selection bottom sheet
  void _showLanguageBottomSheet(BuildContext context) {
    final languages = [
      {'name': 'English', 'flag': '🇺🇸'},
      {'name': 'Spanish', 'flag': '🇪🇸'},
      {'name': 'French', 'flag': '🇫🇷'},
      {'name': 'German', 'flag': '🇩🇪'},
      {'name': 'Arabic', 'flag': '🇸🇦'},
      {'name': 'Hindi', 'flag': '🇮🇳'},
      {'name': 'Chinese', 'flag': '🇨🇳'},
    ];

    _showSelectionBottomSheet(
      context: context,
      title: 'Select Language',
      icon: Iconsax.translate,
      items: languages,
      selectedValue: _selectedLanguage,
      onSelect: (value) {
        setState(() => _selectedLanguage = value);
        CustomSnackBar.showSuccess(context, 'Language changed to $value');
      },
    );
  }

  /// Show currency selection bottom sheet
  void _showCurrencyBottomSheet(BuildContext context) {
    final currencies = [
      {'name': 'USD (\$)', 'flag': '🇺🇸'},
      {'name': 'EUR (€)', 'flag': '🇪🇺'},
      {'name': 'GBP (£)', 'flag': '🇬🇧'},
      {'name': 'INR (₹)', 'flag': '🇮🇳'},
      {'name': 'AED (د.إ)', 'flag': '🇦🇪'},
      {'name': 'JPY (¥)', 'flag': '🇯🇵'},
    ];

    _showSelectionBottomSheet(
      context: context,
      title: 'Select Currency',
      icon: Iconsax.dollar_circle,
      items: currencies,
      selectedValue: _selectedCurrency,
      onSelect: (value) {
        setState(() => _selectedCurrency = value);
        CustomSnackBar.showSuccess(context, 'Currency changed to $value');
      },
    );
  }

  /// Show measurement unit bottom sheet
  void _showMeasurementBottomSheet(BuildContext context) {
    final units = [
      {'name': 'Metric (cm, kg)', 'flag': '📏'},
      {'name': 'Imperial (in, lb)', 'flag': '📐'},
    ];

    _showSelectionBottomSheet(
      context: context,
      title: 'Select Unit',
      icon: Iconsax.ruler,
      items: units,
      selectedValue: 'Metric (cm, kg)',
      onSelect: (value) {
        CustomSnackBar.showSuccess(context, 'Units changed to $value');
      },
    );
  }

  /// Show selection bottom sheet
  void _showSelectionBottomSheet({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<Map<String, String>> items,
    required String selectedValue,
    required Function(String) onSelect,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: AppColors.primary, size: 22),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Options
              ...items.map((item) {
                final isSelected = item['name'] == selectedValue;
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                      onSelect(item['name']!);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          Text(
                            item['flag']!,
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              item['name']!,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? AppColors.primary
                                        : null,
                                  ),
                            ),
                          ),
                          if (isSelected)
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
            ],
          ),
        );
      },
    );
  }

  /// Show change password dialog
  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Iconsax.lock, color: AppColors.info),
            ),
            const SizedBox(width: 12),
            const Text('Change Password'),
          ],
        ),
        content: const Text(
          'You will receive an email with instructions to reset your password.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              CustomSnackBar.showSuccess(
                context,
                'Password reset email sent!',
              );
            },
            child: const Text('Send Email'),
          ),
        ],
      ),
    );
  }

  /// Show clear cache dialog
  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Iconsax.trash, color: AppColors.warning),
            ),
            const SizedBox(width: 12),
            const Text('Clear Cache'),
          ],
        ),
        content: const Text(
          'This will clear all cached images and data. You may need to re-download content.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              CustomSnackBar.showSuccess(context, 'Cache cleared successfully!');
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  /// Show logout dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Iconsax.logout, color: AppColors.error),
            ),
            const SizedBox(width: 12),
            const Text('Log Out'),
          ],
        ),
        content: const Text('Are you sure you want to log out of your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              // Perform logout
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  /// Show delete account dialog
  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Iconsax.profile_delete, color: AppColors.error),
            ),
            const SizedBox(width: 12),
            const Expanded(child: Text('Delete Account')),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This action cannot be undone. All your data will be permanently deleted.',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 12),
            Text(
              'You will lose:',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            SizedBox(height: 8),
            Text('• Order history', style: TextStyle(color: AppColors.error)),
            Text('• Wishlist items', style: TextStyle(color: AppColors.error)),
            Text('• Saved addresses', style: TextStyle(color: AppColors.error)),
            Text('• Account settings', style: TextStyle(color: AppColors.error)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Perform account deletion
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete Forever'),
          ),
        ],
      ),
    );
  }
}
