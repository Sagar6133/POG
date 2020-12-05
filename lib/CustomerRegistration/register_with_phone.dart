import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otp/config/config_media.dart';
import 'package:otp/config/dialog.dart';
import 'package:otp/homepage/home.dart';

class MyAppOne extends StatefulWidget {
  _OtpSpalash createState() {
    return _OtpSpalash();
  }
}

class _OtpSpalash extends State<MyAppOne> {
  TextEditingController _number = TextEditingController();
  TextEditingController _otp = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  var verificationCode;
  var smsCode;
  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();

  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return isLoading
        ? CircularProgressIndicator()
        : Scaffold(
            body: Column(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Center(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 40,
                            ),
                            Text(
                              "Register Your Phone Number",
                              style:
                                  Theme.of(context).textTheme.headline6.apply(
                                        fontFamily: "Marmelad",
                                        color: Color(0xffdaa520),
                                        fontWeightDelta: 3,
                                      ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            cAvatar(),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              validator: (String arg) {
                                if (arg == null) {
                                  return "please enter phone number";
                                } else if (arg.length != 10) {
                                  return "phone number should be 10 digits";
                                } else
                                  return null;
                              },
                              onChanged: (String newVal) {
                                if (newVal.length == 10) {
                                  f1.unfocus();
                                  FocusScope.of(context).requestFocus(f2);
                                  print("here");
                                  _submit();
                                }
                              },
                              // enabled: true,
                              controller: _number,
                              keyboardType: TextInputType.number,
                              keyboardAppearance: Brightness.light,
                              decoration: new InputDecoration(
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xffdaa520)),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(25.7),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xffdaa520)),
                                  borderRadius: BorderRadius.circular(25.7),
                                ),
                                labelText: "Phone Number",
                                labelStyle: TextStyle(
                                  color: Color(0xffdaa520),
                                ),
                                filled: true,
                                hintText: "Enter your phone number",
                                hintStyle:
                                    new TextStyle(color: Color(0xffdaa520)),
                                fillColor: Colors.white12,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              validator: (String arg) {
                                if (arg == null) {
                                  return "please enter OTP";
                                } else if (arg.length != 6) {
                                  return "otp should be 6 digits";
                                }
                                return null;
                              },
                              focusNode: f2,
                              onChanged: (String newVal) {
                                if (newVal.length == 6) {
                                  f2.unfocus();
                                  //FocusScope.of(context).requestFocus(f3);
                                }
                              },
                              //enabled: true,
                              controller: _otp,
                              keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xffdaa520)),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(25.7),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xffdaa520)),
                                  borderRadius: BorderRadius.circular(25.7),
                                ),
                                labelText: "OTP",
                                labelStyle: TextStyle(
                                  color: Color(0xffdaa520),
                                ),
                                filled: true,
                                hintText: "Enter OTP e.g.123456",
                                hintStyle:
                                    new TextStyle(color: Color(0xffdaa520)),
                                fillColor: Colors.white12,
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            new RaisedButton(
                              color: Color(0xffdaa520),
                              textColor: Color(0xffdaa520),
                              child: Text(
                                "Submit",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              padding: EdgeInsets.all(10),
                              elevation: 10,
                              onPressed: () {
                                setState(() {
                                  smsCode = _otp.text;
                                });
                                if (_formKey.currentState.validate()) {
                                  try {
                                    AuthCredential phoneAuthCredential =
                                        PhoneAuthProvider.credential(
                                            verificationId: verificationCode,
                                            smsCode: smsCode);
                                    FirebaseAuth.instance
                                        .signInWithCredential(
                                            phoneAuthCredential)
                                        .then((user) => {
                                              if (user != null)
                                                {
                                                  CircularProgressIndicator(),
                                                  Navigator.pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Home()),
                                                      (route) => false)
                                                }
                                              else
                                                {
                                                  Fluttertoast.showToast(
                                                      msg: "Entered Wrong Otp")
                                                }
                                            });
                                  } catch (e) {
                                    Fluttertoast.showToast(
                                        msg: "Entered Wrong Otp");
                                  }
                                }
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            SizedBox(
                              height: 60,
                            ),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  text:
                                      "By creating an account, you are agreeing to our\n",
                                  style: Theme.of(context).textTheme.bodyText1,
                                  children: [
                                    TextSpan(
                                        text: "Term and Conditions ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return PolicyDialog(
                                                    mdFileName:
                                                        "term_and_condition.md",
                                                  );
                                                });
                                          }),
                                    TextSpan(
                                        text: "Privacy Policy, \n",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return PolicyDialog(
                                                    mdFileName:
                                                        "privacy_policy.md",
                                                  );
                                                });
                                          }),
                                    TextSpan(
                                        text: "Refund/cancellation policy \n",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return PolicyDialog(
                                                    mdFileName:
                                                        "privacy_policy.md",
                                                  );
                                                });
                                          }),
                                    TextSpan(text: "\n"),
                                  ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  cAvatar() {
    return CircleAvatar(
      backgroundColor: Color(0xffefefcd),
      radius: 50,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Image.asset("image/logo.png"),
      ),
    );
  }

  openTermandCondition() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(""),
          );
        });
  }

  Future _submit() async {
    final PhoneVerificationCompleted verificationSuccess =
        (AuthCredential credential) {
      Fluttertoast.showToast(
        msg: "OTP sent",
        backgroundColor: Color(0xffdaa520),
      );
    };

    final PhoneVerificationFailed phoneVerificationFailed =
        (FirebaseAuthException exception) {
      Fluttertoast.showToast(
        msg: "Verification failed",
        backgroundColor: Color(0xffdaa520),
      );
    };
    final PhoneCodeSent phoneCodeSent = (String verId, [int forceCodeResend]) {
      verificationCode = verId;
      // smsCodeDailog(context).then((value) => Fluttertoast.showToast(msg: "OTP sent",backgroundColor: Color(0xffdaa520)));
    };
    final PhoneCodeAutoRetrievalTimeout autoRetrivalTimeout = (String verId) {
      this.verificationCode = verId;
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+91" + _number.text,
      timeout: const Duration(seconds: 120),
      verificationCompleted: verificationSuccess,
      verificationFailed: phoneVerificationFailed,
      codeSent: phoneCodeSent,
      codeAutoRetrievalTimeout: autoRetrivalTimeout,
    );
  }
}
