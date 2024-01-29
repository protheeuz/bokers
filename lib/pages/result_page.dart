
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:rizka_thesis/painters/ListPainters.dart';

import 'package:google_fonts/google_fonts.dart';


class ResultsPage extends StatefulWidget {
  String confidence, label, message, imageURI, path;

  // bool isResult;

  ResultsPage(
      {this.confidence, this.label, this.message, this.imageURI, this.path});
  static final style = TextStyle(
    fontSize: 20,
    fontFamily: "Poppins",
    fontWeight: FontWeight.w400,
  );

  // String get path => null;

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  var height;
  var width;
  String path;
  String imageURI;
  // var datenow;
  // String text = "$confidence";

  Future getImage() async {
    setState(() {
      File image;
      imageURI = image as String;
      path = image.path;
    });
  }

  List<String> listImage = [
    'assets/images/anjamani-exp.jpg',
    'assets/images/ladyval-exp.jpg',
    'assets/images/redleg-exp.jpg',
    'assets/images/suksom-exp.jpg',
  ];

  

  @override
  Widget build(BuildContext context) {
    String label = widget.label;
    String message = widget.message;
    String imageURI = widget.imageURI;


    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          backgroundColor: Colors.deepPurple,
          // automaticallyImplyLeading: false,
          elevation: 0,
          title: Row(
            children: <Widget>[Text("Riska's Florist SmartApps")],
          ),
          // Navigator.pop(context, true);
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.white, Colors.blueGrey],
            ),
          ),
          child: CustomPaint(
            painter: ListPainter(color1: Colors.deepPurple),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(),
                Text(
                  "Hari & Tanggal: ${DateFormat('EEEE, d MMMM y', 'id_ID').format(DateTime.now())}",
                  style: GoogleFonts.raleway(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurpleAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Jenis tanaman: Aglaonema $label",
                  style: GoogleFonts.raleway(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurpleAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
                // Text(
                //   "Harga: $message",
                //   style: GoogleFonts.raleway(
                //     fontSize: 20.0,
                //     fontWeight: FontWeight.w600,
                //     color: Colors.deepPurpleAccent,
                //   ),
                //   textAlign: TextAlign.center,
                // ),
                SizedBox(height: 15),
                imageURI == null
                    ? Text("Gagal mengunduh gambar")
                    : Image.file(
                        File(imageURI),
                        width: 250,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                SizedBox(
                  height: 20.0,
                )
              ],
            ),
          ),
        ),
        // floatingActionButton: FloatingActionButton(onPressed: ()),
      ),
    
    );
  }
}