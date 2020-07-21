import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QrForm extends StatefulWidget {
  QrForm(this.qrFunction, this.dataString);

  final String dataString;

  final void Function(
    BuildContext ctx,
    String username,
    String type,
    String holderName,
    String contactName,
    String phoneNumber,
    String email,
    String url,
    String details,
    bool showQr,
  ) qrFunction;

  @override
  _QrFormState createState() => _QrFormState();
}

class _QrFormState extends State<QrForm> {
  final _formKey = GlobalKey<FormState>();

  String _qrFormUsername;
  String _qrFormType;
  String _qrFormPhoneNumber;
  String _qrFormContactName;
  String _qrFormHolderName;
  String _qrFormEmail;
  String _qrFormUrl;
  String _qrFormDetails;

  bool _showQrCode = false;

  TextEditingController emailController;
  TextEditingController phoneNumberController;
  TextEditingController contactNameController;
  TextEditingController holderNameController;
  TextEditingController detailsController;

  SharedPreferences sharedPreferences;

  var _dataQr = {
    "type": "",
    "holderName": "",
    "contactName": "",
    "username": "",
    "url": "",
    "email": "",
    "phoneNumber": "",
    "details": "",
  };

  List<String> _holderTypes = ["Elder", "Adult", "Child", "Animal"];

  @override
  void initState() {
    super.initState();
    readLocal();
  }

  void readLocal() async {
    sharedPreferences = await SharedPreferences.getInstance();

    _qrFormUsername = sharedPreferences.getString("username") ?? "";
    _qrFormEmail = sharedPreferences.getString("email") ?? "";
    _qrFormPhoneNumber = sharedPreferences.getString("phoneNumber") ?? "";
    _qrFormContactName = (sharedPreferences.getString("firstName") +
            " " +
            sharedPreferences.getString("lastName")) ??
        "";
    _qrFormHolderName = "";
    _qrFormUrl = widget.dataString;
    _qrFormDetails = "";

    emailController = TextEditingController(text: _qrFormEmail);
    phoneNumberController = TextEditingController(text: _qrFormPhoneNumber);
    contactNameController = TextEditingController(text: _qrFormContactName);
    holderNameController = TextEditingController(text: _qrFormHolderName);
    detailsController = TextEditingController(text: _qrFormDetails);

    setState(() {});
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _showQrCode = true;
      _formKey.currentState.save();
      widget.qrFunction(
        context,
        _qrFormUsername,
        _qrFormType.trim(),
        _qrFormHolderName.trim(),
        _qrFormContactName.trim(),
        _qrFormPhoneNumber.trim(),
        _qrFormEmail.trim(),
        _qrFormUrl,
        _qrFormDetails.trim(),
        _showQrCode,
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Card(
          margin: EdgeInsets.all(20),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  DropdownButtonFormField(
                    hint: Text("Please choose a holder type"),
                    value: _qrFormType,
                    onChanged: (newValue){
                      setState(() {
                        _qrFormType = newValue;
                      });
                    },
                    items: _holderTypes.map((type) {
                      return DropdownMenuItem(
                        child: Text(type),
                        value: type,
                      );
                    }).toList(),
                    validator: validateDropDown,
                  ),
                  Container(
                    child: Text(
                      "Contact Name",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                    margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
                  ),
                  Container(
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(primaryColor: Theme.of(context).primaryColor),
                      child: TextFormField(
                        key: ValueKey("contactName"),
                        validator: validateName,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText:
                              "Enter the name of the person who will be contacted",
                          contentPadding: EdgeInsets.all(5.0),
                          hintStyle: TextStyle(
                            color: Colors.grey[300],
                          ),
                        ),
                        controller: contactNameController,
                        onSaved: (value) {
                          _qrFormContactName = value;
                        },
                      ),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 30.0),
                  ),
                  Container(
                    child: Text(
                      "QR Holder's Name",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                    margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
                  ),
                  Container(
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(primaryColor: Theme.of(context).primaryColor),
                      child: TextFormField(
                        key: ValueKey("holderName"),
                        validator: validateName,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText:
                          "Enter the name of the recipient of this QR code",
                          contentPadding: EdgeInsets.all(5.0),
                          hintStyle: TextStyle(
                            color: Colors.grey[300],
                          ),
                        ),
                        controller: holderNameController,
                        onSaved: (value) {
                          _qrFormHolderName = value;
                        },
                      ),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 30.0),
                  ),
                  Container(
                    child: Text(
                      "Contact Email Address",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                    margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
                  ),
                  Container(
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(primaryColor: Theme.of(context).primaryColor),
                      child: TextFormField(
                        key: ValueKey("email"),
                        validator: validateEmail,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText:
                          "Enter the email address for the contact",
                          contentPadding: EdgeInsets.all(5.0),
                          hintStyle: TextStyle(
                            color: Colors.grey[300],
                          ),
                        ),
                        controller: emailController,
                        onSaved: (value) {
                          _qrFormEmail = value;
                        },
                      ),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 30.0),
                  ),
                  Container(
                    child: Text(
                      "Contact Phone Number",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                    margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
                  ),
                  Container(
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(primaryColor: Theme.of(context).primaryColor),
                      child: TextFormField(
                        key: ValueKey("phoneNumber"),
                        validator: validatePhoneNumber,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText:
                          "Enter the name of the recipient of this QR code",
                          contentPadding: EdgeInsets.all(5.0),
                          hintStyle: TextStyle(
                            color: Colors.grey[300],
                          ),
                        ),
                        controller: phoneNumberController,
                        onSaved: (value) {
                          _qrFormPhoneNumber = value;
                        },
                      ),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 30.0),
                  ),
                  Container(
                    child: Text(
                      "Description",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                    margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
                  ),
                  Container(
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(primaryColor: Theme.of(context).primaryColor),
                      child: TextFormField(
                        key: ValueKey("details"),
                        validator: validateDescription,
                        keyboardType: TextInputType.text,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText:
                          "Please enter a short description of the QR Holder",
                          contentPadding: EdgeInsets.all(5.0),
                          hintStyle: TextStyle(
                            color: Colors.grey[300],
                          ),
                        ),
                        controller: detailsController,
                        onSaved: (value) {
                          _qrFormDetails = value;
                        },
                      ),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 30.0),
                  ),
                  Container(
                    child: FlatButton(
                      onPressed: _trySubmit,
                      child: Text(
                        "Submit",
                        style: TextStyle(fontSize: 16.0),
                      ),
                      color: Theme.of(context).primaryColor,
                      splashColor: Colors.transparent,
                      textColor: Colors.black,
                      padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 50.0),
                  ),

                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
          ),
        ),
      ),
    );
  }
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }
  String validateName(String value){
    if (value.length <= 1)
      return 'Display Name must be more than 4 characters long!';
    else
      return null;
  }
  String validateDropDown(String value){
    if(value.isEmpty){
      return "Please choose an option in the drop down";
    }
    else return null;
  }
  String validatePhoneNumber(String value) {
    String pattern = r'(^([0-9]{10}$))';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Please enter phone number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid phone number';
    }
    return null;
  }
  String validateDescription(String value){
    if(value.length < 10){
      return "Please enter a description of more than 10 characters";
    }else return null;
  }
}
