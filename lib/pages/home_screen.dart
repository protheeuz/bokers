import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rizka_thesis/constant.dart';
import 'package:flutter/material.dart';
import 'package:rizka_thesis/pages/result_page.dart';
import 'package:rizka_thesis/widgets/headers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rizka_thesis/widgets/home.dart';
import 'package:tflite/tflite.dart';

import '../result.dart';

class HomeScreen extends StatefulWidget {
  final CameraDescription camera;

  const HomeScreen({Key key, @required this.camera}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

final controller = ScrollController();
double offset = 0;
String result;
String path;
var confidence;
var label;
String message;

bool isResult = false;

File imageURI;

var percentageConfidence;

class _HomeScreenState extends State<HomeScreen> {
  String getFormattedDate() {
    // Mendapatkan tanggal saat ini
    DateTime now = DateTime.now();

    // Format tanggal dengan menggunakan package intl
    String formattedDate = DateFormat('EEEE, d MMMM y', 'id').format(now);

    return formattedDate;
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource
            .gallery); //(source: ImageSource.gallery); //(source: ImageSource.gallery);
    setState(
      () {
        imageURI = image;
        path = image.path;
      },
    );
  }


Future<void> sendDataToServer(String label, String imagePath) async {
  var request = http.MultipartRequest('POST', Uri.parse('https://riskalarasati.com/api/insert_data.php'));

  // Tambahkan file gambar ke dalam formulir multipart
  var imageFile = await http.MultipartFile.fromPath('file', imagePath);
  request.files.add(imageFile);

  // Tambahkan label sebagai bagian dari formulir
  request.fields['label'] = label;

  try {
    var response = await request.send();
    if (response.statusCode == 200) {
      print('Data berhasil dikirim ke server.');
    } else {
      print('Gagal mengirim data ke server. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Terjadi kesalahan: $error');
  }
}



  Future classifyImage() async {
    await Tflite.loadModel(
        model: "assets/model_unquant.tflite", labels: "assets/labels.txt");
    var output = await Tflite.runModelOnImage(path: path);
    var data = getResult(output);

    setState(
      () {
        result = data.toString();
        print(result);
        confidence = (data[0].confidence * 100).round().toString();
        label = data[0].label.toString();
      },
    );

    setState(() {
      result = data.toString();
      print(result);
      confidence = (data[0].confidence * 100).toStringAsFixed(2);
      label = data[0].label.toString();
      double confidenceInt = double.parse(confidence);
      if (confidenceInt >= 85 && confidenceInt > 60 && label == 'Red Legacy') {
        message = ' ';
      } else {
        message = " ";
      }
      if (confidenceInt >= 85 &&
          confidenceInt > 60 &&
          label == 'Lady Valentine') {
        message = ' ';
      } else {
        message = " ";
      }
      if (confidenceInt >= 85 && confidenceInt > 60 && label == 'Suksom') {
        message = ' ';
      } else {
        message = " ";
      }
      if (confidenceInt >= 85 && confidenceInt > 60 && label == 'Anjamani') {
        message = ' ';
      } else {
        message = " ";
      }
      if (confidenceInt >= 60 &&
          confidenceInt > 30 &&
          label == 'Bukan Aglaonema') {
        message = 'Sepertinya ini bukan tanaman Aglaonema..';
      }

      sendDataToServer(label, path);
    });

    isResult = true;
  }

  List<Result> getResult(List<dynamic> output) {
    List<Result> data = List();

    output.forEach((element) {
      Result item = Result(
          confidence: element['confidence'],
          label: element['label'],
          message: element['message'],
          imageURI: element['imageURI'],
          index: element['index']);
      data.add(item);
    });
    return data;
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MyHeader(
              image: "assets/icons/art1.svg",
              textTop: "Lebih tau",
              textBottom: "Tanaman Anda.",
              offset: offset,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Jenis tanaman",
                    style: kTitleTextstyle,
                  ),
                  SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SymptomCard(
                          image: "assets/images/anjamani.png",
                          title: "Anjamani",
                          isActive: true,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        SymptomCard(
                          image: "assets/images/ladyvalentine.png",
                          title: "Lady Valentine",
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        SymptomCard(
                          image: "assets/images/redlegacy.png",
                          title: "Red Legacy",
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        SymptomCard(
                          image: "assets/images/suksom.png",
                          title: "Suksom",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Langkah Pengecekan", style: kTitleTextstyle),
                  SizedBox(height: 25),
                  PreventCard(
                    text:
                        "> Unggah gambar tanaman \n> Sistem memproses foto \n> Hasil klasifikasi keluar",
                    image: "assets/images/2.png",
                    title: "Langkah proses",
                  ),
                  SizedBox(height: 50),
                  Text("Lakukan Pengecekan", style: kTitleTextstyle),
                  SizedBox(height: 20),
                  PreventCard(
                    text: "Unggah gambar menggunakan pemrosesan model YOLO",
                    image: "assets/images/upload1.png",
                    title: "Unggah foto",
                  ),
                  SizedBox(height: 30),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text("YOLO",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                            )),
                      ),
                      Text("SSD MobileNet",
                          style: GoogleFonts.poppins(fontSize: 16)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () => getImageFromGallery(),
                        child: UploadCard(
                          text: "YOLO",
                          image: "assets/images/5.png",
                          title: "Unggah foto di sini",
                        ),
                      ),
                      Container(
                        child: Text("|",
                            style: TextStyle(fontSize: 30, color: Colors.grey)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () async {
                          final cameras = await availableCameras();

                          final firstCamera = cameras.first;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Home(camera: firstCamera)));
                        },
                        child: UploadCard(
                          text: "SSD MobileNet",
                          image: "assets/images/5.png",
                          title: "Unggah foto di sini",
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 20),
                          imageURI == null
                              ? Text("Belum ada gambar")
                              : Image.file(imageURI,
                                  width: 200, height: 200, fit: BoxFit.cover),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 30, 0, 20),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0)),
                              ),
                              child: Text(
                                'Jalankan Pendeteksi',
                                style: TextStyle(color: Colors.white),
                                // selectionColor: Colors.white,
                              ),
                              onPressed: () async {
                                classifyImage();
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ResultsPage(
                                        confidence: confidence,
                                        label: label,
                                        message: message,
                                        // imageURI: imageURI,
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          isResult
                              ? Container(
                                  margin: EdgeInsets.fromLTRB(0, 30, 0, 20),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(30.0)),
                                    ),
                                    child: Text(
                                      'Hasil Deteksi',
                                      style: TextStyle(color: Colors.white),
                                      // selectionColor: Colors.white,
                                    ),
                                    onPressed: () async {
                                      classifyImage();
                                      setState(() {
                                        isResult = true;
                                      });
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return ResultsPage(
                                              confidence: confidence,
                                              label: label,
                                              message: message,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Text(
                                  "Klik untuk proses pendeteksian",
                                  style: GoogleFonts.raleway(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                          SizedBox(height: 50),
                          confidence == null
                              ? Text("-")
                              : Text(confidence + " %", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                          label == null ? Text("-") : Text("Aglaonema $label", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          message == null ? Text("-") : Text(message)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class UploadCard extends StatelessWidget {
  final String image;
  final String title;
  final String text;
  final String path;

  const UploadCard({
    Key key,
    this.image,
    this.title,
    this.text,
    this.path,
  }) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 100,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            Container(
              height: 136,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 9),
                    blurRadius: 24,
                    color: kShadowColor,
                  ),
                ],
              ),
            ),
            Image.asset(image),
            Positioned(
              left: 100,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                height: 100,
                width: MediaQuery.of(context).size.width - 170,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      title,
                      style: kTitleTextstyle.copyWith(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5),
                    Expanded(
                      child: Text(
                        text,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PreventCard extends StatelessWidget {
  final String image;
  final String title;
  final String text;
  const PreventCard({
    Key key,
    this.image,
    this.title,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 156,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            Container(
              height: 136,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 8),
                    blurRadius: 24,
                    color: kShadowColor,
                  ),
                ],
              ),
            ),
            Image.asset(image),
            Positioned(
              left: 135,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                height: 136,
                width: MediaQuery.of(context).size.width - 170,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      title,
                      style: kTitleTextstyle.copyWith(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5),
                    Expanded(
                      child: Text(
                        text,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SymptomCard extends StatelessWidget {
  final String image;
  final String title;
  final bool isActive;
  const SymptomCard({
    Key key,
    this.image,
    this.title,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          isActive
              ? BoxShadow(
                  offset: Offset(0, 10),
                  blurRadius: 20,
                  color: kActiveShadowColor,
                )
              : BoxShadow(
                  offset: Offset(0, 3),
                  blurRadius: 6,
                  color: kShadowColor,
                ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Image.asset(image, height: 90),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
