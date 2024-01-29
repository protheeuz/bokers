import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rizka_thesis/services/tensorflow-service.dart';

class Recognition extends StatefulWidget {
  Recognition({Key key, @required this.ready}) : super(key: key);

  // indicates if the animation is finished to start streaming (for better performance)
  final bool ready;

  @override
  _RecognitionState createState() => _RecognitionState();
}

// to track the subscription state during the lifecicle of the component
enum SubscriptionState { Active, Done }

class _RecognitionState extends State<Recognition> {
  // current list of recognition
  List<dynamic> _currentRecognition = [];

  // listens the changes in tensorflow recognitions
  StreamSubscription _streamSubscription;

  // tensorflow service injection
  TensorflowService _tensorflowService = TensorflowService();

  @override
  void initState() {
    super.initState();

    // starts the streaming to tensorflow results
    _startRecognitionStreaming();
  }

  _startRecognitionStreaming() {
    if (_streamSubscription == null) {
      _streamSubscription =
          _tensorflowService.recognitionStream.listen((recognition) {
        if (recognition != null) {
          setState(() {
            _currentRecognition = recognition;
          });
        } else {
          _currentRecognition = [];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.symmetric(
                    horizontal: BorderSide(color: Color(0xFFD8D8D8), width: 0.5),
                  ),
                  color: Color(0xFFFFFFFF),
                ),
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: widget.ready
                      ? <Widget>[
                          // shows recognition title
                          _titleWidget(),

                          _contentWidget(),
                        ]
                      : <Widget>[],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _titleWidget() {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 20, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Deteksi Realtime",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }

  Widget _contentWidget() {
    var _width = MediaQuery.of(context).size.width;
    var _padding = 20.0;
    var _labelWitdth = 150.0;
    var _labelConfidence = 30.0;
    var _barWitdth = _width - _labelWitdth - _labelConfidence - _padding * 2.0;

    if (_currentRecognition.length > 0) {
      return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        height: 150,
        child: ListView.builder(
          itemCount: _currentRecognition.length,
          itemBuilder: (context, index) {
            if (_currentRecognition.length > index) {
              return Container(
                height: 40,
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: _padding, right: _padding),
                      width: _labelWitdth,
                      child: Text(
                        _currentRecognition[index]['label'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      width: _barWitdth,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.transparent,
                        value: _currentRecognition[index]['confidence'],
                      ),
                    ),
                    Container(
                      width: _labelConfidence,
                      child: Text(
                        (_currentRecognition[index]['confidence'] * 100)
                                .toStringAsFixed(0) +
                            '%',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              );
            } else {
              return Container(
              );
            }
          },
        ),
      );
    } else {
      return Text('');
    }
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }
}
