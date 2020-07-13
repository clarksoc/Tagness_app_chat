import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserForm extends StatefulWidget {
  UserForm(
    this.uploadFunction,
    this.isLoading,
  );


  final bool isLoading;

  final void Function(
    BuildContext ctx,
    String username,
    String email,
    String phoneNumber,
    String firstName,
    String lastName,
  ) uploadFunction;

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {

  final _formKey = GlobalKey<FormState>();

  String _userUsername;
  String _userEmail;
  String _userPhoneNumber;
  String _userFirstName;
  String _userLastName;
  String _userId;

  TextEditingController usernameController;
  TextEditingController emailController;
  TextEditingController phoneNumberController;
  TextEditingController firstNameController;
  TextEditingController lastNameController;

  SharedPreferences sharedPreferences;


  @override
  void initState() {
    super.initState();
    readLocal();
  }

  void readLocal() async {
    sharedPreferences = await SharedPreferences.getInstance();

    _userId = sharedPreferences.getString("id") ?? "";
    _userUsername = sharedPreferences.getString("username") ?? "";
    _userEmail = sharedPreferences.getString("email") ?? "";
    _userPhoneNumber = sharedPreferences.getString("phoneNumber") ?? "";
    _userFirstName = sharedPreferences.getString("firstName") ?? "";
    _userLastName = sharedPreferences.getString("lastName") ?? "";

    usernameController = TextEditingController(text: _userUsername);
    emailController = TextEditingController(text: _userEmail);
    phoneNumberController = TextEditingController(text: _userPhoneNumber);
    firstNameController = TextEditingController(text: _userFirstName);
    lastNameController = TextEditingController(text: _userLastName);

    setState(() {});
    //print(username);

  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      widget.uploadFunction(
        context,
        _userUsername.trim(),
        _userEmail.trim(),
        _userPhoneNumber.trim(),
        _userFirstName.trim(),
        _userLastName.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Container(
                  child: Text(
                    "Username",
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
                      key: ValueKey("username"),
                      validator: validateUsername,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: "Update your username!",
                        contentPadding: EdgeInsets.all(5.0),
                        hintStyle: TextStyle(
                          color: Colors.grey[300],
                        ),
                      ),
                      controller: usernameController,
                      onSaved: (value) {
                        _userUsername = value;
                      },
                    ),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 30.0),
                ),
                Container(
                  child: Text(
                    "Email Address",
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
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Update your email!",
                        contentPadding: EdgeInsets.all(5.0),
                        hintStyle: TextStyle(
                          color: Colors.grey[300],
                        ),
                      ),
                      onSaved: (value) {
                        _userEmail = value;
                      },
                      controller: emailController,
                    ),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 30.0),
                ),
                Container(
                  child: Text(
                    "Phone Number",
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
                        hintText: "Update your phone number!",
                        contentPadding: EdgeInsets.all(5.0),
                        hintStyle: TextStyle(
                          color: Colors.grey[300],
                        ),
                      ),
                      controller: phoneNumberController,
                      onSaved: (value) {
                        _userPhoneNumber = value;
                      },
                    ),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 30.0),
                ),
                Container(
                  child: Text(
                    "First Name",
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
                      key: ValueKey("firstName"),
                      validator: validateName,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: "Update your first name!",
                        contentPadding: EdgeInsets.all(5.0),
                        hintStyle: TextStyle(
                          color: Colors.grey[300],
                        ),
                      ),
                      controller: firstNameController,
                      onSaved: (value) {
                        _userFirstName = value;
                      },
                    ),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 30.0),
                ),
                Container(
                  child: Text(
                    "Last Name",
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
                      key: ValueKey("lastName"),
                      validator: validateName,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: "Update your last name!",
                        contentPadding: EdgeInsets.all(5.0),
                        hintStyle: TextStyle(
                          color: Colors.grey[300],
                        ),
                      ),
                      controller: lastNameController,
                      onSaved: (value) {
                        _userLastName = value;
                      },
                    ),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 30.0),
                ),
                Container(
                  child: FlatButton(
                    onPressed: _trySubmit,
                    child: Text(
                      "UPDATE",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    color: Theme.of(context).primaryColor,
                    splashColor: Colors.transparent,
                    textColor: Colors.black,
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 50.0),
                )
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

  String validateUsername(String value) {
    if (value.length <= 4)
      return 'Username must be more than 4 characters long!';
    else
      return null;
  }

  String validateName(String value) {
    if (value.length <= 2)
      return 'Name must be more than 2 characters long!';
    else
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
}
