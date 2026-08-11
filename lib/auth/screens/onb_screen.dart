import 'package:flutter/material.dart';
import 'package:flutter_mastery/core/theme/app_colors.dart';
import 'package:flutter_mastery/core/theme/app_text_styles.dart';
import 'package:flutter_mastery/core/storage/storage_helper.dart';
import 'package:flutter_mastery/dash/screens/main_screen.dart';

class OnbScreen extends StatefulWidget {
  const OnbScreen({super.key});

  @override
  State<OnbScreen> createState() => _OnbScreenState();
}

class _OnbScreenState extends State<OnbScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _onbData = [
    {
      'title': 'Learn Flutter\nThe Smart Way',
      'subtitle': 'Step by step tutorials, examples,\nand real world projects',
      'image': 'assets/images/onb_1.png',
    },
    {
      'title': 'Hands-on Code\nExamples',
      'subtitle': 'Explore, run and understand\ncode with live preview',
      'image': 'assets/images/onb_2.png',
    },
    {
      'title': 'All in One\nLearning Hub',
      'subtitle': 'Widgets, Dart, Firebase,\nProjects, Interview & more',
      'image': 'assets/images/onb_3.png',
    },
    {
      'title': 'Welcome to\nFlutter Mastery',
      'subtitle': 'Let\'s start your learning\njourney',
      'image': '',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (_currentIndex < _onbData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToHome();
    }
  }

  void _onSkipPressed() {
    _pageController.animateToPage(
      _onbData.length - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _navigateToHome() async {
    await StorageHelper.setLoggedIn(true);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLastPage = _currentIndex == _onbData.length - 1;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          children: [

            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onbData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final item = _onbData[index];
                  final isWelcomePage = item['image']!.isEmpty;

                  return Column(
                    children: [
Spacer(),
                      if (!isWelcomePage) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: SizedBox(
                            height: 250,
                            width: double.infinity,
                            child: Image.asset(
                              item['image']!,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ] else ...[
                        const Spacer(),
                        FlutterLogo(size: size.width * 0.35),
                        const SizedBox(height: 32),
                      ],


                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          item['title']!,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.displayMedium(
                            color: AppColors.darkTextPrimary,
                          ).copyWith(height: 1.25, fontWeight: FontWeight.bold),
                        ),
                      ),

                      const SizedBox(height: 12),


                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          item['subtitle']!,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium(
                            color: AppColors.darkTextSecondary,
                          ).copyWith(height: 1.45),
                        ),
                      ),

                      const Spacer(),
                    ],
                  );
                },
              ),
            ),


            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 24.0),
              child: isLastPage
                  ? SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _navigateToHome,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(27),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Get Started',
                          style: AppTextStyles.headingMedium(
                            color: Colors.white,
                          ).copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        TextButton(
                          onPressed: _onSkipPressed,
                          child: Text(
                            'Skip',
                            style: AppTextStyles.bodyMedium(
                              color: AppColors.darkTextMuted,
                            ),
                          ),
                        ),


                        Row(
                          children: List.generate(_onbData.length, (index) {
                            final isActive = index == _currentIndex;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 4.0,
                              ),
                              height: 8,
                              width: isActive ? 22 : 8,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? AppColors.primary
                                    : AppColors.darkSurfaceVariant,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            );
                          }),
                        ),


                        TextButton(
                          onPressed: _onNextPressed,
                          child: Text(
                            'Next',
                            style: AppTextStyles.headingSmall(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
