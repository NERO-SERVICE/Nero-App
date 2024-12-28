class VideoData {
  final String fileUrl;
  final double snapTm;
  final String vdoDesc;
  final int fileSz;
  final String fileTypeNm;
  final String operNm;
  final double fpsCnt;
  final int rowNum;
  final String fileNm;
  final String resolution;
  final String aggrpNm;
  final int frmeNo;
  final String imgFileNm;
  final String imgFileUrl;
  final int imgFileSn;
  final String fbctnYr;
  final String dataType;
  final int vdoLen;
  final String lang;
  final String trngNm;
  final String jobYmd;
  final String vdoTtlNm;

  VideoData({
    required this.fileUrl,
    required this.snapTm,
    required this.vdoDesc,
    required this.fileSz,
    required this.fileTypeNm,
    required this.operNm,
    required this.fpsCnt,
    required this.rowNum,
    required this.fileNm,
    required this.resolution,
    required this.aggrpNm,
    required this.frmeNo,
    required this.imgFileNm,
    required this.imgFileUrl,
    required this.imgFileSn,
    required this.fbctnYr,
    required this.dataType,
    required this.vdoLen,
    required this.lang,
    required this.trngNm,
    required this.jobYmd,
    required this.vdoTtlNm,
  });

  factory VideoData.fromJson(Map<String, dynamic> json) {
    return VideoData(
      fileUrl: json['file_url']?.toString() ?? '',
      snapTm: (json['snap_tm'] as num?)?.toDouble() ?? 0.0,
      vdoDesc: json['vdo_desc']?.toString() ?? '',
      fileSz: json['file_sz'] != null ? int.parse(json['file_sz'].toString()) : 0,
      fileTypeNm: json['file_type_nm']?.toString() ?? '',
      operNm: json['oper_nm']?.toString() ?? '',
      fpsCnt: (json['fps_cnt'] as num?)?.toDouble() ?? 0.0,
      rowNum: json['row_num'] != null ? int.parse(json['row_num'].toString()) : 0,
      fileNm: json['file_nm']?.toString() ?? '',
      resolution: json['resolution']?.toString() ?? '',
      aggrpNm: json['aggrp_nm']?.toString() ?? '',
      frmeNo: json['frme_no'] != null ? int.parse(json['frme_no'].toString()) : 0,
      imgFileNm: json['img_file_nm']?.toString() ?? '',
      imgFileUrl: json['img_file_url']?.toString() ?? '',
      imgFileSn: json['img_file_sn'] != null ? int.parse(json['img_file_sn'].toString()) : 0,
      fbctnYr: json['fbctn_yr']?.toString() ?? '',
      dataType: json['data_type']?.toString() ?? '',
      vdoLen: json['vdo_len'] != null ? int.parse(json['vdo_len'].toString()) : 0,
      lang: json['lang']?.toString() ?? '',
      trngNm: json['trng_nm']?.toString() ?? '',
      jobYmd: json['job_ymd']?.toString() ?? '',
      vdoTtlNm: json['vdo_ttl_nm']?.toString() ?? '',
    );
  }
}