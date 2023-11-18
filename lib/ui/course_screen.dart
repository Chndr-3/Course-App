
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../model/Course.dart';
import '../provider/course_provider.dart';
import 'bottom_navigation.dart';
import 'main_section.dart';

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);
    final Course? course = courseProvider.course;
    Widget body;
    switch (courseProvider.status) {
      case CourseStatus.loading:
        body = const Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: CircularProgressIndicator()),
          ],
        );
        break;
      case CourseStatus.loaded:
        body = MainSection(course!);
        break;
      case CourseStatus.error:
        body = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Center(child: Text(courseProvider.error ?? 'Unknown error')),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  courseProvider.fetchCourseStatus();
                },
              ),
            ]);
        break;
      default:
        body = Container();
        break;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => {}),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(course?.courseName ?? "Judul Kursus"),
            CircularPercentIndicator(
              lineWidth: 4.0,
              percent: double.parse(course?.progress ?? "0") / 100,
              center: Text(
                "${course?.progress ?? "0"}%",
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
              backgroundColor: const Color.fromRGBO(234, 235, 238, 1),
              progressColor: const Color.fromRGBO(104, 205, 114, 1),
              radius: 20,
            )
          ],
        ),
      ),
      body: body,
      bottomNavigationBar:  BottomNavigation(courseProvider: courseProvider,)
    );
  }
}



