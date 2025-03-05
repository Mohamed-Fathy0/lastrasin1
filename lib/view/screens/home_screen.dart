import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lastrasin1/view/screens/auth_screens/login_screen.dart';
import 'package:lastrasin1/view/screens/countries_screen.dart';
import 'package:lastrasin1/view/screens/form_order_screen.dart';
import 'package:lastrasin1/view/screens/packegs_rent.dart';
import 'package:lastrasin1/view/screens/rent_recruit_screen.dart';
import 'package:lastrasin1/view/screens/events_screen.dart';
import 'package:lastrasin1/view/screens/visit_packegs_screen.dart';
import 'package:lastrasin1/view/widgets/category_card.dart';
import 'package:lastrasin1/view/widgets/my_drawer.dart';
import 'package:lastrasin1/viewmodel/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> imgList = [
    'assets/slide1.png',
    'assets/slide2.png',
    'assets/slide3.png',
  ];

  int _current = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final User? firebaseUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        backgroundColor:
            themeProvider.isDarkMode ? const Color(0xFF004D40) : Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "رصين",
              style: TextStyle(
                  color: Color(0xFF004D40),
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: CustomPaint(
                size: Size(100, MediaQuery.of(context).size.height),
                painter: CurvedSidePainter(
                  color: Colors.blue.withOpacity(0.3),
                  reverse: false,
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: CustomPaint(
                size: Size(100, MediaQuery.of(context).size.height),
                painter: CurvedSidePainter(
                  color: const Color(0xFF004D40),
                  reverse: true,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    CarouselSlider(
                      carouselController: _carouselController,
                      options: CarouselOptions(
                        autoPlay: true,
                        aspectRatio: 2.0,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        },
                      ),
                      items: imgList
                          .map((item) => Container(
                                margin: const EdgeInsets.all(5.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(
                                    item,
                                    fit: BoxFit.cover,
                                    width: 1000.0,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    Positioned(
                      bottom: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: imgList.asMap().entries.map((entry) {
                          return GestureDetector(
                            onTap: () =>
                                _carouselController.animateToPage(entry.key),
                            child: Container(
                              width: 12.0,
                              height: 12.0,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _current == entry.key
                                    ? const Color(0xFF004D40)
                                    : Colors.black.withOpacity(0.5),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: _buildCategoryGrid(context, firebaseUser),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(BuildContext context, firebaseUser) {
    final categories = [
      {
        "label": "باقات سنوية",
        "icon": Icons.work,
        "screen": const RentRecruitScreen(title: "باقات سنوية"),
      },
      {
        "label": "باقات متنوعة",
        "icon": Icons.home,
        "screen": const RentRecruitScreen(title: "باقات متنوعة"),
      },
      {
        "label": "نقل فوري",
        "icon": Icons.drive_eta,
        "screen": const OrderFormScreen(type: "نقل فوري"),
      },
      // {
      //   "label": "باقات زيارات",
      //   "icon": Icons.group,
      //   "screen": const VisitPackagesScreen(),
      // },
      // {
      //   "label": "باقات مناسبات",
      //   "icon": Icons.event,
      //   "screen": const EventsScreen(),
      // },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 3 / 2.5,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return buildCategoryCard(
            category['label']!.toString(),
            category['icon'] as IconData,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => firebaseUser == null
                      ? const LoginScreen()
                      : category['screen'] as Widget,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CurvedSidePainter extends CustomPainter {
  final Color color;
  final bool reverse;

  CurvedSidePainter({required this.color, this.reverse = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();

    if (reverse) {
      path.lineTo(0, size.height);
      path.quadraticBezierTo(size.width / 2, size.height / 2, size.width, 0);
    } else {
      path.moveTo(size.width, 0);
      path.quadraticBezierTo(size.width / 2, size.height / 2, 0, size.height);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
