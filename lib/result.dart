import 'dart:io';

class Result {
  double confidence;
  String label;
  String message;
  String path;
  File imageURI;
  int index;

  Result({this.confidence, this.label, this.message, this.index, this.imageURI, this.path});
}
