class App {
  static App? _app;

  App._();

  static App get instance => _app ??= App._();
}