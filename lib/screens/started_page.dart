import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker/screens/homepage.dart';

class StartedPage extends StatelessWidget {
  static const String routeName = '/started';
  const StartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Image.asset('assets/frame.png'),
          ),
          InkWell(
            onTap: (){
              Navigator.pushNamed(context, Homepage.routeName);
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