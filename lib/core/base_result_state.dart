sealed class BaseResultState<T> {}

class BaseResultStateInitial<T> extends BaseResultState<T> {}

class BaseResultStateLoading<T> extends BaseResultState<T> {}

class BaseResultStateSuccess<T> extends BaseResultState<T> {
  final T data;

  BaseResultStateSuccess(this.data);
}

class BaseResultStateError<T> extends BaseResultState<T> {
  final String errorMessage;

  BaseResultStateError(this.errorMessage);
}
