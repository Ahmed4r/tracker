import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:tracker/screens/credit_card_screen.dart';

import 'package:tracker/screens/homepage.dart';
import 'package:tracker/screens/started_page.dart';
import 'package:tracker/screens/settings_page.dart';
import 'package:tracker/theme.dart';
import 'package:tracker/widgets/bottom_nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize(); // Ensure ScreenUtil is initialized
  await Hive.initFlutter(); // Initialize Hive
  await Hive.openBox('transactions');
  await Hive.openBox('settings');
  await Hive.openBox('myBox');
  await Hive.openBox('user');
  await Hive.openBox('creditCardBox'); // Open a box for credit card data


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
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          themeMode: ThemeMode.system,
          theme: Provider.of<ThemeProvider>(context).themeData, // Access theme data after initialization
          debugShowCheckedModeBanner: false,
          initialRoute: CustomBottomNavBar.routeName,
          routes: {
            Homepage.routeName: (context) => const Homepage(),
            StartedPage.routeName: (context) => const StartedPage(),
            CustomBottomNavBar.routeName: (context) =>  CustomBottomNavBar(),
            SettingsScreen.routeName: (context) =>  SettingsScreen(),
            CreditCardScreen.routeName: (context) =>  CreditCardScreen(),
          },
        );
      },
    );
  }
}