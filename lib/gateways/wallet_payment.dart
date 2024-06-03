import 'dart:convert';
import 'dart:io';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:eclass/common/apidata.dart';
import 'package:eclass/common/global.dart';
import 'package:eclass/provider/home_data_provider.dart';
import 'package:eclass/screens/bottom_navigation_screen.dart';
import 'package:eclass/widgets/appbar.dart';
import 'package:eclass/widgets/success_ticket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../provider/walletDetailsProvider.dart';

class WalletPayment extends StatefulWidget {
  final int amount;

  WalletPayment({required this.amount});

  @override
  _WalletPaymentState createState() => _WalletPaymentState();
}

class _WalletPaymentState extends State<WalletPayment> {
  void loadData() async {
    homeDataProvider = Provider.of<HomeDataProvider>(context, listen: false);
    walletDetailsProvider =
        Provider.of<WalletDetailsProvider>(context, listen: false);
    setState(() {
      currency = "${homeDataProvider.homeModel!.currency!.currency}";
      amount = widget.amount.toDouble();
      isBack = true;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  var paymentResponse, createdDate, createdTime;
  bool isShowing = true;
  bool isBack = false;
  late HomeDataProvider homeDataProvider;
  late WalletDetailsProvider walletDetailsProvider;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  late double amount;
  String transactionId = 'WALLET-${DateTime.now().microsecondsSinceEpoch}';
  late String currency;

  @override
  Widget build(BuildContext context) {
    String currentBalance = walletDetailsProvider.walletModel!.wallet != null
        ? walletDetailsProvider.walletModel!.wallet!.contains(".")
            ? "${currencySymbol(currency)} ${walletDetailsProvider.walletModel!.wallet}"
            : "${currencySymbol(currency)} ${walletDetailsProvider.walletModel!.wallet}.00"
        : "${currencySymbol(currency)} 0.00";
    return Scaffold(
      key: scaffoldKey,
      appBar: customAppBar(context, "Wallet Payment"),
      body: !isBack
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10.0),
                child: Card(
                  elevation: 5.0,
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          translate("Current_Balance"),
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          currentBalance,
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.green,
                          ),
                        ),
                        Divider(height: 20.0),
                        Text(
                          translate("Amount_"),
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "${currencySymbol(currency)} $amount",
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigoAccent,
                            ),
                            onPressed: startPayment,
                            child: Text(
                              translate("Pay"),
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  void startPayment() async {
    if (walletDetailsProvider.walletModel!.wallet!.isNotEmpty) {
      if (double.parse(walletDetailsProvider.walletModel!.wallet.toString()) >= amount) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        if (sharedPreferences.containsKey("topUpWallet")) {
          Fluttertoast.showToast(msg: "N/A", backgroundColor: Colors.red);
          return;
        }
        sendPaymentDetails(transactionId, "wallet");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              translate("Your_Wallet_has_not_enough_balance"),
            ),
          ),
        );
      }
    }
  }

  sendPaymentDetails(transactionId, paymentMethod) async {
    try {
      goToDialog2();
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      var sendResponse;

      if (!sharedPreferences.containsKey("giftUserId")) {
        sendResponse = await http.post(
          Uri.parse("${APIData.payStore}${APIData.secretKey}"),
          body: {
            "transaction_id": "$transactionId",
            "payment_method": "$paymentMethod",
            "pay_status": "1",
            "sale_id": "null",
          },
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $authToken",
            HttpHeaders.acceptHeader: "Application/json",
          },
        );
      } else {
        int? giftUserId = sharedPreferences.getInt("giftUserId");
        int? giftCourseId = sharedPreferences.getInt("giftCourseId");

        sendResponse = await http.post(
          Uri.parse("${APIData.giftCheckout}${APIData.secretKey}"),
          body: {
            "gift_user_id": "$giftUserId",
            "course_id": "$giftCourseId",
            "txn_id": "$transactionId",
            "payment_method": "$paymentMethod",
            "pay_status": "1",
          },
        );
        await sharedPreferences.remove("giftUserId");
        await sharedPreferences.remove("giftCourseId");
      }

      paymentResponse = json.decode(sendResponse.body);
      var date = DateTime.now();
      var time = DateTime.now();
      createdDate = DateFormat('d MMM y').format(date);
      createdTime = DateFormat('HH:mm a').format(time);

      if (sendResponse.statusCode == 200 || sendResponse.statusCode == 201) {
        setState(() {
          isShowing = false;
        });

        goToDialog(createdDate, createdTime);
      } else {
        setState(() {
          isShowing = false;
        });

        Fluttertoast.showToast(msg: "Your transaction failed.");
      }
    } catch (error) {
      print("Wallet Exception : $error");
    }
  }

  goToDialog(subdate, time) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => new GestureDetector(
              child: Container(
                color: Colors.white.withOpacity(0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SuccessTicket(
                      msgResponse: "Your transaction successful",
                      purchaseDate: subdate,
                      time: time,
                      transactionAmount: widget.amount,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.clear,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyBottomNavigationBar(
                              pageInd: 0,
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ));
  }

  goToDialog2() {
    if (isShowing == true) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => WillPopScope(
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                backgroundColor: Colors.white,
                title: Text(
                  "Saving Payment Info",
                  style: TextStyle(color: Color(0xFF3F4654)),
                ),
                content: Container(
                  height: 70.0,
                  width: 150.0,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
              onWillPop: () async => isBack));
    } else {
      Navigator.pop(context);
    }
  }
}
