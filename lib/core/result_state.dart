sealed class ResultState<T> {}

class ResultStateInitial<T> extends ResultState<T> {}

class ResultStateLoading<T> extends ResultState<T> {}

class ResultStateSuccess<T> extends ResultState<T> {
  final T data;

  ResultStateSuccess(this.data);
}

class ResultStateError<T> extends ResultState<T> {
  final String errorMessage;

  ResultStateError(this.errorMessage);
}
