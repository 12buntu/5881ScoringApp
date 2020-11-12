import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    // Provide the model to all widgets within the app. We're using
    // ChangeNotifierProvider because that's a simple way to rebuild
    // widgets when a model changes. We could also just use
    // Provider, but then we would have to listen to Counter ourselves.
    //
    // Read Provider's docs to learn about all the available providers.
    ChangeNotifierProvider(
      // Initialize the model in the builder. That way, Provider
      // can own Counter's lifecycle, making sure to call `dispose`
      // when not needed anymore.
      create: (context) => Notifier(),
      child: MyApp(),
    ),
  );
}

final storage = new Notifier();

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomAppBar(child: BottomBarCounter()),
        appBar: AppBar(title: Text("5881 WIP")),
        body: ListView(children: [
          Collapse(title: "Automated", subWidget: [
            CounterUpgrade(indexNumber: 0, verb: "Verb", object: "Noun"),
          ]),
          Collapse(title: "Driver Controlled", subWidget: [
            CounterUpgrade(indexNumber: 1, verb: "Verb", object: "Noun"),
          ]),
          Collapse(title: "Endgame", subWidget: [
            CounterUpgrade(indexNumber: 2, verb: "Verb", object: "Noun"),
          ])
        ]));
  }
}

/// This is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Team 5881 Calculator [WIP]';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(brightness: Brightness.dark),
      home: HomePage(),
    );
  }
}

//------------------

class Collapse extends StatelessWidget {
  const Collapse({
    Key key,
    this.title,
    this.subWidget,
  }) : super(key: key);

  final String title;
  final List<Widget> subWidget;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ExpansionTile(
      title: Text(title),
      children: subWidget,
    ));
  }
}

// class Counter extends StatefulWidget {
//   const Counter({Key key, this.indexNumber, this.verb}) : super(key: key);

//   final int indexNumber;
//   final String verb;
//   _CounterState createState() => _CounterState();
// }

// class _CounterState extends State<Counter> {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<Notifier>(builder: (context, counterList, child) {
//       return Text(
//           storage.counterList[widget.indexNumber](widget.indexNumber).toString() + " " + widget.verb);
//     });
//   }
// }

class CounterUpgrade extends StatefulWidget {
  const CounterUpgrade(
      {Key key, this.indexNumber, this.object, this.verb, this.value})
      : super(key: key);
  final int value;
  final int indexNumber;
  final String object;
  final String verb;
  @override
  _CounterUpgradeState createState() => _CounterUpgradeState();
}

class _CounterUpgradeState extends State<CounterUpgrade> {
  bool _isVisible;
  @override
  Widget build(BuildContext context) {
    if (storage.counterList[widget.indexNumber] != 0) {
      _isVisible = true;
    } else {
      _isVisible = false;
    }
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: _isVisible,
            child: Text(widget.object,
                style: TextStyle(fontSize: 10, color: Colors.grey)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DisplayDecide(
                  object: widget.object,
                  indexNumber: widget.indexNumber,
                  verb: widget.verb,
                  isVisible: this._isVisible),
              Wrap(
                children: [
                  Visibility(
                      visible: _isVisible,
                      child: IconButton(
                          splashRadius: 20,
                          icon: Icon(Icons.remove_circle_outline),
                          onPressed: () => {
                                setState(() {
                                  if (Notifier()
                                          .counterList[widget.indexNumber] ==
                                      0) {
                                    _isVisible = false;
                                  }
                                })
                              })),
                  IconButton(
                      splashRadius: 20,
                      icon: Icon(Icons.add_circle_outline),
                      onPressed: () {
                        var counter = context.read<Notifier>();
                        setState(() {
                          counter.addPoints(widget.indexNumber, widget.value);

                          if (storage.counterList[widget.indexNumber] != 0) {
                            _isVisible = true;
                          }
                        });
                      })
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

class DisplayDecide extends StatefulWidget {
  const DisplayDecide(
      {Key key,
      @required this.indexNumber,
      @required this.object,
      @required this.isVisible,
      @required this.verb})
      : super(key: key);
  final String verb;
  final String object;
  final int indexNumber;
  final bool isVisible;

  @override
  _DisplayDecideState createState() => _DisplayDecideState();
}

class _DisplayDecideState extends State<DisplayDecide> {
  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) {
      return Text(
        widget.object,
        //style: TextStyle(fontSize: 10, color: Colors.grey)
      );
    } else {
      return Consumer<Notifier>(builder: (context, counterList, child) {
        return Text(storage.counterList[widget.indexNumber].toString() +
            " " +
            widget.verb);
      });
    }
  }
}

class BottomBarCounter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Container(padding: EdgeInsets.fromLTRB(0, 20, 0, 20), child: Spacer()),
        Spacer(),
        Row(
          children: [
            Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Text(
                  "Total:",
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ),
              Row(children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: TotalSumWidget(),
                )
              ])
            ])
          ],
        ),

        Spacer()
      ],
    );
  }
}

class TotalSumWidget extends StatefulWidget {
  @override
  _TotalSumWidgetState createState() => _TotalSumWidgetState();
}

class _TotalSumWidgetState extends State<TotalSumWidget> {
  @override
  Widget build(BuildContext context) {
    return Text(storage.pointTotal().toString(),
        style: TextStyle(fontSize: 20));
  }
}

class Notifier with ChangeNotifier {
  List<int> counterList = [0, 0, 0, 0, 0, 0, 0, 0];
  int pointTotal() {
    return counterList.fold(0, (i, j) => i + j);
  }

  int getPoints(_index) {
    return counterList[_index];
  }

  void addPoints(int _index, int _value) {
    counterList[_index] += 1;
    notifyListeners();
  }

  void subtractPoints(int _index, int _value) {
    counterList[_index] -= _value;
    notifyListeners();
  }
}
