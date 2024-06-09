class CreateVideoDto {
  String id;
  String title;
  String description;
  String videoState;
  String sasUrl;

  CreateVideoDto(
      this.id, this.title, this.description, this.videoState, this.sasUrl);

  factory CreateVideoDto.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      // Handle a single video object
      final video = json['video'] as Map<String, dynamic>;
      return CreateVideoDto(
        video['id'] as String,
        video['title'] as String,
        video['description'] as String,
        video['videoState'] as String,
        json['sasUrl'] as String,
      );
    } else if (json is List<dynamic>) {
      // Handle an array of video objects
      throw const FormatException(
          'Failed: This is not a single CreateVideoDto object.');
    } else {
      // Throw an exception for unsupported JSON format
      throw const FormatException('Failed to load CreateVideoDto.');
    }
  }
}
