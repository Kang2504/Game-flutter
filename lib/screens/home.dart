import 'package:flutter/material.dart';
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
                    GestureDetector(
                      onTap: () => _showProfileDialog(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white24,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_outline,
                          color: Colors.white,
                        ),
                      ),
                    ),
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
                    ),
                    _menuItem(Icons.stars, 'Sự kiện\nĐặc biệt', textColor),
                    _menuItem(
                      Icons.menu_book,
                      'Hướng dẫn\nCách chơi',
                      textColor,
                    ),
                    _menuItem(Icons.query_stats, 'Bảng\nXếp hạng', textColor),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String title, Color text) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        // Đổ bóng để tạo chiều sâu cho tờ giấy
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(3, 3),
          ),
        ],
        // CHÈN HÌNH ẢNH NỀN TẠI ĐÂY
        image: const DecorationImage(
          image: AssetImage('assets/images/giay.jpg'),
          fit: BoxFit.cover, // Đảm bảo ảnh phủ kín ô
          // Bạn có thể thêm colorFilter nếu muốn ảnh giấy tối đi một chút
          // colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.1), BlendMode.darken),
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
              // Thêm bóng cho chữ nếu ảnh nền quá sáng khó đọc
              shadows: [
                Shadow(color: Colors.white.withOpacity(0.5), blurRadius: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showProfileDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2D2640),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(30),
        height: 300,
        child: const Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFFE8C5E5),
              child: Icon(Icons.person, size: 50),
            ),
            SizedBox(height: 20),
            Text(
              'Thám tử: 0912***456',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('Cấp bậc: Tập sự', style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
