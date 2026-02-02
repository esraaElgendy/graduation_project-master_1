import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/bloc/settings_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/pages/login_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            // Header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      "SY",
                      style: GoogleFonts.cairo(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppConstants.studentName,
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    AppConstants.studentId,
                    style: GoogleFonts.cairo(color: Colors.grey),
                  ),
                   Text(
                    AppConstants.studentMajor, 
                    style: GoogleFonts.cairo(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Info Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoItem(l10n.name, AppConstants.studentName),
                  _buildInfoItem(l10n.email, AppConstants.studentEmail),
                  _buildInfoItem(l10n.major, AppConstants.studentMajor),
                  _buildInfoItem(l10n.yourYear, AppConstants.studentYear),
                  _buildInfoItem(l10n.phone, AppConstants.studentPhone),
                ],
              ),
            ),

             const SizedBox(height: 30),

            // Academic Summary
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    l10n.academicSummary,
                    style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.normal),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          context,
                          AppConstants.gpa.toString(),
                          l10n.gba,
                          isDark,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSummaryCard(
                          context,
                          AppConstants.completedCreditHours.toString(),
                          l10n.completedCreditHours,
                          isDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Settings
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.settings_outlined, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        l10n.dashboard, // "Settings" if we had the key, reusing Dashboard logic or just Hardcode Settings if allowed
                        style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Language
                  _buildSettingsRow(
                    icon: Icons.language,
                    title: l10n.language,
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.primaryDark : const Color(0xffDBDEFF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                         AppLocalizations.of(context)!.localeName == 'ar' ? 'العربية' : 'English',
                        style: GoogleFonts.cairo(color: isDark ? Colors.white : AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ),
                    onTap: () {
                       context.read<SettingsCubit>().toggleLocale();
                    }
                  ),
                  
                  // Notifications
                  _buildSettingsRow(
                    icon: Icons.notifications_none,
                    title: l10n.notifications,
                    subtitle: l10n.receiveAppNotifications,
                    trailing: Switch(
                      value: true, 
                      onChanged: (val) {},
                      activeColor: AppColors.primary,
                    ),
                  ),

                  // Dark Mode
                  BlocBuilder<SettingsCubit, SettingsState>(
                    builder: (context, state) {
                      return _buildSettingsRow(
                        icon: Icons.wb_sunny_outlined,
                        title: l10n.darkMode,
                        subtitle: "Toggle app theme",
                        trailing: Switch(
                          value: state.themeMode == ThemeMode.dark,
                          onChanged: (value) {
                            context.read<SettingsCubit>().toggleTheme(value);
                          },
                          activeColor: AppColors.primary,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Buttons
                  _buildActionButton(
                    context, 
                    l10n.changePassword, 
                    Icons.lock_outline, 
                    false, 
                    () {},
                    isDark
                  ),
                  const SizedBox(height: 10),
                  _buildActionButton(
                    context, 
                    l10n.editProfile, 
                    null, 
                    true, 
                    () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()));
                    },
                    isDark
                  ),
                  
                  const SizedBox(height: 20),
                   ListTile(
                    title: Text(l10n.logout, style: const TextStyle(color: Colors.red)),
                    leading: const Icon(Icons.logout, color: Colors.red),
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                         MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                  ),
                  const SizedBox(height: 40),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.cairo(color: Colors.grey, fontSize: 12)),
          Text(value, style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String value, String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : const Color(0xffDBDEFF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.cairo(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xff394188), // Primary
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 12,
              color: isDark ? Colors.white70 : const Color(0xff394188),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsRow({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.normal)),
                  if (subtitle != null)
                    Text(subtitle, style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String label, IconData? icon, bool isPrimary, VoidCallback onTap, bool isDark) {
    
    final bgColor = isPrimary 
          ? const Color(0xff394188) 
          : (isDark ? AppColors.cardDark : const Color(0xffDBDEFF));
    
    final fgColor = isPrimary 
          ? Colors.white 
          : (isDark ? Colors.white : Colors.black);
    
    final iconColor = isPrimary
          ? Colors.white
          : (isDark ? Colors.white : const Color(0xff394188));

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[Icon(icon, color: iconColor), const SizedBox(width: 8)],
            Text(label, style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: fgColor)),
          ],
        ),
      ),
    );
  }
}
