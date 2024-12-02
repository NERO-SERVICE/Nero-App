class VideoData {
  final String fileUrl;
  final String snapTm;
  final String vdoDesc;
  final String fileSz;
  final String fileTypeNm;
  final String operNm;
  final String fpsCnt;
  final int rowNum;
  final String fileNm;
  final String resolution;
  final String aggrpNm;
  final String frmeNo;
  final String imgFileNm;
  final String imgFileUrl;
  final String imgFileSn;
  final String fbctnYr;
  final String dataType;
  final String vdoLen;
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
      fileUrl: json['file_url'] ?? '',
      snapTm: json['snap_tm'].toString(),
      vdoDesc: json['vdo_desc'] ?? '',
      fileSz: json['file_sz'].toString(),
      fileTypeNm: json['file_type_nm'] ?? '',
      operNm: json['oper_nm'] ?? '',
      fpsCnt: json['fps_cnt'].toString(),
      rowNum: int.parse(json['row_num'].toString()),
      fileNm: json['file_nm'] ?? '',
      resolution: json['resolution'] ?? '',
      aggrpNm: json['aggrp_nm'] ?? '',
      frmeNo: json['frme_no'].toString(),
      imgFileNm: json['img_file_nm'] ?? '',
      imgFileUrl: json['img_file_url'] ?? '',
      imgFileSn: json['img_file_sn'].toString(),
      fbctnYr: json['fbctn_yr'] ?? '',
      dataType: json['data_type'] ?? '',
      vdoLen: json['vdo_len'] ?? '',
      lang: json['lang'] ?? '',
      trngNm: json['trng_nm'] ?? '',
      jobYmd: json['job_ymd'] ?? '',
      vdoTtlNm: json['vdo_ttl_nm'] ?? '',
    );
  }
}
