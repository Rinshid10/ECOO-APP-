import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/responsive.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/custom_button.dart';

/// Contact support screen - responsive layout
class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: isDesktop ? null : const CustomAppBar(title: AppStrings.contactSupport),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isDesktop ? Responsive.narrowContentWidth : double.infinity,
            ),
            child: Padding(
              padding: EdgeInsets.all(isDesktop ? 40 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isDesktop) ...[
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Iconsax.arrow_left),
                          label: const Text('Back'),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          AppStrings.contactSupport,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                  _buildHeader(context),
                  const SizedBox(height: 24),
                  _buildQuickContactSection(context),
                  const SizedBox(height: 32),
                  _buildContactForm(context),
                  const SizedBox(height: 32),
                  _buildFaqSection(context),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('How can we help?',
                    style: TextStyle(color: AppColors.textWhite, fontSize: 24,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('We\'re here to help you 24/7.\nGet in touch with our support team.',
                    style: TextStyle(
                        color: AppColors.textWhite.withOpacity(0.9),
                        fontSize: 14, height: 1.5)),
              ],
            ),
          ),
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              color: AppColors.textWhite.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Iconsax.headphone, size: 40,
                color: AppColors.textWhite),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickContactSection(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.getInTouch,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        if (isDesktop)
          Row(
            children: [
              _buildContactOption(context: context, icon: Iconsax.call,
                  title: AppStrings.callUs, subtitle: '+1 234 567 890',
                  color: AppColors.success, onTap: () {}),
              const SizedBox(width: 16),
              _buildContactOption(context: context, icon: Iconsax.sms,
                  title: AppStrings.emailUs, subtitle: 'support@shopease.com',
                  color: AppColors.info, onTap: () {}),
              const SizedBox(width: 16),
              _buildContactOption(context: context, icon: Iconsax.message,
                  title: AppStrings.liveChat, subtitle: 'Available 24/7',
                  color: AppColors.secondary, onTap: () {}),
              const SizedBox(width: 16),
              _buildContactOption(context: context, icon: Iconsax.message_text,
                  title: 'WhatsApp', subtitle: 'Quick support',
                  color: const Color(0xFF25D366), onTap: () {}),
            ],
          )
        else ...[
          Row(
            children: [
              _buildContactOption(context: context, icon: Iconsax.call,
                  title: AppStrings.callUs, subtitle: '+1 234 567 890',
                  color: AppColors.success, onTap: () {}),
              const SizedBox(width: 16),
              _buildContactOption(context: context, icon: Iconsax.sms,
                  title: AppStrings.emailUs, subtitle: 'support@shopease.com',
                  color: AppColors.info, onTap: () {}),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildContactOption(context: context, icon: Iconsax.message,
                  title: AppStrings.liveChat, subtitle: 'Available 24/7',
                  color: AppColors.secondary, onTap: () {}),
              const SizedBox(width: 16),
              _buildContactOption(context: context, icon: Iconsax.message_text,
                  title: 'WhatsApp', subtitle: 'Quick support',
                  color: const Color(0xFF25D366), onTap: () {}),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildContactOption({
    required BuildContext context, required IconData icon, required String title,
    required String subtitle, required Color color, required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withOpacity(0.05), blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50, height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textLight),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.submitTicket,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withOpacity(0.05), blurRadius: 10,
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _subjectController,
                  decoration: InputDecoration(
                    labelText: AppStrings.subject,
                    prefixIcon: const Icon(Iconsax.document_text),
                    filled: true,
                    fillColor: AppColors.grey100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a subject';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _messageController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: AppStrings.message,
                    alignLabelWithHint: true,
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(bottom: 80),
                      child: Icon(Iconsax.message_text),
                    ),
                    filled: true,
                    fillColor: AppColors.grey100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your message';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: AppStrings.send,
                  icon: Iconsax.send_1,
                  onPressed: _submitForm,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFaqSection(BuildContext context) {
    final faqs = [
      {'question': 'How can I track my order?',
        'answer': 'You can track your order by going to My Orders section in your profile. Click on the order to see real-time tracking updates.'},
      {'question': 'What is the return policy?',
        'answer': 'We offer a 30-day return policy for most items. Items must be unused and in original packaging.'},
      {'question': 'How do I cancel my order?',
        'answer': 'You can cancel your order within 24 hours of placing it. Go to My Orders, select the order, and tap Cancel.'},
      {'question': 'Do you offer international shipping?',
        'answer': 'Yes, we ship to over 100 countries worldwide. Shipping costs and delivery times vary by location.'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.faq,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withOpacity(0.05), blurRadius: 10,
              ),
            ],
          ),
          child: ExpansionPanelList.radio(
            elevation: 0,
            children: faqs.asMap().entries.map((entry) {
              final index = entry.key;
              final faq = entry.value;
              return ExpansionPanelRadio(
                value: index,
                headerBuilder: (context, isExpanded) {
                  return ListTile(
                    title: Text(faq['question']!,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                  );
                },
                body: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(faq['answer']!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary, height: 1.5)),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your message has been sent successfully!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      _subjectController.clear();
      _messageController.clear();
    }
  }
}
