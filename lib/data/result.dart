class Result<T> {
  Result();

  factory Result.ok(T data, String msg) = Ok<T>;
  factory Result.error(int code, String msg) = Error;
}

class Ok<T> extends Result<T> {
  final T response;
  final String message;

  Ok(this.response, this.message);
}

class Error extends Result<Null> {
  final int code;
  final String message;

  Error(this.code, this.message);
}
