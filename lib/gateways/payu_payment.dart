import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:eclass/common/apidata.dart';
import 'package:eclass/common/global.dart';
import 'package:eclass/provider/home_data_provider.dart';
import 'package:eclass/provider/payment_api_provider.dart';
import 'package:eclass/provider/user_profile.dart';
import 'package:eclass/screens/bottom_navigation_screen.dart';
import 'package:eclass/widgets/success_ticket.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:payu_web_checkout/payu_web_checkout.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PayUPayment extends StatefulWidget {
  final int? amount;

  PayUPayment({this.amount});

  @override
  _PayUPaymentState createState() => _PayUPaymentState();
}

class _PayUPaymentState extends State<PayUPayment> {
  var merchantId, merchantKey, salt, transactionId, currency;
  var fName, lName, email, phone, address;
  var paymentResponse, createdDate, createdTime;
  bool isShowing = true;
  bool isLoading = true;
  bool isBack = false;
  String? selectedUrl;
  double progress = 0;
  HomeDataProvider? homeDataProvider;

  void loadData() async {
    homeDataProvider = Provider.of<HomeDataProvider>(context, listen: false);
    await Provider.of<UserProfile>(context, listen: false).fetchUserProfile();
    setState(() {
      fName = Provider.of<UserProfile>(context, listen: false)
          .profileInstance
          .fname;
      lName = Provider.of<UserProfile>(context, listen: false)
          .profileInstance
          .lname;
      email = Provider.of<UserProfile>(context, listen: false)
          .profileInstance
          .email;
      phone = Provider.of<UserProfile>(context, listen: false)
          .profileInstance
          .mobile;
      address = Provider.of<UserProfile>(context, listen: false)
          .profileInstance
          .address;
      merchantId = Provider.of<PaymentAPIProvider>(context, listen: false)
          .paymentApi
          .allKeys!
          .pAYUMERCHANTKEY;
      merchantKey = Provider.of<PaymentAPIProvider>(context, listen: false)
          .paymentApi
          .allKeys!
          .pAYUMERCHANTKEY;
      salt = Provider.of<PaymentAPIProvider>(context, listen: false)
          .paymentApi
          .allKeys!
          .pAYUMERCHANTSALT;
      currency = "${homeDataProvider?.homeModel!.currency!.currency}";
      transactionId = 'PAYU-${DateTime.now().microsecondsSinceEpoch}';
      isBack = true;
    });
  }

  late PayUWebCheckout _payUWebCheckout;
  late Map<String, dynamic> response;

  @override
  void initState() {
    _payUWebCheckout = PayUWebCheckout();
    super.initState();
    loadData();

    _payUWebCheckout.on(
        PayUWebCheckout.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _payUWebCheckout.on(
        PayUWebCheckout.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  void _handlePaymentSuccess(Map<String, dynamic> response) {
    log("PayU Payment Response -> $response");
    sendPaymentDetails(transactionId, "PayU");
    setState(() {
      this.response = response;
    });
  }

  void _handlePaymentError(Map<String, dynamic> response) {
    log("PayU Payment Response -> $response");
    setState(() {
      this.response = response;
    });
  }

  void pay() {
    _payUWebCheckout.doPayment(
      context: context,
      payuWebCheckoutModel: PayuWebCheckoutModel(
        key: merchantKey,
        salt: salt,
        txnId: transactionId,
        phone: phone,
        amount: widget.amount.toString(),
        productName: "Course",
        firstName: fName,
        email: email,
        udf1: "udf1",
        udf2: "udf2",
        udf3: "udf3",
        udf4: "",
        udf5: "",
        successUrl: "${APIData.confirmation}",
        failedUrl: "https://www.payumoney.com/mobileapp/payumoney/failure.php",
        baseUrl:
            "https://secure.payu.in", // For Test, use - https://test.payu.in
      ),
    );
  }

  @override
  void dispose() {
    _payUWebCheckout.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PayU Money Payment'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: pay,
          child: Text(
            "Pay",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }

  sendPaymentDetails(transactionId, paymentMethod) async {
    try {
      goToDialog2();
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      var sendResponse;

      if (sharedPreferences.containsKey("topUpWallet")) {
        var currency = Provider.of<HomeDataProvider>(context, listen: false)
            .homeModel!
            .currency!
            .currency;
        sendResponse = await http.post(
          Uri.parse("${APIData.walletTopUp}"),
          body: {
            "transaction_id": "$transactionId",
            "payment_method": "$paymentMethod",
            "total_amount": "${widget.amount}",
            "currency": "$currency",
            "detail": "$paymentMethod",
          },
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $authToken",
            "Accept": "Application/json",
          },
        );
        print("Top Up Wallet API Status Code :-> ${sendResponse.statusCode}");
        print("Top Up Wallet API Response :-> ${sendResponse.body}");
        await sharedPreferences.remove("topUpWallet");
      } else if (!sharedPreferences.containsKey("giftUserId")) {
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
        Fluttertoast.showToast(msg: "Your transaction failed.");
      }
    } catch (error) {}
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
                                    )));
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
