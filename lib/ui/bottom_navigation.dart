import 'package:flutter/material.dart';
import '../provider/course_provider.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key, required this.courseProvider});

  final CourseProvider courseProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      height: 60,
   
      child:Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  courseProvider.changeBottomNavigationBarValue();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.keyboard_double_arrow_left_outlined, color: (!courseProvider.isSebelumnya) ? Colors.black : Colors.grey),
                    Text(
                      "Sebelumnya",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: (!courseProvider.isSebelumnya) ? Colors.black : Colors.grey
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const VerticalDivider(),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  courseProvider.changeBottomNavigationBarValue();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Selanjutnya",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: (courseProvider.isSebelumnya) ? Colors.black : Colors.grey
                      ),
                    ),
                    Icon(Icons.keyboard_double_arrow_right_outlined, color: (courseProvider.isSebelumnya) ? Colors.black : Colors.grey),
                  ],
                ),
              ),
            ),
          ],
        ),

    );
  }
}