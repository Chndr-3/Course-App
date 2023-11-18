class CurriculumItem {
  int key;
  dynamic id;
  String type;
  String title;
  int duration;
  String content;
  int status;
  List<dynamic> meta;
  String? onlineVideoLink;
  String? offlineVideoLink;
  bool isDownloaded = false;

  CurriculumItem({
    required this.key,
    required this.id,
    required this.type,
    required this.title,
    required this.duration,
    required this.content,
    required this.status,
    required this.meta,
    this.onlineVideoLink,
    this.offlineVideoLink,
    required this.isDownloaded
  });

  factory CurriculumItem.fromJson(Map<String, dynamic> json) {
    return CurriculumItem(
      key: json['key'] as int? ?? 0, // Default value if 'key' is null
      id: json['id'],
      type: json['type'],
      title: json['title'],
      duration: json['duration'] as int? ?? 0, // Default value if 'duration' is null
      content: json['content'],
      status: json['status'] as int? ?? 0, // Default value if 'status' is null
      meta: json['meta'],
      onlineVideoLink: json['online_video_link'],
      offlineVideoLink: json['offline_video_link'],
      isDownloaded: false
    );
  }
}