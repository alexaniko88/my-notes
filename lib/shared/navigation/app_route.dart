enum AppRoute {
  home('/'),
  playground('/playground'),
  playgroundItem('/playground/item'),
  note('/notes/:id');

  const AppRoute(this.path);

  final String path;
}
