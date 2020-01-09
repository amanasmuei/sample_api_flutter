import 'package:flutter/material.dart';
import 'rest_api.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  _showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  _hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _doAuthenticate() async {
    print("go to authenticate");
    _showLoading();

    print(_emailController.text);
    print(_passwordController.text);

    final token = await ApiService.doAuthentication(
        _emailController.text, _passwordController.text);

    if (token == "1") {
      //final decodedtoken = jsonDecode(token);
      //print(decodedtoken['token']);
      _hideLoading();
      Navigator.pushNamed(context, '/home');
    } else {
      print('authentication failed');
    }

    _hideLoading();

    //Navigator.pushNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        //appBar: new AppBar(title: new Text('Demo')),
        body: SingleChildScrollView(
            child: new Material(
      child: _isLoading ? _loadingScreen() : _loginScreen(),
    )));
  }

  Widget _loadingScreen() {
    return new Container(
        margin: const EdgeInsets.only(top: 100.0),
        child: new Center(
            child: new Column(
          children: <Widget>[
            new CircularProgressIndicator(strokeWidth: 4.0),
            new Container(
              padding: const EdgeInsets.all(8.0),
              child: new Text(
                'Please Wait',
                style:
                    new TextStyle(color: Colors.grey.shade500, fontSize: 16.0),
              ),
            )
          ],
        )));
  }

  Widget _loginScreen() {
    Color hexToColor(String code) {
      return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
    }

    return new Container(
        padding: const EdgeInsets.all(30.0),
        color: Colors.white,
        child: new Container(
          child: new Center(
              child: new Column(children: [
            new Padding(padding: EdgeInsets.only(top: 140.0)),
            new Text(
              'Sample API',
              style:
                  new TextStyle(color: hexToColor("#F2A03D"), fontSize: 25.0),
            ),
            new Padding(padding: EdgeInsets.only(top: 50.0)),
            new TextFormField(
              decoration: new InputDecoration(
                labelText: "Enter Email",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: new BorderSide(),
                ),
                //fillColor: Colors.green
              ),
              controller: _emailController,
              validator: (val) {
                if (val.length == 0) {
                  return "Email cannot be empty";
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.emailAddress,
              style: new TextStyle(
                fontFamily: "Poppins",
              ),
            ),
            new Padding(padding: EdgeInsets.only(top: 15.0)),
            new TextFormField(
              decoration: new InputDecoration(
                labelText: "Enter Password",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: new BorderSide(),
                ),
                //fillColor: Colors.green
              ),
              controller: _passwordController,
              validator: (val) {
                if (val.length == 0) {
                  return "Email cannot be empty";
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.text,
              obscureText: true,
              style: new TextStyle(
                fontFamily: "Poppins",
              ),
            ),
            new Padding(padding: EdgeInsets.only(top: 24.0)),
            _customButton()
          ])),
        ));
  }

  Widget _customButton() {
    return Material(
      child: InkWell(
        // borderRadius: BorderRadius.circular(20),
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
            _doAuthenticate();
          }
        },
        splashColor: Colors.blue,
        highlightColor: Colors.blue,
        child: Container(
          height: 56,
          // width: 240,
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey),
          ),
          child: Center(
            child: Text("LOGIN"),
          ),
        ),
      ),
    );
  }
}
