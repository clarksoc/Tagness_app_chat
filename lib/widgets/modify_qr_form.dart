import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModifyQrForm extends StatefulWidget {
  ModifyQrForm(this.qrData, this.updateFunction, this.isLoading);

  final Map<String, dynamic> qrData;
  final bool isLoading;

  final void Function(BuildContext ctx, Map<String, dynamic> qrData)
      updateFunction;

  @override
  _ModifyQrFormState createState() => _ModifyQrFormState();
}

class _ModifyQrFormState extends State<ModifyQrForm>  {
  final _formKey = GlobalKey<FormState>();

  //Map<String, dynamic> qrData;

  TextEditingController holderNameController;
  TextEditingController emailController;
  TextEditingController phoneNumberController;
  TextEditingController contactNameController;
  TextEditingController detailsController;
  TextEditingController typeController;

  @override
  void initState() {
    super.initState();
    readLocal();
  }

  void readLocal() async {
    holderNameController =
        TextEditingController(text: widget.qrData["holderName"]);
    emailController = TextEditingController(text: widget.qrData["email"]);
    phoneNumberController =
        TextEditingController(text: widget.qrData["phoneNumber"]);
    contactNameController =
        TextEditingController(text: widget.qrData["contactName"]);
    detailsController = TextEditingController(text: widget.qrData["details"]);
    typeController = TextEditingController(text: widget.qrData["type"]);

    setState(() {});
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    setState(() {
      if (isValid) {
        _formKey.currentState.save();
        widget.updateFunction(context, widget.qrData);
      }
    });
  }

  List<String> _holderTypes = ["Elder", "Adult", "Child", "Animal"];

  @override
  Widget build(BuildContext context) {
    var qrData = widget.qrData;
    return Center(
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
                  key: ValueKey("type"),
                  value: qrData["type"].toString(),
                  items: _holderTypes.map((type) {
                    return DropdownMenuItem(
                      child: Text(type),
                      value: type,
                    );
                  }).toList(),
                  validator: validateDropDown,
                  onChanged: (value) {
                    qrData["type"] = value;
                  },
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
                        qrData["contactName"] = value;
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
                        qrData["holderName"] = value;
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
                        hintText: "Enter the email address for the contact",
                        contentPadding: EdgeInsets.all(5.0),
                        hintStyle: TextStyle(
                          color: Colors.grey[300],
                        ),
                      ),
                      controller: emailController,
                      onSaved: (value) {
                        qrData["email"] = value;
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
                        qrData["phoneNumber"] = value;
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
                        qrData["details"] = value;
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

  String validateName(String value) {
    if (value.length <= 1)
      return 'Display Name must be more than 4 characters long!';
    else
      return null;
  }

  String validateDropDown(String value) {
    if (value.isEmpty) {
      return "Please choose an option in the drop down";
    } else
      return null;
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

  String validateDescription(String value) {
    if (value.length < 10) {
      return "Please enter a description of more than 10 characters";
    } else
      return null;
  }
}
