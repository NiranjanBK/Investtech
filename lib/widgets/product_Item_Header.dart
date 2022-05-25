import 'package:flutter/material.dart';

class ProductHeader extends StatelessWidget {
  final String? title;
  final int seeAll;

  ProductHeader(this.title, this.seeAll);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15, bottom: 10, left: 10, right: 10),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColorDark,
          border: const Border(bottom: BorderSide(color: Colors.black12))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title ?? '',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            seeAll == 1 ? 'See all' : '',
            style: const TextStyle(color: Color(0xFFFF6600)),
          ),
        ],
      ),
    );
  }
}
