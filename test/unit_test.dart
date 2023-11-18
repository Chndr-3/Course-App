import 'package:courseapp/model/curriculum_item.dart';
import 'package:courseapp/provider/course_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
class MockPathProvider extends Mock implements PathProviderPlatform {}
void main() {

  group('CourseProvider', ()
  {
    late CourseProvider courseProvider;

    setUp(() {
      WidgetsFlutterBinding.ensureInitialized();
      courseProvider = CourseProvider();
    });

    test('Fetch course status', () async {
      await courseProvider.fetchCourseStatus();
      expect(courseProvider.status, equals(CourseStatus.loaded),
          reason: 'Failed to load course status');
      expect(courseProvider.course, isNotNull);
    });

    test('Choose curriculum', () {
      final curriculumItem = CurriculumItem(
        key: 1,
        id: '1',
        type: 'unit',
        title: 'Test Unit',
        duration: 60,
        content: 'Test Content',
        status: 1,
        meta: [],
        onlineVideoLink: 'https://example.com/video.mp4',
        offlineVideoLink: 'path/to/offline/video.mp4',
        isDownloaded: false,
      );

      courseProvider.chooseCurriculum(curriculumItem);
      expect(courseProvider.choosenCurriculum, equals(curriculumItem));
    });

    test('Mark curriculum as completed', () {
      final curriculumItem = CurriculumItem(
        key: 1,
        id: '1',
        type: 'unit',
        title: 'Test Unit',
        duration: 60,
        content: 'Test Content',
        status: 1,
        meta: [],
        onlineVideoLink: 'https://example.com/video.mp4',
        offlineVideoLink: 'path/to/offline/video.mp4',
        isDownloaded: false,
      );

      courseProvider.markCurriculumAsCompleted('1');
      expect(courseProvider.completedCurriculumIds, contains('1'));
      courseProvider.chooseCurriculum(curriculumItem);
      expect(courseProvider.choosenCurriculum, isNotNull);
    });
  });
}