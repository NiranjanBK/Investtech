import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Slide extends StatelessWidget {
  final Color backGroundColor;
  final String imageName;
  final String title;
  final String description;
  const Slide(
      this.backGroundColor, this.imageName, this.title, this.description,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backGroundColor,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {},
                  child: Text(AppLocalizations.of(context)!.skip)),
            ],
          ),
          Image.asset(
            'assets/images/$imageName.PNG',
            width: 100,
            height: 100,
          ),
          Text(title),
          Text(description),
        ],
      ),
    );
  }
}
