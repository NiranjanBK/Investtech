import 'package:flutter/material.dart';
import 'package:investtech_app/const/colors.dart';
import 'package:investtech_app/network/models/company.dart';
import 'package:investtech_app/ui/company%20page/company_page.dart';

class FavoritesList extends StatelessWidget {
  List<Company> favCmpObj;
  int favCount;
  FavoritesList(this.favCmpObj, this.favCount, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shrinkWrap: true,
      itemCount: favCount,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (ctx, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CompanyPage(
                    favCmpObj[index].Id.toString(),
                    4,
                    companyName: favCmpObj[index].Name,
                    ticker: favCmpObj[index].ticker,
                  ),
                ));
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${index + 1}.',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    favCmpObj[index].ticker,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    favCmpObj[index].Name.toString(),
                    style: const TextStyle(),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    double.parse((favCmpObj[index].closePrice.toString()))
                        .toStringAsFixed(2),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${double.parse((favCmpObj[index].changeVal.toString()))}(${double.parse((favCmpObj[index].changePct)).toStringAsFixed(2)}%)',
                    style: TextStyle(
                        fontSize: 12,
                        color: double.parse(
                                    (favCmpObj[index].changeVal.toString())) >
                                0
                            ? const Color(ColorHex.green)
                            : const Color(ColorHex.red)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
