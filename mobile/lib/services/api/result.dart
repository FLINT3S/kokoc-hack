class Result<T> {
  final T? data;
  final dynamic error;

  Result._(this.data, this.error);

  factory Result.success(T data) => Result._(data, null);

  factory Result.error(dynamic error) => Result._(null, error);

  bool get isSuccess => data != null;
}
