import 'package:flutter/material.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../l10n/app_localizations.dart';
import 'course_details_screen.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.yourCourses),
        centerTitle: true,
        backgroundColor: Colors.transparent, // or theme.primaryColor if needed
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: l10n.search,
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: isDark ? AppColors.inputFillDark : Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              Text(
                l10n.level1Semester1,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...AppConstants.coursesLvl1Sem1.map((c) => _buildCourseItem(context, c, l10n, isDark)),
              
              const SizedBox(height: 20),
               Text(
                l10n.level1Semester2,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...AppConstants.coursesLvl1Sem2.map((c) => _buildCourseItem(context, c, l10n, isDark)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseItem(BuildContext context, Map<String, dynamic> course, AppLocalizations l10n, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : const Color(0xffE0E4FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          course['name'],
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Row(
          children: [
            Icon(Icons.person_outline, size: 16, color: isDark ? Colors.grey[400] : Colors.grey),
            const SizedBox(width: 4),
            Text("${course['students']} ${l10n.students}", style: TextStyle(color: isDark ? Colors.grey[400] : null)),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CourseDetailsScreen(),
            ),
          );
        },
      ),
    );
  }
}
