import 'package:flutter/material.dart';
import 'package:investtech_app/const/colors.dart';
import 'package:investtech_app/network/models/top20.dart';
import 'package:investtech_app/ui/company%20page/company_page.dart';

class Top20List extends StatelessWidget {
  final List<Top20> top20Obj;
  const Top20List(this.top20Obj);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: top20Obj.length,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (BuildContext context, int index) => const Divider(
        color: Colors.grey,
      ),
      itemBuilder: (ctx, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CompanyPage(
                    top20Obj[index].companyId,
                    4,
                    isTop20: true,
                    companyName: top20Obj[index].companyName,
                    ticker: top20Obj[index].ticker,
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
                    top20Obj[index].ticker,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    top20Obj[index].companyName,
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    double.parse((top20Obj[index].price)).toStringAsFixed(2),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${double.parse((top20Obj[index].changeVal))} (${double.parse((top20Obj[index].changePct)).toStringAsFixed(2)}%)',
                    style: TextStyle(
                        fontSize: 12,
                        color: double.parse((top20Obj[index].changeVal)) > 0
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
