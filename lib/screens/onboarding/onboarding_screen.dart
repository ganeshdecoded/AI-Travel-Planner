import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ai_travel_planner/screens/auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Plan Your Dream Trip',
      'description': 'Discover amazing destinations and create personalized travel itineraries with AI assistance.',
      'icon': Icons.flight_takeoff,
      'secondaryIcon': Icons.map_outlined,
      'color': const Color(0xFF4A90E2),
    },
    {
      'title': 'Smart Recommendations',
      'description': 'Get intelligent suggestions for attractions, restaurants, and activities based on your preferences.',
      'icon': Icons.lightbulb_outline,
      'secondaryIcon': Icons.explore_outlined,
      'color': const Color(0xFF50C878),
    },
    {
      'title': 'Book with Ease',
      'description': 'Find and book the best flights, hotels, and activities all in one place.',
      'icon': Icons.confirmation_number_outlined,
      'secondaryIcon': Icons.hotel_outlined,
      'color': const Color(0xFFFFA500),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height * 0.3,
                                width: MediaQuery.of(context).size.height * 0.3,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _pages[index]['color'].withOpacity(0.1),
                                ),
                                child: Icon(
                                  _pages[index]['icon'],
                                  size: 100,
                                  color: _pages[index]['color'],
                                ),
                              ),
                              // Background decorative icons
                              ...List.generate(6, (i) {
                                return Positioned(
                                  left: (i % 2 == 0) ? 20 : null,
                                  right: (i % 2 == 1) ? 20 : null,
                                  top: i < 2 ? 20 : null,
                                  bottom: i > 3 ? 20 : null,
                                  child: Icon(
                                    _pages[index]['secondaryIcon'],
                                    size: 40,
                                    color: _pages[index]['color'].withOpacity(0.2),
                                  ),
                                );
                              }),
                            ],
                          ),
                          const SizedBox(height: 40),
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: _pages[index]['color'].withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  _pages[index]['title'],
                                  style: TextStyle(
                                    color: _pages[index]['color'],
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _pages[index]['description'],
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 16,
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? _pages[_currentPage]['color']
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => _completeOnboarding(),
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_currentPage == _pages.length - 1) {
                            _completeOnboarding();
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _pages[_currentPage]['color'],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }
} 