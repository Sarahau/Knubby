class RavelryProject {
  int patternId;
  String patternDesigner;

  bool free;

  // pattern details
  String name;
  String ravelryLink; // for the url
  String sizes_available;
  String notes; // pattern notes
  String photoUrl;

  // yarn details
  String gauge_description;
  List<String> needle_sizes;
  String yardage_description;
  String yarn_weight_description;

  RavelryProject({
    required this.patternId,
    required this.patternDesigner,
    required this.free,
    required this.name,
    required this.ravelryLink,
    required this.sizes_available,
    required this.notes,
    required this.photoUrl,
    required this.gauge_description,
    required this.needle_sizes,
    required this.yardage_description,
    required this.yarn_weight_description,
  });
}
