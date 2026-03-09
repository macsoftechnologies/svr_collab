class GetTestQuestionsModel {
  final int? status;
  final String? message;
  final List<Result>? result;

  GetTestQuestionsModel({
    this.status,
    this.message,
    this.result,
  });

  factory GetTestQuestionsModel.fromJson(Map<String, dynamic> json) {
    return GetTestQuestionsModel(
      status: json['status'],
      message: json['message'],
      result: json['result'] != null
          ? List<Result>.from(
              json['result'].map((v) => Result.fromJson(v)),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'result': result?.map((v) => v.toJson()).toList(),
    };
  }
}

class Result {
  final String? assignTestId;
  final String? testId;
  final String? courseId;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final String? test;
  final String? sortOrder;

  Result({
    this.assignTestId,
    this.testId,
    this.courseId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.test,
    this.sortOrder,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      assignTestId: json['assign_test_id'],
      testId: json['test_id'],
      courseId: json['course_id'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      test: json['test'],
      sortOrder: json['sort_order'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assign_test_id': assignTestId,
      'test_id': testId,
      'course_id': courseId,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'test': test,
      'sort_order': sortOrder,
    };
  }
}
