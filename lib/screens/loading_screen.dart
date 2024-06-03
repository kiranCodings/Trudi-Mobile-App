import 'dart:async';
import 'package:eclass/localization/language_provider.dart';
import 'package:eclass/services/internetStatus.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'bottom_navigation_screen.dart';
import '../common/global.dart';
import '../provider/home_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class LoadingScreen extends StatefulWidget {
  String? token;
  LoadingScreen(this.token);
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool _visible = false;

  initState() {
    super.initState();
    listenInternetStatus(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var token = await storage.read(key: "token");
      print('me$token');
      authToken = token;
      HomeDataProvider homeData =
          Provider.of<HomeDataProvider>(context, listen: false);
      await homeData.getHomeDetails(context);

      if (await storage.containsKey(key: 'selectedCurrency') &&
          await storage.containsKey(key: 'selectedCurrencyRate')) {
        selectedCurrency = await storage.read(key: 'selectedCurrency');
        selectedCurrencyRate =
            int.tryParse(storage.read(key: 'selectedCurrencyRate').toString());
      } else {
        selectedCurrency = homeData.homeModel!.currency!.currency;
        selectedCurrencyRate = 1;
      }

      // Loading Languages
      LanguageProvider languageProvider =
          Provider.of<LanguageProvider>(context, listen: false);
      await languageProvider.loadData(context, loadScreen: false);
      changeLocale(context, languageProvider.languageCode);

      setState(() {
        authToken = token;
      });
      Timer(Duration(milliseconds: 500), () {
        setState(() {
          _visible = true;
        });
      });
    });
  }

  Widget logoWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo.png"),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _visible == true ? MyBottomNavigationBar(pageInd: 0) : logoWidget(),
    );
  }

  @override
  void dispose() {
    cancelInternetStatus();
    super.dispose();
  }
}
