import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tracker/screens/homepage.dart';
import 'package:tracker/screens/started_page.dart';
import 'package:tracker/screens/settings_page.dart';
import 'package:tracker/widgets/bottom_nav_bar.dart';

void main ()async{
   WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // Initialize Hive
  await Hive.openBox('transactions'); 
  await Hive.openBox('settings');
  await Hive.openBox('myBox');
  await Hive.openBox('user');


  runApp(Moneytracker());
}
class Moneytracker extends StatelessWidget {
  const Moneytracker({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        theme: ThemeData(
          highlightColor: Colors.transparent,
    splashFactory: NoSplash.splashFactory, // Disables splash effect globally
  ),
        debugShowCheckedModeBanner: false,
        initialRoute: StartedPage.routeName,
        routes: {
          Homepage.routeName: (context) =>  Homepage(),
          StartedPage.routeName: (context) => const StartedPage(),
          CustomBottomNavBar.routeName: (context) =>  CustomBottomNavBar(),
          SettingsScreen.routeName: (context) =>  SettingsScreen(),
        },
      ),
    );
  }
}