import 'package:rizka_thesis/pages/home_screen.dart';
import 'package:rizka_thesis/onboard/onboard_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';

class OnBoard extends StatefulWidget {
  @override
  _OnBoardState createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  int currentIndex = 0;
  PageController _pageController;
  List<OnboardModel> screens = <OnboardModel>[
    OnboardModel(
      img: 'assets/illustrations/1.png',
      text: "Hi, periksa jenis tanaman Anda \ndengan Aplikasi kami",
      desc:
          "Disini Anda bisa mengklasifikasi tanaman Aglaonema Anda hanya dengan memasukkan foto",
      bg: Colors.white,
      button: Color(0xFF4756DF),
    ),
    OnboardModel(
      img: 'assets/illustrations/2.png',
      text: "Anda dapat memeriksa \njenisnya.",
      desc:
          "Kalian hanya perlu memasukkan foto dan sistem kami akan memprediksi jenis tanaman Anda",
      bg: Color(0xFF4756DF),
      button: Colors.white,
    ),
    OnboardModel(
      img: 'assets/illustrations/3.png',
      text: "Menggunakan teknologi \nArtificial Intelligence",
      desc:
          "Sistem kami menggunakan Machine Learning untuk memprediksi jenis tanaman Anda",
      bg: Colors.white,
      button: Color(0xFF4756DF),
    ),
  ];

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  _storeOnboardInfo() async {
    print("Shared pref called");
    int isViewed = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoard', isViewed);
    print(prefs.getInt('onBoard'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: currentIndex % 2 == 0 ? kwhite : kblue,
      appBar: AppBar(
        backgroundColor: currentIndex % 2 == 0 ? kwhite : kblue,
        elevation: 0.0,
        actions: [
          TextButton(
            onPressed: () {
              _storeOnboardInfo();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => HomeScreen(camera: null,)));
            },
            child: Text(
              "Lewati",
              style: TextStyle(
                color: currentIndex % 2 == 0 ? kblack : kwhite,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: PageView.builder(
          itemCount: screens.length,
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
          itemBuilder: (_, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(screens[index].img),
                Container(
                  height: 10.0,
                  child: ListView.builder(
                    itemCount: screens.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 3.0),
                              width: currentIndex == index ? 25 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color:
                                    currentIndex == index ? kbrown : kbrown300,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ]);
                    },
                  ),
                ),
                Text(
                  screens[index].text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: index % 2 == 0 ? kblack : kwhite,
                  ),
                ),
                Text(
                  screens[index].desc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'Montserrat',
                    color: index % 2 == 0 ? kblack : kwhite,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    print(index);
                    if (index == screens.length - 1) {
                      await _storeOnboardInfo();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen(camera: null,)));
                    }

                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.bounceIn,
                    );
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                    decoration: BoxDecoration(
                        color: index % 2 == 0 ? kblue : kwhite,
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Selanjutnya",
                          style: TextStyle(
                              fontSize: 16.0,
                              color: index % 2 == 0 ? kwhite : kblue),
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Icon(
                          Icons.arrow_forward_sharp,
                          color: index % 2 == 0 ? kwhite : kblue,
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
