import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otp/config/session_storage.dart';
import 'package:otp/homepage/home.dart';

class RaiseIssue extends StatefulWidget {
  _RaiseIssue createState() => _RaiseIssue();
}

class _RaiseIssue extends State<RaiseIssue> {
  var _formKey = GlobalKey<FormState>();
  TextEditingController _exartNeartestLocation = TextEditingController();
  TextEditingController _vehicleNumber = TextEditingController();
  TextEditingController _nameOfThePerson = TextEditingController();
  TextEditingController _contactNumber = TextEditingController();
  String _selectedNeartestLocation;
  String _problemOfTheVehicle;
  String _vehicleType;
  final towing = ["yes I need", "no, I need not"];
  int index = -1;
  bool isActivated = false;
  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  FocusNode f3 = FocusNode();
  String _ownerPhoneNumber;
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection("Enable").snapshots().listen((event) {
      event.docs.forEach((element) {
        setState(() {
          setState(() {
            isActivated = element.data()["isActive"];
          });
        });
      });
    });
    Storage()
        .getData("ownerContactNumber")
        .then((value) => _ownerPhoneNumber = value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Issue in Vehicle",
                      style: TextStyle(
                        fontFamily: "Marmelad",
                        fontSize: 25,
                        color: Color(0xffdaa520),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("Vehicle")
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError)
                            return Center(
                              child: Text("Some Error Came"),
                            );
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Color(0xffdaa520),
                              ),
                            );
                          }
                          return DropdownButton(
                            items: snapshot.data.docs.map((document) {
                              return DropdownMenuItem<String>(
                                value: document.data()["name"],
                                child: Text(document.data()["name"]),
                              );
                            }).toList(),
                            onChanged: (String val) {
                              setState(() {
                                _vehicleType = val;
                              });
                            },
                            hint:
                                Text('Select the vehicle name                '),
                            value: _vehicleType,
                          );
                        }),
                    SizedBox(
                      height: 16,
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("Location")
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError)
                            return Center(
                              child: Text("Some Error Came"),
                            );
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Color(0xffdaa520),
                              ),
                            );
                          }
                          return DropdownButton(
                            items: snapshot.data.docs.map((document) {
                              return DropdownMenuItem<String>(
                                value: document.data()["location"],
                                child: Text(document.data()["location"]),
                              );
                            }).toList(),
                            onChanged: (String val) {
                              setState(() {
                                _selectedNeartestLocation = val;
                              });
                            },
                            hint: Text('Select the Nearest Location      '),
                            value: _selectedNeartestLocation,
                          );
                        }),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _exartNeartestLocation,
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      enabled: true,
                      validator: (String arg) {
                        if (arg == null) {
                          return 'please enter the exart location';
                        } else
                          return null;
                      },
                      keyboardAppearance: Brightness.light,
                      decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffdaa520)),
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(25.7),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffdaa520)),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        labelText: "Exact Location",
                        labelStyle: TextStyle(
                          color: Color(0xffdaa520),
                        ),
                        filled: true,
                        hintText: "Enter the exact location",
                        hintStyle: new TextStyle(color: Color(0xffdaa520)),
                        fillColor: Colors.white12,
                        prefixIcon: Icon(
                          Icons.directions_bus,
                          color: Color(0xffdaa520),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    //problemName
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("TypeOfProblems")
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError)
                            return Center(
                              child: Text("Some Error Came"),
                            );
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Color(0xffdaa520),
                              ),
                            );
                          }
                          return DropdownButton(
                            items: snapshot.data.docs.map((document) {
                              return DropdownMenuItem<String>(
                                value: document.data()["problemName"],
                                child: Text(document.data()["problemName"]),
                              );
                            }).toList(),
                            onChanged: (String val) {
                              setState(() {
                                _problemOfTheVehicle = val;
                              });
                            },
                            hint:
                                Text('Select the problem of vehicle         '),
                            value: _problemOfTheVehicle,
                          );
                        }),
                    SizedBox(
                      height: 16,
                    ),
                    Text("Accidental case? Want Towing"),
                    ListTile(
                      title: Text("yes, I need"),
                      leading: Radio(
                        groupValue: index,
                        value: 0,
                        onChanged: (value) {
                          setState(() {
                            index = value;
                            print(value);
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: Text("no, I need not"),
                      leading: Radio(
                        groupValue: index,
                        value: 1,
                        onChanged: (value) {
                          setState(() {
                            index = value;
                            print(value);
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _vehicleNumber,
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      enabled: true,
                      onChanged: (String newVal) {
                        if (newVal.length == 9) {
                          f1.unfocus();
                          FocusScope.of(context).requestFocus(f2);
                        }
                      },
                      validator: (String arg) {
                        if (arg == null) {
                          return 'please enter the vehicle number';
                        } else
                          return null;
                      },
                      keyboardAppearance: Brightness.light,
                      decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffdaa520)),
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(25.7),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffdaa520)),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        labelText: "Vehicle Number",
                        labelStyle: TextStyle(
                          color: Color(0xffdaa520),
                        ),
                        filled: true,
                        hintText: "Enter Vehicle Number",
                        hintStyle: new TextStyle(color: Color(0xffdaa520)),
                        fillColor: Colors.white12,
                        prefixIcon: Icon(
                          Icons.directions_bus,
                          color: Color(0xffdaa520),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16, // //  //
                    ),
                    TextFormField(
                      validator: (String arg) {
                        if (arg == null) {
                          return "please enter the name";
                        } else {
                          return null;
                        }
                      },
                      focusNode: f2,
                      onChanged: (String newVal) {
                        if (newVal.length == 10) {
                          f2.unfocus();
                          FocusScope.of(context).requestFocus(f3);
                        }
                      },
                      keyboardAppearance: Brightness.light,
                      controller: _nameOfThePerson,
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffdaa520)),
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(25.7),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffdaa520)),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        labelText: "Driver's Name*",
                        labelStyle: TextStyle(
                          color: Color(0xffdaa520),
                        ),
                        filled: true,
                        hintText: "Enter your Driver's Name",
                        hintStyle: new TextStyle(color: Color(0xffdaa520)),
                        fillColor: Colors.white12,
                        prefixIcon: Icon(
                          Icons.person,
                          color: Color(0xffdaa520),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16, //
                    ),
                    TextFormField(
                      validator: (String arg) {
                        if (arg == null) {
                          return "please enter driver's name";
                        } else {
                          return null;
                        }
                      },
                      focusNode: f3,
                      onChanged: (String newVal) {
                        if (newVal.length == 10) {
                          f3.unfocus();
                          // FocusScope.of(context).requestFocus(f3);
                        }
                      },
                      controller: _contactNumber,
                      maxLines: 1,
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffdaa520)),
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(25.7),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffdaa520)),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        labelText: "Driver's Contact Number*",
                        labelStyle: TextStyle(
                          color: Color(0xffdaa520),
                        ),
                        filled: true,
                        hintText: "Enter driver's contact number",
                        hintStyle: new TextStyle(color: Color(0xffdaa520)),
                        fillColor: Colors.white12,
                        prefixIcon: Icon(
                          Icons.contacts,
                          color: Color(0xffdaa520),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30, //
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
                      onPressed: () async {
                        CircularProgressIndicator(
                          backgroundColor: Color(0xffdaa520),
                          strokeWidth: 5,
                        );
                        try {
                          final result =
                              await InternetAddress.lookup('google.com');
                          if (result.isNotEmpty &&
                              result[0].rawAddress.isNotEmpty) {
                            if (_formKey.currentState.validate()) {
                              if (isActivated) {
                                try {
                                  final _ref = FirebaseFirestore.instance;
                                  Map<String, dynamic> alarm = {
                                    "nearestLocation":
                                        _selectedNeartestLocation,
                                    "exartLocation":
                                        _exartNeartestLocation.text,
                                    "problemOfTheVehicle": _problemOfTheVehicle,
                                    "vehicleNumber": _vehicleNumber.text,
                                    "nameOfTheDriver": _nameOfThePerson.text,
                                    "driverContactNumber": _contactNumber.text,
                                    "vehicleType": _vehicleType,
                                    "ownerNumber": _ownerPhoneNumber,
                                    "isPaid": false,
                                    "createdDate":
                                        new DateTime.now().toString(),
                                    "amountToBePaid": 0.0,
                                    "ammountAssigned": false,
                                    "spearParts": "Pending",
                                    "finalPaid": false,
                                    "towing": towing[index],
                                  };
                                  _ref
                                      .collection("alarms")
                                      .add(alarm)
                                      .then((user) => showDialog(
                                          context: this.context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                "We will contact you shortly",
                                                style: TextStyle(
                                                  color: Color(0xffdaa520),
                                                ),
                                              ),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text("OK"),
                                                  onPressed: () {
                                                    CircularProgressIndicator(
                                                      backgroundColor:
                                                          Color(0xffdaa520),
                                                      strokeWidth: 5,
                                                    );
                                                    Navigator
                                                        .pushAndRemoveUntil(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Home()),
                                                            (route) => false);
                                                  },
                                                ),
                                              ],
                                            );
                                          }));
                                } catch (e) {
                                  print(e);
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Currently Service is not available",
                                    backgroundColor: Color(0xffdaa520));
                              }
                            }
                          }
                        } on SocketException catch (_) {
                          Fluttertoast.showToast(msg: "No Internet Connection");
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
