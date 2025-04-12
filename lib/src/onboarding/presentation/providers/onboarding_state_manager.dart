import 'package:flutter/material.dart';

class OnboardingStateManager with ChangeNotifier {
  final PageController pageController = PageController();
  int currentPage = 0;
  String emailAddress = '';

  void nextPage() {
    if (currentPage < 2) {
      // assuming 3 pages
      currentPage++;
      pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      notifyListeners();
    }
  }

  void prevPage() {
    if (currentPage > 0) {
      currentPage--;
      pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      notifyListeners();
    } else {
      currentPage = 0;
    }
  }

  void onPageChanged(int index) {
    currentPage = index;
    notifyListeners();
  }

  void setEmail(String value) {
    emailAddress = value;
    notifyListeners();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
