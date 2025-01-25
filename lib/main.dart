import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tracker/screens/homepage.dart';
import 'package:tracker/screens/started_page.dart';
import 'package:tracker/widgets/bottom_nav_bar.dart';

void main ()async{
   WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // Initialize Hive
  await Hive.openBox('transactions'); // Open a box
  await Hive.openBox('settings');

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
        initialRoute: CustomBottomNavBar.routeName,
        routes: {
          Homepage.routeName: (context) =>  Homepage(),
          StartedPage.routeName: (context) => const StartedPage(),
          CustomBottomNavBar.routeName: (context) =>  CustomBottomNavBar(),
        },
      ),
    );
  }
}