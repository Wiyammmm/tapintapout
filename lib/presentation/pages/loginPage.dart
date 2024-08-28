import 'package:flutter/material.dart';
import 'package:tapintapout/presentation/pages/selectRoute.dart';

import 'package:tapintapout/presentation/widgets/base.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
        child: Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Image.asset(
            'assets/bg red-blue.png',
            fit: BoxFit.cover,
            // Adjust the height as needed
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/filipaylogo.png',
                width: MediaQuery.of(context).size.width * 0.5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mobile Number',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      TextFormField(),
                      const Text(
                        'Password',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      TextFormField(),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SelectRoutePage()),
                        );
                      },
                      child: const Text(
                        'LOG IN',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )))
            ],
          ),
        ),
      ],
    ));
  }
}
