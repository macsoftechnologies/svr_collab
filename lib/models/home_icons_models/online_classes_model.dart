// class OnlineClassesModel {
//   String? assignVideoId;
//   String? subjectId;
//   String? videoName;
//   Null videoImage;
//   String? videoId;
//   String? videoLink;
//   String? description;
//   String? status;
//   String? subjectName;
//   String? subjectImage;
//   String? sortOrder;
//
//   OnlineClassesModel(
//       {this.assignVideoId,
//         this.subjectId,
//         this.videoName,
//         this.videoImage,
//         this.videoId,
//         this.videoLink,
//         this.description,
//         this.status,
//         this.subjectName,
//         this.subjectImage,
//         this.sortOrder});
//
//   OnlineClassesModel.fromJson(Map<String, dynamic> json) {
//     assignVideoId = json['assign_video_id'];
//     subjectId = json['subject_id'];
//     videoName = json['video_name'];
//     videoImage = json['video_image'];
//     videoId = json['video_id'];
//     videoLink = json['video_link'];
//     description = json['description'];
//     status = json['status'];
//     subjectName = json['subject_name'];
//     subjectImage = json['subject_image'];
//     sortOrder = json['sort_order'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['assign_video_id'] = assignVideoId;
//     data['subject_id'] = subjectId;
//     data['video_name'] = videoName;
//     data['video_image'] = videoImage;
//     data['video_id'] = videoId;
//     data['video_link'] = videoLink;
//     data['description'] = description;
//     data['status'] = status;
//     data['subject_name'] = subjectName;
//     data['subject_image'] = subjectImage;
//     data['sort_order'] = sortOrder;
//     return data;
//   }
// }
class OnlineClassesModel {
  String? assignVideoId;
  String? subjectId;
  String? videoName;
  Null videoImage;
  String? videoId;
  String? videoLink;
  String? otherVideoLink; // Added field
  String? description;
  String? status;
  String? subjectName;
  String? subjectImage;
  String? sortOrder;

  OnlineClassesModel({
    this.assignVideoId,
    this.subjectId,
    this.videoName,
    this.videoImage,
    this.videoId,
    this.videoLink,
    this.otherVideoLink, // Added in constructor
    this.description,
    this.status,
    this.subjectName,
    this.subjectImage,
    this.sortOrder,
  });

  OnlineClassesModel.fromJson(Map<String, dynamic> json) {
    assignVideoId = json['assign_video_id'];
    subjectId = json['subject_id'];
    videoName = json['video_name'];
    videoImage = json['video_image'];
    videoId = json['video_id'];
    videoLink = json['video_link'];
    otherVideoLink = json['other_video_link']; // Added in fromJson
    description = json['description'];
    status = json['status'];
    subjectName = json['subject_name'];
    subjectImage = json['subject_image'];
    sortOrder = json['sort_order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['assign_video_id'] = assignVideoId;
    data['subject_id'] = subjectId;
    data['video_name'] = videoName;
    data['video_image'] = videoImage;
    data['video_id'] = videoId;
    data['video_link'] = videoLink;
    data['other_video_link'] = otherVideoLink; // Added in toJson
    data['description'] = description;
    data['status'] = status;
    data['subject_name'] = subjectName;
    data['subject_image'] = subjectImage;
    data['sort_order'] = sortOrder;
    return data;
  }
}