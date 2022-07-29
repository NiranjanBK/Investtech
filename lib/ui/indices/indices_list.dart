import 'package:flutter/material.dart';
import 'package:investtech_app/network/models/evaluation.dart' as title;
import 'package:investtech_app/ui/company%20page/company_page.dart';

class IndicesList extends StatelessWidget {
  final List<title.Title> _indicesEvaluation;
  final int itemCount;
  String? page;

  IndicesList(this._indicesEvaluation, this.itemCount, {Key? key, this.page})
      : super(key: key);

  displayArrow(int evalCode) {
    if (evalCode > 0) {
      return Image.asset(
        'assets/images/arrow_green.png',
        width: 20,
        height: 20,
      );
    } else if (evalCode == 0) {
      return Image.asset(
        'assets/images/arrow_yellow.png',
        width: 20,
        height: 20,
      );
    } else {
      return Image.asset(
        'assets/images/arrow_red.png',
        width: 20,
        height: 20,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemCount: itemCount,
      itemBuilder: (ctx, index) {
        return Table(
          children: [
            TableRow(
                // decoration: const BoxDecoration(
                //     border: Border(
                //         bottom: BorderSide(color: Colors.grey, width: 0.2))),
                children: [
                  if (page == 'detail') ...{
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CompanyPage(
                                _indicesEvaluation[index].companyId,
                                4,
                              ),
                            ));
                      },
                      child: Text(
                        _indicesEvaluation[index].ticker,
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                    Text(
                      double.parse(
                        _indicesEvaluation[index].close,
                      ).toStringAsFixed(2),
                      style: const TextStyle(fontSize: 11),
                    ),
                    Text(
                      double.parse(_indicesEvaluation[index].change)
                          .toStringAsFixed(2),
                      style: const TextStyle(fontSize: 11),
                    ),
                    displayArrow(
                      int.parse(_indicesEvaluation[index].short),
                    ),
                    displayArrow(int.parse(_indicesEvaluation[index].medium)),
                    displayArrow(int.parse(_indicesEvaluation[index].long)),
                  } else ...{
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CompanyPage(
                                _indicesEvaluation[index].companyId,
                                4,
                              ),
                            ));
                      },
                      child: Text(
                        _indicesEvaluation[index].ticker,
                      ),
                    ),
                    displayArrow(int.parse(_indicesEvaluation[index].short)),
                    displayArrow(int.parse(_indicesEvaluation[index].medium)),
                    displayArrow(int.parse(_indicesEvaluation[index].long)),
                  }
                ])
          ],
        );
      },
    );
  }
}
