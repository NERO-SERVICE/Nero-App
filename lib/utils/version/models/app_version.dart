class AppVersion {
  final String platform;
  final String version;
  final String storeUrl;

  AppVersion({
    required this.platform,
    required this.version,
    required this.storeUrl,
  });

  factory AppVersion.fromJson(Map<String, dynamic> json) {
    return AppVersion(
      platform: json['platform'],
      version: json['version'],
      storeUrl: json['store_url'],
    );
  }
}