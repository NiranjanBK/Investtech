import 'package:flutter/cupertino.dart';

class ControlledVisibility extends StatefulWidget {
  VisibilityController controller;
  Widget child;

  ControlledVisibility(this.controller, this.child);

  @override
  State<StatefulWidget> createState() => ControlledVisibilityState();
}

class VisibilityController extends ChangeNotifier {
  bool isVisible;
  bool maintainSize;

  VisibilityController(this.isVisible, {this.maintainSize = false});

  void setVisibility(bool isVisible) {
    this.isVisible = isVisible;
    notifyListeners();
  }
}

class ControlledVisibilityState extends State<ControlledVisibility> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() async {
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.controller.maintainSize && !widget.controller.isVisible
        ? IgnorePointer(
            ignoring: true,
            child: Opacity(
              opacity: 0,
              child: Visibility(
                  visible: widget.controller.isVisible, child: widget.child),
            ),
          )
        : Visibility(visible: widget.controller.isVisible, child: widget.child);
  }
}
