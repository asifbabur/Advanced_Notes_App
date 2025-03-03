import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_notes_flutter/common/my_button.dart';
import 'package:my_notes_flutter/common/my_text.dart';
import 'package:my_notes_flutter/core/constants.dart';
import 'package:my_notes_flutter/core/local_storage_manager.dart';
import 'package:my_notes_flutter/feautures/auth/presentation/pages/auth_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});
  static const pageName = 'onboarding';
  static const pagePath = '/onboarding';
  @override
  OnboardingPageState createState() => OnboardingPageState();
}

class OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page!.toInt();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                children: [
                  buildPage(
                    color: Colors.white,
                    image: 'assets/images/notes_1.jpeg',
                    title: 'Welcome to NoteFly',
                    description:
                        'Organize your notes efficiently and effectively.',
                  ),
                  buildPage(
                    color: Colors.white,
                    image: 'assets/images/notes_2.jpeg',
                    title: 'Collaborate with Others',
                    description:
                        'Share and collaborate on notes with your team.',
                  ),
                ],
              ),
            ),
            Center(
              child: SmoothPageIndicator(
                controller: _controller,
                count: 2,
                effect: WormEffect(
                  dotColor: Colors.grey,
                  activeDotColor: Colors.blue,
                ),
              ),
            ),
            SizedBox(height: 20),
            MyButton(
              textWeight: FontWeight.w600,
              fontSize: 14,
              buttonColor: AppColors.primaryBlueColor,
              text: _currentPage == 1 ? 'Get Started' : 'Next',
              onPressed: () async {
                if (_currentPage == 1) {
                  await ref
                      .read(localStorageServiceProvider)
                      .completeOnboarding();
                  if (context.mounted) {
                    context.go(AuthPage.pagePath);
                  }

                  // Navigate to the main app
                } else {
                  _controller.nextPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPage({
    required Color color,
    required String image,
    required String title,
    required String description,
  }) {
    return Container(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 300),
          SizedBox(height: 20),
          MyText(
            title,
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
          SizedBox(height: 10),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: MyText(
                description,
                color: Colors.black,
                maxLines: 2,
                fontSize: 16,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
