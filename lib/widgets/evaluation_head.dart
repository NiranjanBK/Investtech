import 'package:flutter/material.dart';
import 'package:investtech_app/network/models/evaluation.dart';

class IndicesEvalTableHead extends StatelessWidget {
  final String? page;
  const IndicesEvalTableHead(
      {Key? key, required Evaluation indicesEvaluation, this.page})
      : _indicesEvaluation = indicesEvaluation,
        super(key: key);

  final Evaluation _indicesEvaluation;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
      child: Table(
        children: [
          TableRow(children: [
            if (page == 'detail') ...{
              Text(
                _indicesEvaluation.title.index,
                style: const TextStyle(fontSize: 10),
              ),
              Text(
                _indicesEvaluation.title.close,
                style: const TextStyle(fontSize: 10),
              ),
              Text(
                _indicesEvaluation.title.change,
                style: const TextStyle(fontSize: 10),
              ),
              Text(
                _indicesEvaluation.title.short,
                style: const TextStyle(fontSize: 10),
              ),
              Text(
                _indicesEvaluation.title.medium,
                style: const TextStyle(fontSize: 10),
              ),
              Text(
                _indicesEvaluation.title.long,
                style: const TextStyle(fontSize: 10),
              ),
            } else ...{
              Text(_indicesEvaluation.title.index),
              Text(_indicesEvaluation.title.short),
              Text(_indicesEvaluation.title.medium),
              Text(_indicesEvaluation.title.long),
            }
          ])
        ],
      ),
    );
  }
}
