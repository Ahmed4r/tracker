import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import 'package:tracker/screens/homepage.dart';
import 'package:tracker/screens/started_page.dart';
import 'package:tracker/screens/settings_page.dart';
import 'package:tracker/theme.dart';
import 'package:tracker/widgets/bottom_nav_bar.dart';

void main ()async{
   WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('transactions'); 
  await Hive.openBox('settings');
  await Hive.openBox('myBox');
  await Hive.openBox('user');


  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const Moneytracker(),
    ),
  );
}
class Moneytracker extends StatelessWidget {
  const Moneytracker({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return ScreenUtilInit(
      
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        
       themeMode: ThemeMode.system,
       theme: themeProvider.themeData,
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