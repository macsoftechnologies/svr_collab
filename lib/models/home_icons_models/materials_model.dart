class MaterialsModel {
  String? studyId;
  String? pdfName;
  String? pdfImage;
  String? courseId;
  String? pdfLink;
  String? description;
  String? status;
  String? subjectName;
  String? subjectId;
  String? subjectImage;

  MaterialsModel(
      {this.studyId,
        this.pdfName,
        this.pdfImage,
        this.courseId,
        this.pdfLink,
        this.description,
        this.status,
        this.subjectName,
        this.subjectId,
        this.subjectImage});

  MaterialsModel.fromJson(Map<String, dynamic> json) {
    studyId = json['study_id'];
    pdfName = json['pdf_name'];
    pdfImage = json['pdf_image'];
    courseId = json['course_id'];
    pdfLink = json['pdf_link'];
    description = json['description'];
    status = json['status'];
    subjectName = json['subject_name'];
    subjectId = json['subject_id'];
    subjectImage = json['subject_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['study_id'] = studyId;
    data['pdf_name'] = pdfName;
    data['pdf_image'] = pdfImage;
    data['course_id'] = courseId;
    data['pdf_link'] = pdfLink;
    data['description'] = description;
    data['status'] = status;
    data['subject_name'] = subjectName;
    data['subject_id'] = subjectId;
    data['subject_image'] = subjectImage;
    return data;
  }
}
