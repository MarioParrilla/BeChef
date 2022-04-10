import 'package:flutter/material.dart';

class BotttonNavProvider extends ChangeNotifier{

  int _currentIndex = 0;
  final PageController _pageController = PageController( initialPage: 0 );

  int get currentIndex => _currentIndex;

  PageController get pageController => _pageController;

  set currentIndex(int index) {
    _currentIndex = index;

    _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);

    notifyListeners();
  }
  
}