import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:investtech_app/ui/indices_eval_detail_page.dart';
import 'package:investtech_app/widgets/evaluation_head.dart';
import 'package:investtech_app/widgets/indices_list.dart';
import 'package:investtech_app/widgets/product_Item_Header.dart';
import '../network/models/evaluation.dart';

class IndicesEvaluation extends StatefulWidget {
  final dynamic _evaluationData;

  IndicesEvaluation(this._evaluationData);

  @override
  State<IndicesEvaluation> createState() => _IndicesEvaluationState();
}

class _IndicesEvaluationState extends State<IndicesEvaluation> {
  @override
  Widget build(BuildContext context) {
    Evaluation _indicesEvaluation = Evaluation.fromJson(
        jsonDecode(jsonEncode(widget._evaluationData))['content']);

    // _indicesEvaluation.evaluation.insert(0, _indicesEvaluation.title);

    return Expanded(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => IndicesEvalDetailPage(jsonDecode(
                        jsonEncode(widget._evaluationData))['title'])),
              );
            },
            child: ProductHeader(
                jsonDecode(jsonEncode(widget._evaluationData))['title'], 1),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                IndicesEvalTableHead(indicesEvaluation: _indicesEvaluation),
                const SizedBox(
                  height: 5,
                ),
                IndicesList(_indicesEvaluation.evaluation!,
                    _indicesEvaluation.evaluation!.length),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
