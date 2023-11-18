import 'package:courseapp/model/curriculum_item.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../model/Course.dart';
import '../service/course_service.dart';

enum CourseStatus { loading, loaded, error }

class CourseProvider extends ChangeNotifier {
  final CourseService _courseService = CourseService();
  Course? _course;
  CourseStatus _status = CourseStatus.loading;
  CurriculumItem? _choosenCurriculum;
  String? _error;
   bool _isSebelumnya = false;

  bool get isSebelumnya => _isSebelumnya;
  CourseStatus get status => _status;

  CurriculumItem? get choosenCurriculum => _choosenCurriculum;

  Course? get course => _course; // Updated getter to return Course
  String? get error => _error;
  final Set<String> _completedCurriculumIds = {};

  Set<String> get completedCurriculumIds => _completedCurriculumIds;

  CourseProvider() {
    fetchCourseStatus();
  }

  Future<void> fetchCourseStatus() async {
    try {
      _status = CourseStatus.loading;
      _error = null; // Reset error in case of a retry
      notifyListeners();

      final result = await _courseService.getCourseStatus();
      _course = result; // Assign Course directly
      _choosenCurriculum = _course?.curriculum.firstWhere(
        (item) => item.type == "unit",
      );
      if (_course != null) {
        for (var curriculumItem in _course!.curriculum) {
          await isCurriculumDownloaded(curriculumItem);
        }
      }
      _status = CourseStatus.loaded;
      notifyListeners();
    } catch (e) {
      // Handle error
      if (kDebugMode) {
        print('Error fetching course status: $e');
      }
      _status = CourseStatus.error;
      _error = 'Failed to load course data. Please try again later.';
      notifyListeners();
    }
  }

  void chooseCurriculum(CurriculumItem curriculumItem) {
    _choosenCurriculum = curriculumItem;
    notifyListeners();
  }

  bool isCurriculumCompleted(String curriculumId) {
    return _completedCurriculumIds.contains(curriculumId);
  }

  void markCurriculumAsCompleted(dynamic curriculumId) {
    _completedCurriculumIds.add(curriculumId.toString());

    if (_choosenCurriculum?.id == curriculumId) {
      int currentIndex = _course?.curriculum.indexOf(_choosenCurriculum!) ?? 0;
      CurriculumItem? nextUnit;
      if (currentIndex < _course!.curriculum.length - 1) {
        nextUnit = _course?.curriculum.skip(currentIndex + 1).firstWhere(
              (item) => item.type == "unit",
            );
      }
      if (nextUnit != null) {
        _choosenCurriculum = nextUnit;
        notifyListeners();
      }
    }

    notifyListeners();
  }

  Future<void> downloadVideo(CurriculumItem curriculumItem) async {
    if (curriculumItem.offlineVideoLink == null) {
      if (kDebugMode) {
        print('Video URL is null');
      }
      return;
    }

    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final filePath = '${appDocDir.path}/${curriculumItem.id}.mp4';

      final response = await Dio().download(
        "https://static.videezy.com/system/resources/previews/000/008/452/original/Dark_Haired_Girl_Pensive_Looks_at_Camera.mp4",
        filePath,
        onReceiveProgress: (received, total) {
        },
      );

      if (kDebugMode) {
        print('Download response: $response');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Download error: $e');
      }
      rethrow;
    }
  }

  Future<bool> isCurriculumDownloaded(CurriculumItem curriculumItem) async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final filePath = '${appDocDir.path}/${curriculumItem.id}.mp4';
      final file = File(filePath);
      final foundItemIndex = _course?.curriculum.indexWhere(
            (item) => item.id == curriculumItem.id,
      );

      // Update the isDownloaded property if the item is found
      if (foundItemIndex != null && foundItemIndex >= 0) {
        file.exists().then((value) => _course!.curriculum[foundItemIndex].isDownloaded = value);
        notifyListeners();
      }
      return file.exists();

    } catch (e) {

      return false;
    }
  }

  Future<void> deleteDownloadedVideo(CurriculumItem curriculumItem) async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final filePath = '${appDocDir.path}/${curriculumItem.id}.mp4';
      final file = File(filePath);
      await file.delete();

    } catch (e) {
      if (kDebugMode) {
        print('Error deleting downloaded video: $e');
      }
    }
  }

  void changeBottomNavigationBarValue() {
    _isSebelumnya = !_isSebelumnya;
    notifyListeners();
  }
}
