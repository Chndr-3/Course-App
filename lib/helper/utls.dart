import 'package:flutter/material.dart';

import '../model/curriculum_item.dart';
import '../provider/course_provider.dart';

String formatMinutes(int durationInSeconds) {
  int hours = (durationInSeconds / 3600).floor();
  int minutes = ((durationInSeconds % 3600) / 60).floor();
  if (hours > 0) {
    return '$hours jam $minutes menit';
  } else {
    return '$minutes menit';
  }
}

Future<void> showDownloadSnackBar(BuildContext context,
    CourseProvider courseProvider, CurriculumItem courseItem) async {
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  try {
    scaffoldMessenger.showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Download'),
          ],
        ),
      ),
    );
    await courseProvider.downloadVideo(courseItem);
    scaffoldMessenger.showSnackBar(
      const SnackBar(
        content: Text('Download berhasil, anda dapat menonton video ini secara offline'),
        duration: Duration(seconds: 2),
      ),
    );
  } catch (e) {

    scaffoldMessenger.showSnackBar(
      const SnackBar(
        content: Text('Download gagal, pastikan jaringanmu baik'),
      ),
    );
  }
}

Future<void> showDeleteSnackBar(BuildContext context,
    CourseProvider courseProvider, CurriculumItem courseItem) async {
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  try {
    scaffoldMessenger.showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 1),
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Menghapus...'),
          ],
        ),
      ),
    );
    await courseProvider.deleteDownloadedVideo(courseItem);
    scaffoldMessenger.showSnackBar(
      const SnackBar(
        content: Text('Video berhasil dihapus dari penyimpananmu'),
        duration: Duration(seconds: 2),
      ),
    );
  } catch (e) {
    scaffoldMessenger.showSnackBar(
      const SnackBar(
        content: Text('Video gagal dihapus'),
      ),
    );
  }
}