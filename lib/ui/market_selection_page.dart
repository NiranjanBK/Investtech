import 'package:flutter/material.dart';

class MarketSelection extends StatefulWidget {
  const MarketSelection({Key? key}) : super(key: key);

  @override
  _MarketSelectionState createState() => _MarketSelectionState();
}

class _MarketSelectionState extends State<MarketSelection> {
  List<Map> markets = [
    {'market': 'Mumbai S.E', 'marketCode': 'in_bse'},
    {'market': 'National S.E', 'marketCode': 'in_nse'},
    {'market': 'Oslo Bors', 'marketCode': 'ose'},
    {'market': 'Stockholm', 'marketCode': 'se_sse'},
    {'market': 'Kobenhavns', 'marketCode': 'dk_kfx'},
    {'market': 'DK Funds', 'marketCode': 'dk_inv'},
    {'market': 'Helsinki', 'marketCode': 'fi_hex'},
    {'market': 'AEX', 'marketCode': 'aex'},
    {'market': 'BSX', 'marketCode': 'bxs'},
    {'market': 'Uklse', 'marketCode': 'uk_lse'},
    {'market': 'US Stocks', 'marketCode': 'us_All'},
    {'market': 'Toronto Stock Exchange', 'marketCode': 'ca_tsx'},
    {'market': 'Crypto', 'marketCode': 'crypto'},
    {'market': 'Currency', 'marketCode': 'cur_cur'},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.separated(
          itemCount: markets.length,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.pop(context, markets[index]);
              },
              child: Row(
                children: [
                  Image.network(
                      'https://www.investtech.com/main/images/flags/h20/in.png'),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    markets[index]['market'],
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
