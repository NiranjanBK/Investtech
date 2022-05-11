import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/network/models/mc_detail.dart';
import 'package:investtech_app/ui/blocs/mc_bloc.dart';
import 'package:investtech_app/ui/mc_detail_page.dart';
import 'package:investtech_app/ui/mc_list_page.dart';

class MarketCommentaryMain extends StatelessWidget {
  final String title;
  MarketCommentaryDetail? mcData;
  int itemsOnStack = 0;
  int? index;
  static const list = "/list";
  static const detail = "/detail";
  final _navigatorKey = GlobalKey<NavigatorState>();

  MarketCommentaryMain(this.title, {Key? key, this.index}) : super(key: key);

  _mcDetail() {
    return MarketCommentaryDetailPage();
  }

  Route _onGenerateRoute(RouteSettings settings) {
    Widget? page;
    switch (settings.name) {
      case list:
        page = McListPage(() async {
          onMCListSelected();
        }, () {
          //Navigator.maybePop(context);
        });
        itemsOnStack++;
        break;
      case detail:
        page = _mcDetail();
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
    _navigatorKey.currentState?.pushNamed(detail);
  }

  void onScanCompleted() async {
    _navigatorKey.currentState?.pushNamed(detail);
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
          title: Text(title),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: BlocProvider<MarketCommentaryBloc>(
            create: (context) {
              return MarketCommentaryBloc(ApiRepo())
                ..add(MarketCommentaryBlocEvents.LOAD_MC)
                ..index = index ?? 0;
            },
            child: Navigator(
              key: _navigatorKey,
              initialRoute: index == null ? list : detail,
              onGenerateRoute: _onGenerateRoute,
              observers: [],
            ),
          ),
        ),
      ),
    );
  }
}
