import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../l10n/app_localizations.dart'; // Reuse if possible or create new

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController(text: AppConstants.studentName);
  final TextEditingController _emailController = TextEditingController(text: "sheroukyassin@45.com"); // Static from screenshot
  final TextEditingController _majorController = TextEditingController(text: "System and Computer");
  final TextEditingController _phoneController = TextEditingController(text: "");
  String selectedYear = "Third Year"; // Default mock

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: BackButton(color: theme.primaryColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
             // Avatar
             Stack(
               alignment: Alignment.topRight,
               children: [
                 Container(
                   padding: const EdgeInsets.all(4),
                   decoration: const BoxDecoration(
                     color: Colors.white,
                     shape: BoxShape.circle,
                   ),
                   child: CircleAvatar(
                     radius: 45,
                     backgroundColor: AppColors.primary,
                     child: Text(
                       "SY",
                       style: GoogleFonts.cairo(
                         fontSize: 30,
                         fontWeight: FontWeight.bold,
                         color: Colors.white,
                       ),
                     ),
                   ),
                 ),
                 Container(
                   padding: const EdgeInsets.all(6),
                   decoration: BoxDecoration(
                     color: const Color(0xff9DA2FF),
                     shape: BoxShape.circle,
                     border: Border.all(color: Colors.white, width: 2),
                   ),
                   child: const Icon(Icons.edit, color: Colors.white, size: 16),
                 ),
               ],
             ),
             
             const SizedBox(height: 16),
             Text(
               AppConstants.studentName,
               style: GoogleFonts.cairo(
                 fontSize: 18,
                 fontWeight: FontWeight.bold,
                 color: AppColors.primary,
               ),
             ),
             Text(
               "20230001",
               style: GoogleFonts.cairo(color: Colors.grey),
             ),
             Text(
               "System and Computer",
               style: GoogleFonts.cairo(color: Colors.grey),
             ),

             const SizedBox(height: 30),

             _buildLabel(l10n.name, isDark),
             _buildTextField(controller: _nameController, isDark: isDark),
             
             const SizedBox(height: 16),
             _buildLabel(l10n.email, isDark),
             _buildTextField(controller: _emailController, isDark: isDark),
             
             const SizedBox(height: 16),
             _buildLabel(l10n.major, isDark),
             _buildTextField(controller: _majorController, isDark: isDark),

             const SizedBox(height: 16),
             _buildLabel(l10n.yourYear, isDark), // "Select your year"
             Container(
               width: double.infinity,
               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
               decoration: BoxDecoration(
                 color: isDark ? AppColors.inputFillDark : const Color(0xffEBEBFF),
                 borderRadius: BorderRadius.circular(12),
               ),
               child: DropdownButtonHideUnderline(
                 child: DropdownButton<String>(
                   value: selectedYear,
                   dropdownColor: isDark ? AppColors.cardDark : Colors.white,
                   items: ["First Year", "Second Year", "Third Year", "Fourth Year"]
                       .map((e) => DropdownMenuItem(value: e, child: Text(e, style: GoogleFonts.cairo(color: isDark ? Colors.white : Colors.black))))
                       .toList(),
                   onChanged: (val) {
                     if(val != null) setState(() => selectedYear = val);
                   },
                 ),
               ),
             ),

             const SizedBox(height: 16),
             _buildLabel(l10n.phone, isDark),
             _buildTextField(controller: _phoneController, isDark: isDark),

            const SizedBox(height: 40),
            
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  // Save logic
                  Navigator.pop(context);
                },
                child: Text(
                  l10n.save, 
                  style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label, bool isDark) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0, left: 4),
        child: Text(
          label,
          style: GoogleFonts.cairo(fontSize: 16, color: isDark ? Colors.white70 : Colors.black87),
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required bool isDark}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.inputFillDark : const Color(0xffEBEBFF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}
