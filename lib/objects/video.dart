class UserDto {
  String id;
  String displayName;

  UserDto(this.id, this.displayName);

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      json['id'] as String,
      json['displayName'] as String,
    );
  }
}

class Video {
  String id;
  String title;
  String description;
  String? videoUrl;
  int? duration;
  UserDto user;

  Video(this.id, this.title, this.description, this.videoUrl, this.duration,
      this.user);

  factory Video.fromJson(dynamic json) {
    print("Decoding: $json");
    if (json is Map<String, dynamic>) {
      // Handle a single video object
      final videoFile = json['videoFile'] as Map<String, dynamic>;
      final user = UserDto.fromJson(json['user'] as Map<String, dynamic>);
      return Video(
        json['id'] as String,
        json['title'] as String,
        json['description'] as String,
        videoFile['videoUrl'] as String?,
        videoFile['duration'] as int?,
        user,
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
      return jsonList.map((json) {
        final videoFile = json['videoFile'] as Map<String, dynamic>;
        final user = UserDto.fromJson(json['user'] as Map<String, dynamic>);
        return Video(
          json['id'] as String,
          json['title'] as String,
          json['description'] as String,
          videoFile['videoUrl'] as String?,
          videoFile['duration'] as int?,
          user,
        );
      }).toList();
    } catch (error) {
      throw FormatException('Failed to parse video. $error');
    }
  }
}
