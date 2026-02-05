import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/bloc/student_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../courses/presentation/pages/courses_screen.dart';
import '../../../grades/presentation/pages/grades_screen.dart';
import '../../../profile/presentation/pages/profile_screen.dart';
import '../../../schedule/presentation/pages/schedule_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardBgColor = isDark ? AppColors.cardDark : const Color(0xffE0E4FF);
    final lightCardBg = isDark ? AppColors.primaryDark : const Color(0xffBDC3FF);

    return BlocBuilder<StudentCubit, StudentState>(
      builder: (context, state) {
        // Default values (fallback)
        String studentName = 'Student';
        double gpa = 0.0;
        int completedHours = 0;
        int remainingHours = 0;
        int totalHours = 160;

        if (state is StudentLoaded) {
          studentName = state.user.name;
          gpa = state.user.gpa ?? 0.0;
          completedHours = state.user.completedCreditHours ?? 0;
          remainingHours = state.user.remainingCreditHours ?? 0;
          totalHours = state.user.totalCreditHours ?? 160;
        }

        final progress = totalHours > 0 ? completedHours / totalHours : 0.0;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              l10n.dashboard,
              style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.notifications_none, color: theme.primaryColor),
                onPressed: () {},
              ),
            ],
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
          ),
          body: state is StudentLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          studentName,
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // GBA Card
                        _buildStatCard(
                          context,
                          l10n.gba,
                          gpa.toStringAsFixed(2),
                          Icons.analytics,
                          cardBgColor,
                          lightCardBg,
                        ),
                        const SizedBox(height: 12),

                        // Completed Hours Card
                        _buildStatCard(
                          context,
                          l10n.completedCreditHours,
                          completedHours.toString(),
                          Icons.check_circle_outline,
                          cardBgColor,
                          lightCardBg,
                        ),
                        const SizedBox(height: 12),

                        // Remaining Hours Card
                        _buildStatCard(
                          context,
                          l10n.remainingCreditHours,
                          remainingHours.toString(),
                          Icons.hourglass_empty,
                          cardBgColor,
                          lightCardBg,
                        ),

                        const SizedBox(height: 20),

                        // Overall Progress
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.cardDark : Colors.blue[50],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.overallProgress,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(l10n.completedCreditHours),
                                  Text("$completedHours / $totalHours"),
                                ],
                              ),
                              const SizedBox(height: 10),
                              LinearProgressIndicator(
                                value: progress,
                                backgroundColor: isDark ? Colors.grey[700] : Colors.white,
                                color: theme.primaryColor,
                                minHeight: 10,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "${(progress * 100).toStringAsFixed(1)}% ${l10n.overallProgress}",
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Grid Menu
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          children: [
                            _buildMenuCard(context, l10n.courseRegistration, Icons.book, () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const CoursesScreen()));
                            }),
                            _buildMenuCard(context, l10n.mySchedule, Icons.calendar_today, () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const ScheduleScreen()));
                            }),
                            _buildMenuCard(context, l10n.myGrades, Icons.school, () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const GradesScreen()));
                            }),
                            _buildMenuCard(context, l10n.profile, Icons.person, () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color bgColor, Color iconBgColor) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: theme.primaryColor, width: 6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
            ],
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.blue),
          )
        ],
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : const Color(0xffE0E4FF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: theme.primaryColor,
              radius: 25,
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
