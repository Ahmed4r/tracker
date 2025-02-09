import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker/screens/credit_card_screen.dart';
import 'package:tracker/screens/homepage.dart';
import 'package:tracker/screens/settings_page.dart';

class CustomBottomNavBar extends StatefulWidget {
  static const String routeName = '/bottomNavBar';

  const CustomBottomNavBar({super.key});
  @override
  CustomBottomNavBarState createState() => CustomBottomNavBarState();
}

class CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _selectedIndex = 0; // Index of the selected tab

  // List of widgets to display for each tab
  static final List<Widget> pages = <Widget>[
    Homepage(),
    CreditCardScreen(),
    
    SettingsScreen(),
  ];

  // Function to handle tab selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: pages[_selectedIndex], // Display the selected tab
      ),
      bottomNavigationBar: BottomNavigationBar(
        
        elevation: 0,
        iconSize: 24.sp,
        selectedLabelStyle:
            GoogleFonts.inclusiveSans(color: Colors.white, fontSize: 12.sp),
        // showSelectedLabels: false,
        // showUnselectedLabels: false,
        fixedColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12.sp,

        selectedIconTheme: IconThemeData(
          color: Colors.white,
          grade: 1,
          applyTextScaling: true,
          fill: 1,
        ),

        unselectedItemColor: Colors.grey,

        backgroundColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // Handle tab selection
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: FaIcon(FontAwesomeIcons.home,size: 20.sp,),
            label: 'Home',
          ),
          
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: FaIcon(FontAwesomeIcons.creditCard,size: 20.sp,),
            label: 'Credit',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: FaIcon(FontAwesomeIcons.gear,size: 20.sp,),
            label: 'settings',
          ),
        ],
      ),
    );
  }
}
