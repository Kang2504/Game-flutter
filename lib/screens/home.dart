import 'package:flutter/material.dart';
import 'package:glogic/widgets/dropdown.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class GameHomePage extends StatefulWidget {
  const GameHomePage({super.key});

  @override
  State<GameHomePage> createState() => _GameHomePageState();
}

class _GameHomePageState extends State<GameHomePage> {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    const primaryBg = Color.fromARGB(255, 198, 198, 197);
    const textColor = Color.fromARGB(255, 141, 25, 5);

    return Scaffold(
      backgroundColor: primaryBg,
      body: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://images.spiderum.com/sp-images/1cbe8670fbdb11ebbcab1f99dd694450.jpeg',
                          ),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.3),
                            BlendMode.darken,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              Positioned(
                top: 50,
                left: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.psychology_alt,
                      color: Colors.amber,
                      size: 40,
                    ),
                    DetectiveMenu(),
                  ],
                ),
              ),

              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: 4,
                    effect: const ExpandingDotsEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor: Colors.amber,
                      dotColor: Colors.white24,
                    ),
                  ),
                ),
              ),
            ],
          ),

          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Center(
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1.1,
                  children: [
                    _menuItem(
                      Icons.find_in_page,
                      'Vụ án\nPhổ thông',
                      textColor,
                      () => Navigator.pushNamed(context, '/cases'),
                    ),
                    _menuItem(
                      Icons.stars,
                      'Sự kiện\nĐặc biệt',
                      textColor,
                      () => Navigator.pushNamed(context, '/cases'),
                    ),
                    _menuItem(
                      Icons.menu_book,
                      'Hướng dẫn\nCách chơi',
                      textColor,
                      () => Navigator.pushNamed(context, '/case_selection'),
                    ),
                    _menuItem(
                      Icons.query_stats,
                      'Bảng\nXếp hạng',
                      textColor,
                      () => Navigator.pushNamed(context, '/cases'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(
    IconData icon,
    String title,
    Color text,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(3, 3),
            ),
          ],
          image: const DecorationImage(
            image: AssetImage('assets/images/giay.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: text),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: text,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                shadows: [
                  Shadow(color: Colors.white.withOpacity(0.5), blurRadius: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
