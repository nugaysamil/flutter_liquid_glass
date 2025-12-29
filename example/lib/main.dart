import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_liquid_glass_plus/buttons/liquid_glass_switch.dart';
import 'package:flutter_liquid_glass_plus/flutter_liquid_glass.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

final List<Widget> pages = [
  const HomeContent(),
  const SecondPage(),
  const ProfilePage(),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Liquid Glass Example',
      theme: ThemeData(
        textTheme: GoogleFonts.aBeeZeeTextTheme().apply(
          bodyColor: Colors.black,
          displayColor: Colors.black,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return LiquidGlassLayer(
      settings: const LiquidGlassSettings(
        thickness: 30,
        blur: 20,
      ),
      child: Scaffold(
        extendBody: true,
        appBar: LGAppBar(
          backgroundColor: Colors.black38.withValues(alpha: 0.7),
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              LGSheet.show(
                context: context,
                builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.home, color: Colors.black),
                      title: const Text(
                        'Home',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () => Navigator.pop(context),
                    ),
                    ListTile(
                      leading: const Icon(Icons.search, color: Colors.black),
                      title: const Text(
                        'Search',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () => Navigator.pop(context),
                    ),
                    ListTile(
                      leading: const Icon(Icons.person, color: Colors.black),
                      title: const Text(
                        'Profile',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () => Navigator.pop(context),
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings, color: Colors.black),
                      title: const Text(
                        'Settings',
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                ),
                settings: const LiquidGlassSettings(
                  thickness: 40,
                  blur: 20,
                  glassColor: Color.fromARGB(150, 255, 255, 255),
                ),
              );
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon:
                  const Icon(Icons.notifications_outlined, color: Colors.black),
              onPressed: () {},
            ),
          ],
          useOwnLayer: true,
          settings: const LiquidGlassSettings(
            thickness: 1,
            blur: 50,
            glassColor: Color.fromARGB(147, 205, 179, 179),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.grey.shade50,
                Colors.grey.shade100,
                Colors.grey.shade200,
              ],
            ),
          ),
          child: AppPages(index: _selectedIndex),
        ),
        bottomNavigationBar: AppBottomBar(
          index: _selectedIndex,
          onTabSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}

class AppPages extends StatelessWidget {
  const AppPages({required this.index, super.key});

  final int index;

  @override
  Widget build(BuildContext context) {
    return pages[index];
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  bool _switchValue = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 100),
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Toggle Switch',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  LGSwitch(
                    value: _switchValue,
                    onChanged: (value) {
                      setState(() {
                        _switchValue = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          ...List.generate(
            20,
            (index) => Card(
              margin: EdgeInsets.only(
                bottom: index == 19 ? 120 : 16,
                left: 16,
                right: 16,
              ),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.white,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.music_note,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Card ${index + 1}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Beautiful glass design',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'This card demonstrates the beautiful transparency effect of the bottom navigation bar. Scroll down to see the glass effect blend with the content.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black.withValues(alpha: 0.8),
                        height: 1.6,
                      ),
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
}

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          ...List.generate(
            15,
            (index) => Card(
              margin: EdgeInsets.only(
                bottom: index == 14 ? 120 : 20,
              ),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.white,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.star_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Card ${index + 1}',
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'New',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Beautiful glass morphism design',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black.withValues(alpha: 0.7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'This is a sample card with gradient background that allows you to see the transparency of the bottom bar when scrolling.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black.withValues(alpha: 0.8),
                          height: 1.6,
                          letterSpacing: 0.3,
                        ),
                      ),
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
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Colors.white,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.black,
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Welcome to your profile',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppBottomBar extends StatelessWidget {
  const AppBottomBar({
    required this.index,
    required this.onTabSelected,
    super.key,
  });

  final int index;
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          child: Row(
            children: [
              Expanded(
                child: LGBottomBar(
                  showLabel: false,
                  isSearch: true,
                  glassSettings: const LiquidGlassSettings(
                    thickness: 45,
                    blur: 5,
                    glassColor: Color.fromARGB(100, 255, 255, 255),
                  ),
                  searchTab: const LGBottomBarTab(
                    label: '',
                    icon: Icon(Icons.search, color: Colors.black),
                  ),
                  onSearchTap: () {},
                  searchCloseIcon: const Icon(Icons.close, color: Colors.black),
                  onSearchChanged: (query) {},
                  indicatorColor: Colors.black12,
                  searchPlaceholderStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  selectedIconColor: Colors.white,
                  unselectedIconColor: Colors.red,
                  selectedLabelColor: Colors.white,
                  unselectedLabelColor: Colors.red,
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  onSearchSubmitted: (query) {},
                  searchPlaceholder: 'Search apps, games, and more',
                  tabs: const [
                    LGBottomBarTab(label: 'Home', icon: Icon(Icons.home)),
                    LGBottomBarTab(
                        label: 'Search', icon: Icon(Icons.star)),
                    LGBottomBarTab(label: 'Profile', icon: Icon(Icons.person)),
                  ],
                  selectedIndex: index,
                  onTabSelected: onTabSelected,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
