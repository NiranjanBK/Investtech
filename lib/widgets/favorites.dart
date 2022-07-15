import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:investtech_app/const/colors.dart';
import 'package:investtech_app/network/api_repo.dart';

import 'package:investtech_app/network/models/company.dart';
import 'package:investtech_app/ui/blocs/serach_bloc.dart';

import 'package:investtech_app/ui/favourites_detail_page.dart';
import 'package:investtech_app/ui/search_item_page.dart';
import 'package:investtech_app/widgets/favourites_list.dart';

import 'package:investtech_app/widgets/product_Item_Header.dart';

class FavoritesTeaser extends StatefulWidget {
  final dynamic favObj;

  const FavoritesTeaser(this.favObj, {Key? key}) : super(key: key);

  @override
  State<FavoritesTeaser> createState() => _FavoritesTeaserState();
}

class _FavoritesTeaserState extends State<FavoritesTeaser> {
  @override
  Widget build(BuildContext context) {
    var _favCompanies =
        jsonDecode(jsonEncode(widget.favObj))['content']['company'] as List;
    List<Company> favCmpObj =
        _favCompanies.map((favJson) => Company.fromJson(favJson)).toList();

    var itemCount = favCmpObj.length > 5 ? 5 : favCmpObj.length;

    return Expanded(
      child: ListView(
        primary: true,
        shrinkWrap: true,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FavoritesDetail(favCmpObj)),
              );
            },
            child: ProductHeader(AppLocalizations.of(context)!.favourites,
                itemCount == 0 ? 0 : 1),
          ),
          itemCount == 0
              ? Container(
                  height: 90,
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.empty_favorites,
                          textAlign: TextAlign.center,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return BlocProvider(
                                  create: (BuildContext context) =>
                                      SearchBloc(ApiRepo()),
                                  child: SearchItemPage(context),
                                );
                              },
                            ));
                          },
                          child: Text(
                            AppLocalizations.of(context)!
                                .add_favorites
                                .toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(
                                ColorHex.ACCENT_COLOR,
                              ),
                            ),
                          ),
                        )
                      ]),
                )
              : FavoritesList(favCmpObj, itemCount),
        ],
      ),
    );
  }
}
