enum AppRoute {
  auth('/'),
  home('/home'),
  editLabels('/labels/edit'),
  playground('/playground'),
  playgroundItem('/playground/item'),
  note('/notes'),
  noteLabels('/notes/labels');

  const AppRoute(this.path);

  final String path;
}
