class PaymentDetails {
  String? paymentId;
  String? userId;
  String? courseId;
  String? name;
  String? courseName;
  String? courseImage;
  String? transactionId;
  String? amount;
  String? status;
  String? createdAt;

  PaymentDetails({
    this.paymentId,
    this.userId,
    this.courseId,
    this.name,
    this.courseName,
    this.courseImage,
    this.transactionId,
    this.amount,
    this.status,
    this.createdAt,
  });

  factory PaymentDetails.fromJson(Map<String, dynamic> json) {
    return PaymentDetails(
      paymentId: json['payment_id'],
      userId: json['user_id'],
      courseId: json['course_id'],
      name: json['name'],
      courseName: json['course_name'],
      courseImage: json['course_image'],
      transactionId: json['transaction_id'],
      amount: json['amount'],
      status: json['status'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment_id': paymentId,
      'user_id': userId,
      'course_id': courseId,
      'name': name,
      'course_name': courseName,
      'course_image': courseImage,
      'transaction_id': transactionId,
      'amount': amount,
      'status': status,
      'created_at': createdAt,
    };
  }
}
