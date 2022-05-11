import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investtech_app/network/api_repo.dart';
import 'package:investtech_app/ui/blocs/serach_bloc.dart';
import 'package:investtech_app/ui/search_item_page.dart';
import 'package:investtech_app/ui/settings_page.dart';

class Subscription extends StatelessWidget {
  const Subscription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey[800]),
        backgroundColor: Colors.white,
        title: const Text(
          'Subscription',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return BlocProvider(
                    create: (BuildContext context) => SearchBloc(ApiRepo()),
                    child: SearchItemPage(context),
                  );
                },
              ));
            },
            icon: Icon(
              Icons.search,
              color: Colors.orange[800],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.refresh,
              color: Colors.orange[800],
            ),
          ),
          PopupMenuButton(
            onSelected: (value) {
              switch (value) {
                case 'Settings':
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(),
                      ));
                  break;
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                height: 30,
                value: 'Manage',
                child: Text(
                  'Manage',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              const PopupMenuItem(
                height: 30,
                value: 'Settings',
                child: Text(
                  'Settings',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Text('hello'),
    );
  }
}
