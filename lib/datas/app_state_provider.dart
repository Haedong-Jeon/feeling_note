import 'package:feeling_note/constants/emotion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppStateChangeNotifier extends ChangeNotifier {
  bool shouldShowWriteCompletePage = false;
  bool shouldShowPreviewPage = false;
  bool todaysDiaryDone = false;
  bool shouldShowDetailPage = false;
  bool shouldShowEditingPage = false;
  bool isServerUploading = false;
  bool shouldShowLoginPage = true;
  bool shouldShowEmailSinginpage = false;
  bool isLogined = false;
  bool aboutMeAniGo = false;
  bool isLoading = false;
  List<Emotion> currentShowingDiary = [];

  void setAboutMeAniGo(bool should) {
    if (should) {
      aboutMeAniGo = true;
      notifyListeners();
    } else {
      aboutMeAniGo = false;
      notifyListeners();
    }
  }

  void showCompletePage(bool should) {
    if (should) {
      shouldShowWriteCompletePage = true;
      notifyListeners();
    } else {
      shouldShowWriteCompletePage = false;
      notifyListeners();
    }
  }

  void setIsLoading(bool should) {
    if (should) {
      isLoading = true;
      notifyListeners();
    } else {
      isLoading = false;
      notifyListeners();
    }
  }

  void setIsLogined(bool should) {
    if (should) {
      isLogined = true;
      notifyListeners();
    } else {
      isLogined = false;
      notifyListeners();
    }
  }

  void showLoginPage(bool should) {
    if (should) {
      shouldShowLoginPage = true;
      notifyListeners();
    } else {
      shouldShowLoginPage = false;
      notifyListeners();
    }
  }

  void showPreviewPage(bool should) {
    if (should) {
      shouldShowPreviewPage = true;
      notifyListeners();
    } else {
      shouldShowPreviewPage = false;
      notifyListeners();
    }
  }

  void showEditingPage(bool should) {
    if (should) {
      shouldShowEditingPage = true;
      notifyListeners();
    } else {
      shouldShowEditingPage = false;
      notifyListeners();
    }
  }

  void showDetailPage(bool should) {
    if (should) {
      shouldShowDetailPage = true;
      notifyListeners();
    } else {
      shouldShowDetailPage = false;
      notifyListeners();
    }
  }

  void showEmailSignInPage(bool should) {
    if (should) {
      shouldShowEmailSinginpage = true;
      notifyListeners();
    } else {
      shouldShowEmailSinginpage = false;
      notifyListeners();
    }
  }

  void setIsServerUploading(bool should) {
    if (should) {
      isServerUploading = true;
      notifyListeners();
    } else {
      isServerUploading = false;
      notifyListeners();
    }
  }

  void setTodaysDiaryDone() {
    todaysDiaryDone = true;
    notifyListeners();
  }

  void setTodaysDiaryNotDone() {
    todaysDiaryDone = false;
    notifyListeners();
  }

  void setTodaysDiaryDoneWithoutNoti() {
    todaysDiaryDone = true;
  }

  void setTodaysDiaryNotDoneWithouNoti() {
    todaysDiaryDone = false;
  }

  void notifyListenerManually() {
    notifyListeners();
  }
}

final appStateProvider = ChangeNotifierProvider<AppStateChangeNotifier>(
  (ref) => AppStateChangeNotifier(),
);
