enum AppRoute {
  home('/'),
  playground('/playground'),
  playgroundItem('/playground/item');

  const AppRoute(this.path);

  final String path;
}
