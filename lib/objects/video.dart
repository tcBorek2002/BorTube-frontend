class Video {
  int id;
  String title;
  int duration;

  Video(this.id, this.title, this.duration);

  factory Video.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      // Handle a single video object
      return Video(
        json['id'] as int,
        json['title'] as String,
        json['duration'] as int,
      );
    } else if (json is List<dynamic>) {
      // Handle an array of video objects
      throw const FormatException('Failed: This is not a single Video object.');
    } else {
      // Throw an exception for unsupported JSON format
      throw const FormatException('Failed to load video.');
    }
  }

  static List<Video> fromJsonList(List<dynamic> jsonList) {
    try {
      // Process the list of video objects
      final List<Video> videos = jsonList
          .map((json) => Video(
                json['id'] as int,
                json['title'] as String,
                json['duration'] as int,
              ))
          .toList();

      return videos;
    } catch (error) {
      throw FormatException('Failed to parse video. $error'); 
    }
  }
}
