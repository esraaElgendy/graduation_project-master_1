import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bloc/course_cubit.dart';
import '../../../../core/bloc/settings_cubit.dart';
import '../../../../core/models/course_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import 'course_details_screen.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCourses();
    });
  }

  void _fetchCourses() {
    if (!mounted) return;
    final lang = Localizations.localeOf(context).languageCode;
    context.read<CourseCubit>().fetchCourses(lang: lang);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocListener<SettingsCubit, SettingsState>(
      listener: (context, state) {
        _fetchCourses();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.yourCourses),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _fetchCourses,
            ),
          ],
        ),
        body: BlocBuilder<CourseCubit, CourseState>(
          builder: (context, state) {
            if (state is CourseLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CourseError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _fetchCourses,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is CourseLoaded) {
              final levels = state.levels;
              if (levels.isEmpty) {
                return Center(child: Text(l10n.noLectures)); // Fallback if no specific "no courses" key
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.builder(
                  itemCount: levels.length + 1, // +1 for Search Bar
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              hintText: l10n.search,
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              fillColor: isDark
                                  ? AppColors.inputFillDark
                                  : Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    }

                    final level = levels[index - 1];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${l10n.level} ${level.level}",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        ...level.semesters.map((semester) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  "${l10n.semester} ${semester.semester}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey),
                                ),
                              ),
                              ...semester.courses.map((course) =>
                                  _buildCourseItem(
                                      context, course, l10n, isDark)),
                            ],
                          );
                        }),
                        const SizedBox(height: 20),
                      ],
                    );
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildCourseItem(BuildContext context, CourseModel course,
      AppLocalizations l10n, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : const Color(0xffE0E4FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          course.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Row(
          children: [
            Icon(Icons.hourglass_bottom,
                size: 16, color: isDark ? Colors.grey[400] : Colors.grey),
            const SizedBox(width: 4),
            Text("${course.creditHours} ${l10n.creditHours}",
                style: TextStyle(color: isDark ? Colors.grey[400] : null)),
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
