import 'package:flutter/material.dart';
import 'package:investtech_app/const/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Top20AdvanceChartSubscription extends StatefulWidget {
  final String title;
  final bool isTop20;
  const Top20AdvanceChartSubscription(this.title, this.isTop20, {Key? key})
      : super(key: key);

  @override
  State<Top20AdvanceChartSubscription> createState() =>
      _Top20AdvanceChartSubscriptionState();
}

class _Top20AdvanceChartSubscriptionState
    extends State<Top20AdvanceChartSubscription> {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final Map<String, List> top20Data = {
      'view1': [
        AppLocalizations.of(context)!.top20_in_app_desc_1.replaceAll('\\', ''),
        'app_ss_top20_list_en'
      ],
      'view2': [
        AppLocalizations.of(context)!.top20_in_app_desc_2,
        'app_ss_top20_detail_en'
      ]
    };

    final Map<String, List> advancedChart = {
      'view1': [
        AppLocalizations.of(context)!.advanced_charts_in_app_desc_1,
        'app_ss_ac_detail_en'
      ],
      'view2': [
        AppLocalizations.of(context)!.advanced_charts_in_app_desc_2,
        'app_ss_ac_search_en'
      ]
    };
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close),
        ),
        title: Text(widget.title),
      ),
      body: Stack(children: [
        PageView(
          controller: _pageController,
          children: [
            views(
                data: widget.isTop20 ? top20Data : advancedChart,
                view: 'view1'),
            views(
                data: widget.isTop20 ? top20Data : advancedChart,
                view: 'view2'),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Center(
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: 2,
                    effect: const WormEffect(
                        dotColor: Color(ColorHex.gray),
                        paintStyle: PaintingStyle.stroke,
                        dotWidth: 5,
                        dotHeight: 5,
                        activeDotColor: Color(ColorHex.gray)),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {},
                  child: Text(AppLocalizations.of(context)!.subscribe),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(ColorHex.ACCENT_COLOR)),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  AppLocalizations.of(context)!.auto_renew_message,
                  style: const TextStyle(
                      fontSize: 10, color: Color(ColorHex.GREY)),
                ),
              )
            ],
          ),
        )
      ]),
    );
  }
}

class views extends StatelessWidget {
  const views({Key? key, required this.data, required this.view})
      : super(key: key);

  final Map<String, List> data;
  final String view;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
        left: 10,
        right: 10,
      ),
      child: Column(
        children: [
          Text(
            data[view]![0],
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Color(ColorHex.DARK_GREY)),
          ),
          Container(
            height: 400,
            width: 500,
            padding: const EdgeInsets.only(top: 30, left: 10, right: 20),
            child: Image.asset(
              'assets/images/${data[view]![1]}.png',
            ),
          ),
        ],
      ),
    );
  }
}
