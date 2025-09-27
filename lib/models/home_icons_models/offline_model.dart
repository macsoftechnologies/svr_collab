class OfflineModel {
  String? offlineVideoId;
  String? offlineVideoName;
  String? offlineVideoImage;
  String? offlineVideo;
  String? subjectId;
  String? description;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? sortOrder;
  String? subjectName;
  String? subjectImage;

  OfflineModel({
    this.offlineVideoId,
    this.offlineVideoName,
    this.offlineVideoImage,
    this.offlineVideo,
    this.subjectId,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.sortOrder,
    this.subjectName,
    this.subjectImage,
  });

  // From JSON to Dart object
  OfflineModel.fromJson(Map<String, dynamic> json)
      : offlineVideoId = json['offline_video_id'],
        offlineVideoName = json['offline_video_name'],
        offlineVideoImage = json['offline_video_image'],
        offlineVideo = json['offline_video'],
        subjectId = json['subject_id'],
        description = json['description'],
        status = json['status'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'],
        sortOrder = json['sort_order'],
        subjectName = json['subject_name'],
        subjectImage = json['subject_image'];

  // From Dart object to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['offline_video_id'] = offlineVideoId;
    data['offline_video_name'] = offlineVideoName;
    data['offline_video_image'] = offlineVideoImage;
    data['offline_video'] = offlineVideo;
    data['subject_id'] = subjectId;
    data['description'] = description;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['sort_order'] = sortOrder;
    data['subject_name'] = subjectName;
    data['subject_image'] = subjectImage;
    return data;
  }
}
