
import 'package:chewie/chewie.dart';
import 'package:courseapp/model/Course.dart';
import 'package:courseapp/model/curriculum_item.dart';
import 'package:courseapp/provider/course_provider.dart';
import 'package:courseapp/ui/bottom_navigation.dart';
import 'package:courseapp/ui/course_screen.dart';
import 'package:courseapp/ui/main_section.dart';
import 'package:courseapp/ui/tab_bar.dart';
import 'package:courseapp/ui/video_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
class MockCourseProvider extends Mock implements CourseProvider {}

void main() {
  final courseProvider = CourseProvider();
  testWidgets('VideoWidget widget test', (WidgetTester tester) async {

    final curriculumItem = CurriculumItem(
      key: 1,
      id: '123',
      type: 'video',
      title: 'Sample Video',
      duration: 60,
      content: 'Video Content',
      status: 1,
      meta: [],
      onlineVideoLink: 'https://example.com/sample.mp4',
      offlineVideoLink: null,
      isDownloaded: false,
    );

    await tester.pumpWidget(
      ChangeNotifierProvider<CourseProvider>(
        create: (context) => courseProvider,
        child: MaterialApp(
          home: Scaffold(
            body: VideoWidget(curriculumItem: curriculumItem),
          ),
        ),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byType(Chewie), findsOneWidget);
  });

  testWidgets('BottomNavigation widget test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BottomNavigation(
            courseProvider: CourseProvider(),
          ),
        ),
      ),
    );
    expect(find.text('Sebelumnya'), findsOneWidget);
    expect(find.text('Selanjutnya'), findsOneWidget);
    expect(courseProvider.isSebelumnya, isFalse);
  });
  testWidgets('CustomTabBar widget test', (WidgetTester tester) async {

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                delegate: CustomTabBar(),
                pinned: true,
              ),
            ],
          ),
        ),
      ),
    );
    expect(find.text('Kurikulum'), findsOneWidget);
    expect(find.text('Ikhtisar'), findsOneWidget);
    expect(find.text('Lampiran'), findsOneWidget);
  });

}