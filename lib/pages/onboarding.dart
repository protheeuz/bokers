import 'package:flutter/material.dart';
// import 'package:flutter/introduction_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController _pageController;

  int _pageIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  itemCount: demo_data.length,
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _pageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) => OnBoardContent(
                    image: demo_data[index].image,
                    title: demo_data[index].title,
                    description: demo_data[index].description,
                  ),
                ),
              ),
              Row(
                children: [
                  ...List.generate(
                    demo_data.length,
                    (index) => Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: DotIndicator(
                        isActive: index == _pageIndex,
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 55,
                    width: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        _pageController.nextPage(
                            duration: Duration(
                              milliseconds: 300,
                            ),
                            curve: Curves.ease);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                      ),
                      child: Image.asset(
                        "assets/icons/right-arrow.png",
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // onDone: () => onDone(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    Key key,
    this.isActive = false,
  }) : super(key: key);

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: isActive ? 12 : 4,
      width: 4,
      decoration: BoxDecoration(
        color:
            isActive ? Colors.greenAccent : Colors.greenAccent.withOpacity(0.4),
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    );
  }
}

class OnBoard {
  final String image, title, description;

  OnBoard({
    this.image,
    this.title,
    this.description,
  });
}

final List<OnBoard> demo_data = [
  OnBoard(
    image: "assets/illustrations/1.png",
    title: "Hi, periksa jenis tanaman Anda \ndengan Aplikasi kami",
    description:
        "Disini Anda bisa mengklasifikasi tanaman Aglaonema Anda hanya dengan memasukkan foto",
  ),
  OnBoard(
    image: "assets/illustrations/2.png",
    title: "Anda dapat memeriksa \njenisnya",
    description:
        "Kalian hanya perlu memasukkan foto dan sistem kami akan memprediksi jenis tanaman Anda",
  ),
  OnBoard(
    image: "assets/illustrations/3.png",
    title: "Menggunakan teknologi \nArtificial Intelligence",
    description:
        "Sistem kami menggunakan Machine Learning untuk memprediksi jenis tanaman Anda",
  ),
];

class OnBoardContent extends StatelessWidget {
  const OnBoardContent({
    Key key,
    this.image,
    this.title,
    this.description,
  }) : super(key: key);

  final String image, title, description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Image.asset(
          image,
          height: 180,
        ),
        const Spacer(),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headline5
              .copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          description,
          textAlign: TextAlign.center,
        ),
        const Spacer(),
      ],
    );
  }
}
