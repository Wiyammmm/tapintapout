import 'package:flutter/material.dart';
import 'package:tapintapout/presentation/pages/loginPage.dart';

class DialogUtils {
  static Future<void> showLogout(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Logout',
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text('Enter Password to Logout'),
                  TextFormField(),
                  SizedBox(
                    height: 5,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text('VERIFY'))
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<void> showTapin(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Image.asset(
            'assets/filipaylogobanner.png',
            width: 70,
            height: 70,
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text('Your Traveled Fare is 30'),
                  Text(
                    'WELCOME!\nHAVE A SAFE RIDE',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<void> showTapout(
      BuildContext context, double remainingBalance) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Image.asset(
            'assets/filipaylogobanner.png',
            width: 70,
            height: 70,
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text('Your Traveled Fare is 30'),
                  Text('We had refund -17'),
                  Divider(),
                  Text('Remaining Balance: $remainingBalance'),
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xffd9d9d9),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Traveled Distance'),
                              Text('3'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Traveled Fare'),
                              Text('13'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Refund Amount'),
                              Text('17'),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
