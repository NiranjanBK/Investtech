import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/network/models/company.dart';
import 'package:investtech_app/network/models/mc_detail.dart';
import 'package:investtech_app/ui/blocs/mc_bloc.dart';
import 'package:investtech_app/ui/company%20page/company_page.dart';
import 'package:investtech_app/ui/market%20Commentary/mc_detail_page.dart';
import 'package:investtech_app/ui/market%20Commentary/mc_list_page.dart';

class MarketCommentaryMain extends StatefulWidget {
  final String title;
  int? index;
  static const list = "/list";
  static const detail = "/detail";
  static const company = "/company";

  MarketCommentaryMain(this.title, {Key? key, this.index}) : super(key: key);

  @override
  State<MarketCommentaryMain> createState() => _MarketCommentaryMainState();
}

class _MarketCommentaryMainState extends State<MarketCommentaryMain> {
  MarketCommentaryDetail? mcData;

  int itemsOnStack = 0;

  final _navigatorKey = GlobalKey<NavigatorState>();

  _mcDetail() {
    return MarketCommentaryDetailPage((context, companyId, name, ticker) async {
      _mcDetailCompany(companyId, name, ticker);
    }, () {
      //Navigator.maybePop(context);
    });
  }

  _mcDetailCompany(String companyId, name, ticker) {
    return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CompanyPage(companyId.toString(), 4,
              companyName: name, ticker: ticker),
        ));
  }

  Route _onGenerateRoute(RouteSettings settings) {
    Widget? page;
    switch (settings.name) {
      case MarketCommentaryMain.list:
        page = McListPage(() async {
          onMCListSelected();
        }, () {
          //Navigator.maybePop(context);
        });
        itemsOnStack++;
        break;
      case MarketCommentaryMain.detail:
        page = _mcDetail();
        itemsOnStack++;
        break;

      case MarketCommentaryMain.company:
        //page = _mcDetailCompany(compnayId);
        itemsOnStack++;
        break;
    }
    return _createRoute(page);
  }

  Route _createRoute(Widget? page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          page ?? Container(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  void onMCListSelected() async {
    _navigatorKey.currentState?.pushNamed(MarketCommentaryMain.detail);
  }

  void onMCTickerSelected(cmpId) async {
    _navigatorKey.currentState?.pushNamed(MarketCommentaryMain.detail);
  }

  void onScanCompleted() async {
    _navigatorKey.currentState?.pushNamed(MarketCommentaryMain.detail);
  }

  @override
  Widget build(BuildContext context) {
    // bloc = BlocProvider.of<Top20Bloc>(context);
    //bloc?.add(Top20BlocEvents.LOAD_TOP20);
    return WillPopScope(
      onWillPop: () async {
        if (itemsOnStack == 1) {
          return true;
        } else {
          _navigatorKey.currentState?.maybePop();
          itemsOnStack--;
        }
        return itemsOnStack == 2;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: BlocProvider<MarketCommentaryBloc>(
            create: (context) {
              return MarketCommentaryBloc(ApiRepo())
                ..add(MarketCommentaryBlocEvents.LOAD_MC)
                ..index = widget.index ?? 0;
            },
            child: Navigator(
              key: _navigatorKey,
              initialRoute: widget.index == null
                  ? MarketCommentaryMain.list
                  : MarketCommentaryMain.detail,
              onGenerateRoute: _onGenerateRoute,
              observers: [],
            ),
          ),
        ),
      ),
    );
  }
}
