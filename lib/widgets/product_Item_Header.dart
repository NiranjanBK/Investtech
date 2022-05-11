import 'package:flutter/material.dart';

class ProductHeader extends StatelessWidget {
  final String title;
  final int seeAll;

  ProductHeader(this.title, this.seeAll);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15, bottom: 10, left: 10, right: 10),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.grey[600]),
          ),
          Text(
            seeAll == 1 ? 'See all' : '',
            style: TextStyle(color: Colors.orange[800]),
          ),
        ],
      ),
    );
  }
}
