import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class URLS {
  // the URL of the Web Server
  static const String BASE_URL = 'https://tisapi.azurewebsites.net';

  // the storage key for the token
  static const String _storageKeyMobileToken = "token";
}

class ApiService {
  /// ----------------------------------------------------------
  /// Method that returns the token from Shared Preferences
  /// ----------------------------------------------------------

  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static Future<String> _getMobileToken() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(URLS._storageKeyMobileToken) ?? '';
  }

  /// ----------------------------------------------------------
  /// Method that saves the token in Shared Preferences
  /// ----------------------------------------------------------
  static Future<bool> _setMobileToken(String token) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString(URLS._storageKeyMobileToken, token);
  }

  /// ----------------------------------------------------------
  /// Method that do an authentication
  /// ----------------------------------------------------------
  static Future<String> doAuthentication(useremail, userpass) async {
    String _status = "ERROR";

    Map params = {"UserName": useremail, "Password": userpass};

    //encode params to JSON
    var body = json.encode(params);

    final response = await http.post('${URLS.BASE_URL}/auth/createtoken',
        body: body, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 201) {
      //encode Map to JSON
      Map data = json.decode(response.body);
      _status = data["status"];

      if (_status == "1") {
        await _setMobileToken(data["token"]);
      } else {
        await _setMobileToken("");
      }

      return _status;
    } else {
      return "ERROR";
    }
  }

  /// ----------------------------------------------------------
  /// Method that retrieve customer info
  /// ----------------------------------------------------------
  static Future<Customer> getCustomer() async {
    String token = await _getMobileToken();

    final response = await http
        .get('https://tisapi.azurewebsites.net/api/customer', headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    });

    if (response.statusCode == 201) {
      // If the call to the server was successful, parse the JSON.
      final responseJson = json.decode(response.body);
      print(response.body);
      return Customer.fromJson(responseJson);
    } else {
      // If that call was not successful, throw an error.
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Failed to load post');
      return null;
    }
  }
}

class Customer {
  final String status;
  final String usertype;
  final List<Contractdetail> contractdetails;

  Customer({this.status, this.usertype, this.contractdetails});

  factory Customer.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['contractdetails'] as List;
    print(list.runtimeType); //returns List<dynamic>
    List<Contractdetail> contractdetailslist =
        list.map((i) => Contractdetail.fromJson(i)).toList();

    var customer = Customer(
        status: parsedJson['status'],
        usertype: parsedJson['usertype'],
        contractdetails: contractdetailslist);
    return customer;
  }
}

class Contractdetail {
  final String companyName;
  final String contractUUID;
  final String rolename;
  final bool usetoken;
  final String startd;
  final String endd;

  Contractdetail(
      {this.companyName,
      this.contractUUID,
      this.rolename,
      this.usetoken,
      this.startd,
      this.endd});

  factory Contractdetail.fromJson(Map<String, dynamic> parsedJson) {
    return Contractdetail(
        companyName: parsedJson['companyName'],
        contractUUID: parsedJson['contractUUID'],
        rolename: parsedJson['rolename'],
        usetoken: parsedJson['usetoken'],
        startd: parsedJson['startd'],
        endd: parsedJson['endd']);
  }
}
