import 'package:courseapp/ui/tab_bar.dart';
import 'package:courseapp/ui/video_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helper/utls.dart';
import '../model/Course.dart';
import '../model/curriculum_item.dart';
import '../provider/course_provider.dart';

class MainSection extends StatelessWidget {
  final Course course;

  const MainSection(this.course, {super.key});

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);
    return CustomScrollView(
      slivers: [
        // SliverAppBar for the video
        SliverAppBar(
          expandedHeight: 300.0,
          flexibleSpace: FlexibleSpaceBar(
            background: ((courseProvider.choosenCurriculum!.onlineVideoLink ==
                            "" ||
                        courseProvider.choosenCurriculum!.onlineVideoLink ==
                            null) &&
                    (courseProvider.choosenCurriculum!.offlineVideoLink == "" ||
                        courseProvider.choosenCurriculum!.offlineVideoLink ==
                            null))
                ? Center(
                    child: Text(courseProvider.choosenCurriculum!.title),
                  )
                : VideoWidget(
                    curriculumItem: courseProvider.choosenCurriculum!,
                  ),
          ),
        ),
        SliverPersistentHeader(
          delegate: CustomTabBar(),
          pinned: true,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              CurriculumItem courseItem = course.curriculum[index];
              bool isCompleted = courseProvider
                  .isCurriculumCompleted(courseItem.id.toString());
              return courseItem.type == "section"
                  ? Container(
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(241, 242, 244, 1),
                          border: Border(
                              bottom: BorderSide(
                                  width: 0.5,
                                  color: Color.fromRGBO(233, 233, 235, 1)),
                              top: BorderSide(
                                  width: 0.5,
                                  color: Color.fromRGBO(233, 233, 235, 1)))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              courseItem.title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              formatMinutes(courseItem.duration),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        courseProvider.chooseCurriculum(courseItem);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color:
                                courseProvider.choosenCurriculum == courseItem
                                    ? const Color.fromRGBO(235, 246, 255, 1)
                                    : Colors.white,
                            border: const Border(
                              bottom:
                                  BorderSide(width: 0.5, color: Colors.grey),
                            )),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                Icon(
                                     ((courseItem.onlineVideoLink == "" ||
                                                 courseItem.onlineVideoLink ==
                                                     null) &&
                                             (courseItem.offlineVideoLink ==
                                                     "" ||
                                                 courseItem.offlineVideoLink ==
                                                     null))
                                         ? Icons.info
                                         : (isCompleted
                                             ? Icons.check_circle
                                             : Icons.play_circle),
                                     color: isCompleted
                                         ? const Color.fromRGBO(34, 187, 62, 1)
                                         : Colors.grey,
                                     size: 18,
                                   ),
                                        SizedBox(width: 10,),
                                        Flexible(
                                          child: Text(
                                            courseItem.title.contains('&#8211;')
                                                ? courseItem.title
                                                    .split(' &#8211; ')
                                                    .removeAt(1)
                                                : courseItem.title,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 28),
                                      child: Text(
                                        formatMinutes(courseItem.duration),
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              ((courseItem.onlineVideoLink == "" ||
                                          courseItem.onlineVideoLink == null) &&
                                      (courseItem.offlineVideoLink == "" ||
                                          courseItem.offlineVideoLink == null))
                                  ? const SizedBox()
                                  : ((!courseItem.isDownloaded)
                                      ? SizedBox(
                                width: 110,
                                        child: ElevatedButton(
                                            onPressed: () async {
                                              await showDownloadSnackBar(context,
                                                  courseProvider, courseItem);
                                              await courseProvider
                                                  .isCurriculumDownloaded(
                                                      courseItem);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              elevation: 1,
                                              minimumSize: Size.zero,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 6, horizontal: 14),
                                            ),
                                            child: const Text('Tonton Offline',style: TextStyle(
                                              fontSize: 12)),
                                          ),
                                      )
                                      : SizedBox(
                                width: 110,
                                        child: ElevatedButton(
                                            onPressed: () async {
                                              await showDeleteSnackBar(context,
                                                  courseProvider, courseItem);
                                              await courseProvider
                                                  .isCurriculumDownloaded(
                                                      courseItem);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              elevation: 1,
                                              backgroundColor: Colors.white,
                                              minimumSize: Size.zero,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 6, horizontal: 14),
                                            ),
                                            child: const Row(
                                              children: [
                                                Text(
                                                  "Tersimpan",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black),
                                                ),
                                                SizedBox(
                                                  width: 3,
                                                ),
                                                Icon(
                                                  Icons
                                                      .check_circle_outline_outlined,
                                                  size: 15,
                                                  color: Color.fromRGBO(
                                                      122, 179, 225, 1),
                                                )
                                              ],
                                            ),
                                          ),
                                      )),
                            ],
                          ),
                        ),
                      ),
                    );
            },
            childCount: course.curriculum.length,
          ),
        ),
      ],
    );
  }
}
