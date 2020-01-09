import 'dart:async';
import 'package:flutter/material.dart';
import 'rest_api.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<Customer> customer;

  @override
  void initState() {
    super.initState();
    customer = ApiService.getCustomer();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Fetch Data Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text('Customer Details'),
          ),
          body: Center(
            child: FutureBuilder<Customer>(
              future: customer,
              builder: (context, snapshot) {
                final customers = snapshot.data;
                if (snapshot.hasData) {
                  // return Text('Data : ${snapshot.data.contractdetails}');
                  return ListView.separated(
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 2,
                        color: Colors.black,
                      );
                    },
                    itemBuilder: (context, index) {
                      return SingleChildScrollView(
                          child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(children: <Widget>[
                                Text("Contract Details"),
                                Card(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                      ListTile(
                                        title: Text("${(index + 1)}"),
                                        subtitle: Text(
                                            'Company Name: \n${customers.contractdetails[index].companyName} \n'
                                            'Contract UUID: \n${customers.contractdetails[index].contractUUID}'),
                                      )
                                    ]))
                              ])));
                    },
                    itemCount: customers.contractdetails.length,
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                // By default, show a loading spinner.
                return CircularProgressIndicator();
              },
            ),
          ),
        ));
  }
}
