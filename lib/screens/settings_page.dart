import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tracker/theme.dart';
import 'package:tracker/widgets/bottom_nav_bar.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = '/settings';
  SettingsScreen({super.key});

  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
     final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        
        leading: IconButton(
          onPressed: () {
            Navigator.popAndPushNamed(context,CustomBottomNavBar.routeName); 
          },
          icon: const FaIcon(
            FontAwesomeIcons.arrowLeft,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          "Settings",
          style: GoogleFonts.firaSans(
            color: Colors.white,
            fontSize: 20.sp,
          ),
        ),
      actions: [
        IconButton(
          icon:  FaIcon(
           themeProvider.isDarkMode ? FontAwesomeIcons.sun : FontAwesomeIcons.moon,
            color: Colors.white,
          ),
          onPressed: () {
            // Handle dark mode toggle
             themeProvider.toggleTheme();
            
          },
        ),
      ],
        centerTitle: true,
      ),
     
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            Text(
              "Enter Your Name",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.all(20).r,
              height: 65.h,
              decoration: BoxDecoration(
                color:Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10.r),
              )
              ,
              child: TextFormField(
                maxLines: 1,
                
                controller: nameController,
                style: GoogleFonts.firaSans(
                  color: Colors.white,
                  fontSize: 15.sp,
                ),
                
                decoration: InputDecoration(
                  hintText: "e.g., John Doe",
                  hintStyle: GoogleFonts.firaSans(
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                    fontSize: 15.sp,
                  ),
                  enabledBorder: InputBorder.none,
                  border: InputBorder.none,
                  focusedBorder:InputBorder.none
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your name";
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 20.h),
            Center(
              child: ElevatedButton(
  onPressed: () async {
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please enter your name",
            style:Theme.of(context).textTheme.bodyMedium
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final settingsBox = Hive.box('settings');
      await settingsBox.put('name', nameController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Name saved successfully!",
            style: GoogleFonts.firaSans(
              color: Colors.white,
              fontSize: 14.sp,
            ),
          ),
          backgroundColor: Colors.green,
        ),
      );
       // Go back to the previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to save name: $e",
            style: GoogleFonts.firaSans(
              color: Colors.white,
              fontSize: 14.sp,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  },
  child: Text(
    "Save",
    style:Theme.of(context).textTheme.bodyMedium
  ),
),
            ),
            
          ],
        ),
      ),
    );
  }
}