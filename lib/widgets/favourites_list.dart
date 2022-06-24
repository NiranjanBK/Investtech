import 'package:flutter/material.dart';
import 'package:investtech_app/network/models/company.dart';
import 'package:investtech_app/ui/company_page.dart';

class FavoritesList extends StatelessWidget {
  List<Company> favCmpObj;
  int favCount;
  FavoritesList(this.favCmpObj, this.favCount, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    favCmpObj[index].ticker,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    favCmpObj[index].Name.toString(),
                    style: TextStyle(),
                  ),
                ],
              ),
              new Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    double.parse((favCmpObj[index].closePrice.toString()))
                        .toStringAsFixed(2),
                    style: TextStyle(
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
                            ? Colors.green[900]
                            : Colors.red[900]),
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
