import 'package:diver/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'data/getXState.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController pageController = PageController();
  int currentPageNumbers = 0;

  @override
  void initState() {
    super.initState();

    Get.find<UserDataGetX>().userDataFetch(context);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      drawer: buildDrawer(context),
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            _buildSliverAppBar(),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPageViewWithIndicator(),
                  const SizedBox(height: 20),
                  _buildNotificationCard(context),
                  const SizedBox(height: 20),
                  _buildPhotoAlbumWithIndicator(),
                ],
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 100,
              ),
            ),
          ],
        ),
      ),
      bottomSheet: bottomSheet(context),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.grey[900],
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.logout_rounded),
          color: Colors.white38,
        ),
      ],
      shadowColor: Colors.grey[900],
      automaticallyImplyLeading: false,
      floating: true,
      pinned: true,
      expandedHeight: 60.0,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: const Text(
          "JiantScuba",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        background: DecoratedBox(
          decoration: BoxDecoration(color: Colors.grey[900]),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.grey[850],
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.25,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                /*const Icon(
                  Icons.notifications_active,
                  size: 30,
                  color: Colors.yellowAccent,
                ),*/
                const SizedBox(width: 10),
                const Text(
                  '공지 사항',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(width: 140),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    '바로 가기',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white38,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: Colors.white38,
                  size: 13,
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildNoticeRow('공지', '[안내] (수정) 9/25(수) 네트워크 오류 보상 지급 안내'),
            _buildNoticeRow('공지', '[안내] (수정) 9/25(수) 네트워크 오류 보상 지급 안내'),
            _buildNoticeRow('공지', '[안내] (수정) 9/25(수) 네트워크 오류 보상 지급 안내'),
          ],
        ),
      ),
    );
  }

  static Widget _buildNoticeRow(String label, String message) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.blueAccent,
              fontSize: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.white,
                decoration: TextDecoration.underline,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageViewWithIndicator() {
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: PageView.builder(
            controller: pageController,
            itemCount: 5,
            onPageChanged: (page) {
              setState(() {
                currentPageNumbers = page;
              });
            },
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey[700],
                ),
                child: Image.asset('assets/diver.png'),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        SmoothPageIndicator(
          controller: pageController,
          count: 5,
          effect: const ExpandingDotsEffect(
            dotHeight: 10,
            dotWidth: 10,
            activeDotColor: Colors.blueAccent,
            dotColor: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoAlbumWithIndicator() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.grey[700],
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const SizedBox(width: 18),
                const Text(
                  '포토 갤러리',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 120),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    '바로 가기',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white38,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: Colors.white38,
                  size: 13,
                ),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.35,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          'assets/bg_1.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
