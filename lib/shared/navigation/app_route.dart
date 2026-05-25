enum AppRoute {
  auth('/'),
  home('/home'),
  playground('/playground'),
  playgroundItem('/playground/item'),
  note('/notes');

  const AppRoute(this.path);

  final String path;
}
