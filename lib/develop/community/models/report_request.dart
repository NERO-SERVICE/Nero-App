class ReportRequest {
  final String reportType;
  final int? postId;
  final int? commentId;
  final String? description;

  ReportRequest({
    required this.reportType,
    this.postId,
    this.commentId,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'report_type': reportType,
      'post_id': postId,
      'comment_id': commentId,
      'description': description,
    };
  }
}
