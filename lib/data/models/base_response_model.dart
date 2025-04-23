class BaseResponseModel<T> {
  final String message;
  final bool error;
  final int status;
  final T? data;

  BaseResponseModel({
    required this.message,
    required this.error,
    required this.status,
    this.data,
  });

  factory BaseResponseModel.fromJson(Map<String, dynamic> json) {
    return BaseResponseModel<T>(
      message: json['message'] as String,
      error: json['error'] as bool,
      status: json['status'] is int ? json['status'] : 200,
      data: json['data'] is Map ? json['data']['token'] : null,
    );
  }
}