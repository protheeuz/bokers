class Detection {
  final String timestamp;
  final String plantType;
  final String message;
  final String imagePath;

  Detection({this.timestamp, this.plantType, this.message, this.imagePath});

  factory Detection.fromJson(Map<String, dynamic> json) {
    return Detection(
      timestamp: json['timestamp'],
      plantType: json['plantType'],
      message: json['message'],
      imagePath: json['imagePath'],
    );
  }
}