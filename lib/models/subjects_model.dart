class SubjectsModel {
  String? assignId;
  String? courseId;
  String? subjectId;
  String? subjectName;
  String? subjectImage;

  SubjectsModel(
      {this.assignId,
        this.courseId,
        this.subjectId,
        this.subjectName,
        this.subjectImage});

  SubjectsModel.fromJson(Map<String, dynamic> json) {
    assignId = json['assign_id'];
    courseId = json['course_id'];
    subjectId = json['subject_id'];
    subjectName = json['subject_name'];
    subjectImage = json['subject_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['assign_id'] = this.assignId;
    data['course_id'] = this.courseId;
    data['subject_id'] = this.subjectId;
    data['subject_name'] = this.subjectName;
    data['subject_image'] = this.subjectImage;
    return data;
  }
}
