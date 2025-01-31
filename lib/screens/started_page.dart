import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker/widgets/bottom_nav_bar.dart';

class StartedPage extends StatelessWidget {
  static const String routeName = '/started';
  const StartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(
            height: 100.h,
          ),
          Text("Money Tracker",style: GoogleFonts.firaSans(color: Colors.white,fontSize: 30.sp),),
          SizedBox(
            height: 20.h,
          ),
          Text("Track your expenses and income",style: GoogleFonts.firaSans(color: Colors.white,fontSize: 20.sp),),
          SizedBox(
            height: 30.h,
          ),
          Expanded(
            child: Image.asset('assets/frame.png',filterQuality: FilterQuality.high,),
          ),
          
          InkWell(
            onTap: (){
              Navigator.pushNamed(context, CustomBottomNavBar.routeName);
            },
            child: Container(
              width: 200.w,
              height: 40.h,
              decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.r),
              color: Colors.blue,
            ),
            child: Center(child: Text("Get Started",style: GoogleFonts.firaSans(color: Colors.white,fontSize: 20.sp),)),),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
    
  }
}