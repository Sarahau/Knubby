class Project implements Comparable<Project> {
  final String title;
  final String maker;
  String imageUrl;
  double progressRate;
  int counterCount;
  DateTime startTime;
  DateTime? finishTime;

  Project(
    this.title,
    this.maker,
    this.imageUrl,
    this.startTime, {
    this.progressRate = 0.0,
    this.counterCount = 0,
    this.finishTime,
  });

  Project.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        maker = json['maker'],
        imageUrl = json['imageUrl'],
        progressRate = json['progressRate'],
        counterCount = json['counterCount'],
        startTime = json['startTime'].toDate(),
        finishTime = json['finishTime']?.toDate();

  Map<String, dynamic> toJson() => {
        'title': title,
        'maker': maker,
        'imageUrl': imageUrl,
        'progressRate': progressRate,
        'counterCount': counterCount,
        'startTime': startTime,
        'finishTime': finishTime,
      };

  void updateProgressRate(double newRate) {
    progressRate = newRate;
  }

  void updateCounterCount(int newCount) {
    counterCount = newCount;
  }

  void updateFinishTime(DateTime finishTime) {
    this.finishTime = finishTime;
  }

  String prettyPrintDate(DateTime time) {
    return '${time.month}/${time.day}/${time.year}';
  }

  @override
  int compareTo(Project other) {
    return startTime.compareTo(other.startTime);
  }
}
