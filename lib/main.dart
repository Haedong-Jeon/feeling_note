import 'package:feeling_note/DB/diary_database.dart';
import 'package:feeling_note/aboute_me_page/pages/about_me_page.dart';
import 'package:feeling_note/constants/colors.dart';
import 'package:feeling_note/constants/emotion.dart';
import 'package:feeling_note/constants/keys.dart';
import 'package:feeling_note/datas/app_state_provider.dart';
import 'package:feeling_note/login_page/email_signup_or_signin_page.dart';
import 'package:feeling_note/login_page/login_page.dart';
import 'package:feeling_note/read_page/pages/back_up_page.dart';
import 'package:feeling_note/read_page/pages/read_detail_page.dart';
import 'package:feeling_note/read_page/pages/read_page.dart';
import 'package:feeling_note/write_page/pages/already_written_page.dart';
import 'package:feeling_note/write_page/pages/complete_page.dart';
import 'package:feeling_note/write_page/pages/write_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // 다언어 설정

import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

//일기는 하루에 한번만 쓸 수 있다.
bool isTodayDiaryAlreadyWritten = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(nativeAppKey: KAKAO_NATIVE_APP_KEY);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //DB에서 오늘 쓴 일기가 있는지 확인
  isTodayDiaryAlreadyWritten = await isTodayDiaryDone();
  runApp(const ProviderScope(child: MyApp()));
}

Future<bool> isTodayDiaryDone() async {
  await DiaryDatabase.init();
  return DiaryDatabase.isTodayDiaryWritten();
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        var appState = ref.watch(appStateProvider);

        return MaterialApp(
          theme: ThemeData(
              primaryColor: diaryCellColor,
              bottomSheetTheme: BottomSheetThemeData(
                  constraints: BoxConstraints(maxHeight: 500))),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('ko'),
          ],
          home: Navigator(
            pages: [
              appState.shouldShowLoginPage
                  ? appState.shouldShowEmailSinginpage
                      ? MaterialPage(
                          key: EmailSigninOrSignupPage.valueKey,
                          child: EmailSigninOrSignupPage(),
                        )
                      : MaterialPage(
                          key: LoginPage.valueKey,
                          child: LoginPage(),
                        )
                  : MaterialPage(
                      key: MyAppStartPage.valueKey,
                      child: MyAppStartPage(),
                    ),
              if (appState.shouldShowWriteCompletePage)
                MaterialPage(
                  key: CompletePage.valueKey,
                  child: CompletePage(),
                ),
              if (appState.shouldShowDetailPage)
                MaterialPage(
                  key: ReadDetailPage.valueKey,
                  child: ReadDetailPage(
                    emotions: appState.currentShowingDiary,
                  ),
                ),
              if (appState.isServerUploading)
                MaterialPage(
                  key: BackUpPage.valueKey,
                  child: BackUpPage(),
                ),
            ],
            onPopPage: (route, result) {
              return route.didPop(result);
            },
          ),
        );
      },
    );
  }
}

class MyAppStartPage extends ConsumerStatefulWidget {
  static const valueKey = ValueKey("my_app_start_page");
  @override
  _MyAppStartPageState createState() => _MyAppStartPageState();
}

class _MyAppStartPageState extends ConsumerState<MyAppStartPage>
    with TickerProviderStateMixin {
  int _currentBottomNavIndex = 0;
  late TabController tabController;
  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    if (isTodayDiaryAlreadyWritten) {
      Future.microtask(
        () => ref.watch(appStateProvider).setTodaysDiaryDone(),
      );
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      var appState = ref.watch(appStateProvider);
      return Scaffold(
        appBar: AppBar(
          backgroundColor: appState.isLogined ? bottomNavBarColor : Colors.red,
          actions: [
            Builder(builder: (context) {
              String userIdentity =
                  FirebaseAuth.instance.currentUser?.displayName ??
                      FirebaseAuth.instance.currentUser?.email ??
                      "";
              if (userIdentity.contains("privaterelay")) {
                userIdentity = "애플 비공개 계정";
              }
              return Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 18),
                  child: Text(
                    userIdentity,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString("access_token", "");
                await prefs.setString("access_token_expire_at", "");
                await prefs.setString("refresh_token", "");
                await prefs.setString("refresh_token_expire_at", "");
                appState.todaysDiaryDone = false;
                appState.showLoginPage(true);
              },
              child: Text(
                "로그아웃",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
          elevation: 0,
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: tabController,
          children: [
            ReadPage()..appStateProvider = appState,
            WritePage()..tabController = tabController,
            AboutMePage(),
          ],
        ),
        bottomNavigationBar: renderBottomNav(),
      );
    });
  }

  BottomNavigationBar renderBottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentBottomNavIndex,
      onTap: (index) => setState(() {
        _currentBottomNavIndex = index;
        tabController.animateTo(index);
      }),
      backgroundColor: bottomNavBarColor,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: "감정 일기 읽기",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.theater_comedy_sharp),
          label: "감정 일기 쓰기",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_search_sharp),
          label: "나에대해 알아보기",
        ),
      ],
    );
  }
}
