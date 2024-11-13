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
      if (postId != null) 'post_id': postId,
      if (commentId != null) 'comment_id': commentId,
      if (description != null) 'description': description,
    };
  }
}
