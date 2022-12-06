import 'project.dart';

class KnubbyUser {
  final String name;
  final String userId;
  final String email;
  final String imageUrl;
  final Map<String, Project> projects;
  late int inProgressProjects;
  late int completedProjects;

  KnubbyUser({
    required this.name,
    required this.userId,
    required this.email,
    required this.imageUrl,
    required this.projects,
  });
}
