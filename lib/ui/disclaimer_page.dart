import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        child: Text(AppLocalizations.of(context)!.full_disclaimer),
      ),
    );
  }
}
