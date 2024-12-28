import 'package:nero_app/develop/health/model/video_data.dart';

class PaginatedVideoData {
  final int count;
  final String? next;
  final String? previous;
  final List<VideoData> results;

  PaginatedVideoData({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PaginatedVideoData.fromJson(Map<String, dynamic> json) {
    return PaginatedVideoData(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List)
          .map((videoJson) => VideoData.fromJson(videoJson))
          .toList(),
    );
  }
}