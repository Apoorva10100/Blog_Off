import 'package:blog_off/auth.dart';
import 'package:blog_off/dialogbox.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedIn;
  LoginPage({this.auth, this.onSignedIn});

  @override
  _LoginPageState createState() => _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  DialogBox dialog = DialogBox();
  final formKey = new GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String userId;
  String _email;
  String _password;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          userId = await widget.auth.signIn(_email, _password);
          //dialog.information(context, 'Congrats!', 'Logged in succesfully!');
        } else {
          userId = await widget.auth.signUp(_email, _password);
          //dialog.information(context, 'Congrats!', 'Account created!');
        }
        widget.onSignedIn();
      } catch (e) {
        dialog.information(context, 'Error', e.toString());
        print('Error signing in');
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flogger'),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body: Container(
        margin: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: getInput() + createButton(),
          ),
        ),
      ),
    );
  }

  List<Widget> getInput() {
    return [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          radius: 50.0,
          backgroundImage: AssetImage('assets/flogger.png'),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          decoration: InputDecoration(labelText: 'Email'),
          validator: (value) => value.isEmpty ? 'Email is empty' : null,
          onSaved: (value) => _email = value,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          decoration: InputDecoration(labelText: 'Password'),
          validator: (value) => value.isEmpty ? 'Email is empty' : null,
          onSaved: (value) => _password = value,
          obscureText: true,
        ),
      ),
    ];
  }

  List<Widget> createButton() {
    if (_formType == FormType.login) {
      return [
        RaisedButton(
          onPressed: () {
            validateAndSubmit();
          },
          child: Text('Login'),
          textColor: Colors.white,
          color: Colors.pink,
        ),
        FlatButton(
          onPressed: () {
            moveToRegister();
          },
          child: Text('New here? Create an account'),
        )
      ];
    } else {
      return [
        RaisedButton(
          onPressed: () {
            validateAndSubmit();
          },
          child: Text('Create account'),
          textColor: Colors.white,
          color: Colors.pink,
        ),
        FlatButton(
          onPressed: () {
            moveToLogin();
          },
          child: Text('Already have account? Login'),
        )
      ];
    }
  }
}
