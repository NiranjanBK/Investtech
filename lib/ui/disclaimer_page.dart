import 'package:flutter/material.dart';

class Disclaimer extends StatelessWidget {
  const Disclaimer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close),
        ),
        title: const Text('Disclaimer'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: const Text(
            'Investtech guarantees neither the entirety nor accuracy of the analyses. Any consequent exposure related to the advice/signals which emerge in the analyses is completely and entirely at the investors own expense and risk. Investtech is not responsible for any loss, either directly or indirectly, which arises as a result of the use of Investtech\'s analyses. Details of any arising conflicts of interest will always appear in the investment recommendations. Further information about Investtech\'s analyses can be found here www.investtech.com/disclaimer The content provided by Investtech.com is NOT SEC or FSA regulated and is therefore not intended for US or UK consumers.'),
      ),
    );
  }
}
