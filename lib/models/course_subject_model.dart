class GetCourseBasedModel {
  final int? status;
  final String? message;
  final List<Result>? result;

  GetCourseBasedModel({
    this.status,
    this.message,
    this.result,
  });

  factory GetCourseBasedModel.fromJson(Map<String, dynamic> json) {
    return GetCourseBasedModel(
      status: json['status'] as int?,
      message: json['message'] as String?,
      result: json['result'] != null
          ? (json['result'] as List)
              .map((item) => Result.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'result': result?.map((item) => item.toJson()).toList(),
    };
  }
}

class Result {
  final String? assignTestId;
  final String? testId;
  final String? courseId;
  final String? subjectId;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final String? subjectName;

  Result({
    this.assignTestId,
    this.testId,
    this.courseId,
    this.subjectId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.subjectName,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      assignTestId: json['assign_test_id'] as String?,
      testId: json['test_id'] as String?,
      courseId: json['course_id'] as String?,
      subjectId: json['subject_id'] as String?,
      status: json['status'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      subjectName: json['subject_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assign_test_id': assignTestId,
      'test_id': testId,
      'course_id': courseId,
      'subject_id': subjectId,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'subject_name': subjectName,
    };
  }
}