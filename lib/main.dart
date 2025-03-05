import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lastrasin1/methods/methods.dart';
import 'package:lastrasin1/viewmodel/body_provider.dart';
import 'package:provider/provider.dart';
import 'package:lastrasin1/firebase_options.dart';
import 'package:lastrasin1/view/screens/splash_screen.dart';
import 'package:lastrasin1/viewmodel/auth_provider.dart';
import 'package:lastrasin1/viewmodel/countries_provider.dart';
import 'package:lastrasin1/viewmodel/tabs_provider.dart';
import 'package:lastrasin1/viewmodel/worker_provider.dart';
import 'package:lastrasin1/viewmodel/theme_provider.dart'; // Add this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar', 'SA'), Locale('ar', 'SA')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar', 'SA'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => WorkersProvider()),
        ChangeNotifierProvider(
            create: (_) => CountryProvider()..fetchCountries()),
        ChangeNotifierProvider(create: (_) => TabsViewProvider()),
        ChangeNotifierProvider(create: (_) => BodyProvider()),
        ChangeNotifierProvider(
            create: (_) => ThemeProvider()), // Add ThemeProvider
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return DevicePreview(
            enabled: false,
            builder: (context) => MaterialApp(
              useInheritedMediaQuery: true,
              scaffoldMessengerKey: scaffoldMessengerKey,
              debugShowCheckedModeBanner: false,
              title: 'lastrasin1',
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              themeMode: themeProvider.themeMode,
              theme: ThemeData(
                primaryColor: const Color(0xFF004D40), // Golden Brown
                appBarTheme: const AppBarTheme(
                  titleTextStyle: TextStyle(color: Colors.white, fontSize: 24),
                  backgroundColor: Color(0xFF004D40), // Golden Brown
                ),
                scaffoldBackgroundColor: const Color(0xFFF7F3E9), // Light Beige
                colorScheme: ColorScheme.fromSwatch().copyWith(
                  primary: const Color(0xFF004D40), // Golden Brown
                  secondary: const Color(0xFF004D40), // Soft Gold
                  surface: const Color(0xFFF7F3E9), // Light Beige
                ),
                textTheme: const TextTheme(
                  bodyLarge: TextStyle(color: Color(0xFF4A3B29)), // Dark Brown
                  bodyMedium:
                      TextStyle(color: Color(0xFF004D40)), // Golden Brown
                  displayLarge: TextStyle(
                      color: Color(0xFFF0C05A),
                      fontSize: 32,
                      fontWeight: FontWeight.bold), // Soft Gold
                ),
                iconTheme: const IconThemeData(
                  color: Color(0xFF004D40), // Golden Brown
                ),
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004D40), // Soft Gold
                    foregroundColor: Colors.black, // Text color on buttons
                  ),
                ),
                inputDecorationTheme: const InputDecorationTheme(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFF004D40)), // Golden Brown
                  ),
                  labelStyle:
                      TextStyle(color: Color(0xFF004D40)), // Golden Brown
                ),
              ),
              darkTheme: ThemeData.dark().copyWith(
                primaryColor: const Color(0xFF004D40), // Darker Brown
                appBarTheme: const AppBarTheme(
                  titleTextStyle: TextStyle(color: Colors.white, fontSize: 24),
                  backgroundColor: Color(0xFF004D40), // Darker Brown
                ),
                scaffoldBackgroundColor: const Color(0xFF2C2C2C), // Dark Gray
                colorScheme: const ColorScheme.dark().copyWith(
                  primary: const Color(0xFF004D40), // Golden Brown
                  secondary: const Color(0xFF004D40), // Soft Gold
                  surface: const Color(0xFF2C2C2C), // Dark Gray
                ),
                textTheme: const TextTheme(
                  bodyLarge: TextStyle(color: Colors.white),
                  bodyMedium:
                      TextStyle(color: Color(0xFF004D40)), // Golden Brown
                  displayLarge: TextStyle(
                      color: Color(0xFFF0C05A),
                      fontSize: 32,
                      fontWeight: FontWeight.bold), // Soft Gold
                ),
                iconTheme: const IconThemeData(
                  color: Color(0xFF004D40), // Golden Brown
                ),
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF0C05A), // Soft Gold
                    foregroundColor: Colors.black, // Text color on buttons
                  ),
                ),
                inputDecorationTheme: const InputDecorationTheme(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFF004D40)), // Golden Brown
                  ),
                  labelStyle:
                      TextStyle(color: Color(0xFF004D40)), // Golden Brown
                ),
              ),
              home: const SplashScreen(),
            ),
          );
        },
      ),
    );
  }
}
