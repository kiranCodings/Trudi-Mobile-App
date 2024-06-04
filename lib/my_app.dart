import 'package:eclass/Screens/blog_list_screen.dart';
import 'package:eclass/Screens/terms_policy.dart';
import 'package:eclass/localization/language_screen.dart';
import 'package:eclass/player/offline/downloads_screen.dart';
import 'package:eclass/provider/InstituteDetailsProvider.dart';
import 'package:eclass/provider/blog_provider.dart';
import 'package:eclass/localization/language_provider.dart';
import 'package:eclass/provider/InstituteProvider.dart';
import 'package:eclass/provider/compareCourseProvider.dart';
import 'package:eclass/provider/currenciesProvider.dart';
import 'package:eclass/provider/filter_provider.dart';
import 'package:eclass/provider/manual_payment_provider.dart';
import 'package:eclass/provider/resume_provider.dart';
import 'package:eclass/provider/terms_policy_provider.dart';
import 'package:eclass/provider/walletDetailsProvider.dart';
import 'package:eclass/provider/watchlist_provider.dart';
import 'package:eclass/provider/job_provider.dart';
import 'package:eclass/screens/applied_job_screen.dart';
import 'package:eclass/screens/compare_course_screen.dart';
import 'package:eclass/screens/create_resume_screen.dart';
import 'package:eclass/screens/currency_screen.dart';
import 'package:eclass/screens/resume_screen.dart';
import 'package:eclass/screens/wallet_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'Screens/loading_screen.dart';
import 'gateways/donate.dart';
import 'provider/cart_provider.dart';
import 'provider/content_provider.dart';
import 'provider/course_details_provider.dart';
import 'provider/recent_course_provider.dart';
import 'Screens/faq_screen.dart';
import 'Screens/instructor_faq_screen.dart';
import 'Screens/about_us_screen.dart';
import 'Screens/became_instructor_screen.dart';
import 'Screens/bundle_detail_screen.dart';
import 'Screens/category_screen.dart';
import 'Screens/child_category_screen.dart';
import 'Screens/contact_us_screen.dart';
import 'Screens/course_details_screen.dart';
import 'Screens/course_instructor_screen.dart';
import 'Screens/courses_screen.dart';
import 'Screens/edit_profile.dart';
import 'Screens/filter_screen.dart';
import 'Screens/forgot_password.dart';
import 'Screens/home_screen.dart';
import 'Screens/search_jobs.dart';
import 'Screens/job_search.dart';
import 'Screens/sign_in_screen.dart';
import 'Screens/notification_detail_screen.dart';
import 'Screens/notifications_screen.dart';
import 'Screens/purchase_history_screen.dart';
import 'Screens/sign_up_screen.dart';
import 'Screens/sub_category_screen.dart';
import 'Screens/job_filter_screen .dart';
import 'provider/bundle_course.dart';
import 'provider/cart_pro_api.dart';
import 'provider/filter_pro.dart';
import 'provider/home_data_provider.dart';
import 'provider/payment_api_provider.dart';
import 'provider/visible_provider.dart';
import 'provider/wish_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/courses_provider.dart';
import 'provider/user_details_provider.dart';
import 'common/theme.dart' as T;
import 'provider/user_profile.dart';
import 'provider/applied_job_provider.dart';

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  String? token;
  FirebaseAnalyticsObserver? observer;
  MyApp(this.token, this.observer);
  // This widget is the root of your application.

  // static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  // static FirebaseAnalyticsObserver observer =
  //     FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => UserDetailsProvider()), // Fetch User Details
        ChangeNotifierProvider(create: (_) => T.Theme()), // Theme Data
        ChangeNotifierProvider(create: (_) => UserProfile()),
        ChangeNotifierProvider(create: (_) => WishListProvider()),
        ChangeNotifierProvider(create: (_) => CoursesProvider()),
        ChangeNotifierProvider(create: (_) => CartProducts()),
        ChangeNotifierProvider(create: (_) => FilterDetailsProvider()),
        ChangeNotifierProvider(create: (_) => BundleCourseProvider()),
        ChangeNotifierProvider(create: (_) => HomeDataProvider()),
        ChangeNotifierProvider(create: (_) => Visible()),
        ChangeNotifierProvider(create: (_) => RecentCourseProvider()),
        ChangeNotifierProvider(create: (_) => PaymentAPIProvider()),
        ChangeNotifierProvider(create: (_) => ContentProvider()),
        ChangeNotifierProvider(create: (_) => CourseDetailsProvider()),
        ChangeNotifierProvider(create: (_) => BlogProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => TermsPolicyProvider()),
        ChangeNotifierProvider(create: (_) => WatchlistProvider()),
        ChangeNotifierProvider(create: (_) => ManualPaymentProvider()),
        ChangeNotifierProvider(create: (_) => InstituteProvider()),
        ChangeNotifierProvider(create: (_) => InstituteDetailsProvider()),
        ChangeNotifierProvider(create: (_) => CompareCourseProvider()),
        ChangeNotifierProvider(create: (_) => WalletDetailsProvider()),
        ChangeNotifierProvider(create: (_) => CurrenciesProvider()),
        ChangeNotifierProvider(create: (_) => JobProvider()),
        ChangeNotifierProvider(create: (_) => AppliedJobProvider()),
        ChangeNotifierProvider(create: (_) => ResumeProvider()),
        ChangeNotifierProvider(create: (_) => FilterProvider()),
      ],
      child: LocalizationProvider(
        state: LocalizationProvider.of(context).state,
        child: MaterialApp(
          navigatorObservers: <NavigatorObserver>[observer!],
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            localizationDelegate
          ],
          supportedLocales: localizationDelegate.supportedLocales,
          locale: localizationDelegate.currentLocale,
          home: token == null ? SignInScreen() : LoadingScreen(token),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: 'Mada'),
          routes: {
            '/SignIn': (context) => SignInScreen(),
            '/courseDetails': (context) => CourseDetailScreen(),
            '/InstructorScreen': (context) => CourseInstructorScreen(),
            '/homeScreen': (context) => HomeScreen(),
            '/CoursesScreen': (context) => CoursesScreen(),
            '/signUp': (context) => SignUpScreen(),
            '/category': (context) => CategoryScreen(),
            '/subCategory': (context) => SubCategoryScreen(),
            '/childCategory': (context) => ChildCategoryScreen(),
            '/forgotPassword': (context) => ForgotPassword(),
            '/editProfile': (context) => EditProfile(),
            "/bundleCourseDetail": (context) => BundleDetailScreen(),
            "/filterScreen": (context) => FilterScreen(),
            '/notifications': (context) => NotificationScreen(),
            '/becameInstructor': (context) => BecomeInstructor(),
            '/aboutUs': (context) => AboutUsScreen(),
            '/purchaseHistory': (context) => PurchaseHistoryScreen(),
            '/contactUs': (context) => ContactUsScreen(),
            '/notificationDetail': (context) => NotificationDetail(),
            '/userFaq': (context) => FaqScreen(),
            '/instructorFaq': (context) => InstructorFaqScreen(),
            '/blogList': (context) => BlogListScreen(),
            '/languageScreen': (context) => LanguageScreen(),
            '/termsPolicy': (context) => TermsPolicy(),
            '/donate': (context) => Donate(),
            '/downloads': (context) => DownloadsScreen(),
            '/searchjobs': (context) => SearchJobs(),
            '/jobsearch': (context) => JobSearchScreen(),
            '/appliedjobs': (context) => AppliedJobSearchScreen(),
            '/myresume': (context) => ResumeScreen(),
            '/createresume': (context) => CreateResumeScreen(),
            '/currency': (context) => CurrencyScreen(),
            '/compare': (context) => CompareCourseScreen(),
            '/wallet': (context) => WalletScreen(),
            '/jobfilter': (context) => JobFilterScreen(),
          },
        ),
      ),
    );
  }
}
