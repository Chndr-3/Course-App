
import 'package:courseapp/provider/course_provider.dart';
import 'package:courseapp/ui/course_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CourseApp());
}

class CourseApp extends StatelessWidget {
  const CourseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CourseProvider(),
      child: MaterialApp(
        title: 'Arkademi Test',
        theme: ThemeData(
          textTheme: GoogleFonts.nunitoTextTheme(
            Theme.of(context).textTheme,
          ),
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              titleTextStyle: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
          useMaterial3: false,
          tabBarTheme: const TabBarTheme(
              labelColor: Colors.black, unselectedLabelColor: Colors.grey),
          primaryColor: Colors.black,
        ),
        home: // Use the Google Sans font
            const CourseScreen(),
      ),
    );
  }
}
