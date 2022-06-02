import 'package:flutter/material.dart';
import 'package:investtech_app/network/models/top20.dart';
import 'package:investtech_app/ui/company_page_advanced.dart';
import 'package:investtech_app/widgets/product_Item_Header.dart';

class Top20List extends StatelessWidget {
  final List<Top20> top20Obj;
  const Top20List(this.top20Obj);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: top20Obj.length,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (ctx, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CompanyPageAdvance(top20Obj[index].companyId),
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
                    top20Obj[index].ticker,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    top20Obj[index].companyName,
                    style: TextStyle(),
                  ),
                ],
              ),
              new Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    double.parse((top20Obj[index].price)).toStringAsFixed(2),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${double.parse((top20Obj[index].changeVal))}(${double.parse((top20Obj[index].changePct)).toStringAsFixed(2)}%)',
                    style: TextStyle(
                        fontSize: 12,
                        color: double.parse((top20Obj[index].changeVal)) > 0
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
