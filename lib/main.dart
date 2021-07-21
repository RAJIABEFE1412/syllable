import 'dart:developer';

import 'package:flutter/material.dart';

import 'db.dart';
import 'history.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hausa Syllabicator',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Hausa Syllabicator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controller = TextEditingController();
  TextEditingController resultController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => History(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            DocMineTextField(
              hintText: "Enter Hausa statements",
              controller: controller,
              maxLines: 14,
            ),
            SizedBox(height: 20),
            DocMineTextField(
              maxLines: 14,
              controller: resultController,
              keyboardType: TextInputType.multiline,
              hintText: "Result",
              isEnabled: false,
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        label: Text("Syllabify"),
        onPressed: () async {
          String tword = controller.text.toLowerCase();

          resultController.text = "";
          resultController.clear();
          setState(() {});

          List<String> words = tword.split(" ");

          // List<ListItem> list = [];
          var vowels = "aeiou";
          for (var j = 0; j < words.length; j++) {
            resultController.text =  "${resultController.text}"" ";
            for (var i = 0; i < words[j].length; i++) {
              if (i == 0) {
                if (vowels.contains(words[j].substring(i, i + 1))) {
                  resultController.text = "${resultController.text}"
                      "${words[j].substring(i, i + 1)}"
                      "-";
                  continue;
                }
              }
              resultController.text = "${resultController.text}"
                  "${words[j].substring(i, i + 1)}";
              if (i != words[j].length - 1 &&
                  vowels.contains(words[j][i]) &&
                  !(vowels.contains(words[j][i + 1])) &&
                  !(vowels.contains(words[j][i - 1]))) {
                resultController.text = "${resultController.text}" "-";
              }
            }
          }
          setState(() {});
          // for (var word in words) {
          //   bool check = vowels.contains(word.substring(0, 1));
          //   if (check) {
          //     list.add(ListItem(0, word.substring(0, 1)));
          //   }
          //   for (var index = 0; index < word.length; index++) {
          //     if (word.substring(index, index + 1) == " ") continue;
          //     if (vowels.contains(word.substring(index, index + 1)) &&
          //         (!vowels.contains(word.substring(index - 1, index)))) {
          //       list.add(ListItem(index, word.substring(index, index + 1)));
          //     }
          //   }
          //   if (word.endsWith("a") ||
          //       word.endsWith("e") ||
          //       word.endsWith("i") ||
          //       word.endsWith("o") ||
          //       word.endsWith("u")) {
          //     list.removeLast();
          //   }
          //   if (list.isEmpty) {
          //     log("eror -- ");
          //     list.add(ListItem(0, word));
          //   }

          //   for (var i = 0; i < list.length; i++) {
          //     if (i == list.length - 1) {
          //       if (resultController.text.isEmpty) {
          //         resultController.text = "${word.substring(list[i].index)}";
          //       } else {
          //         resultController.text = "${resultController.text}"
          //             "-"
          //             "${word.substring(list[i].index)}";
          //       }
          //     } else {
          //       if (resultController.text.isEmpty) {
          //         resultController.text =
          //             "${word.substring(list[i].index, list[i + 1].index)}";
          //       } else {
          //         resultController.text = "${resultController.text}"
          //             "-"
          //             "${word.substring(list[i].index, list[i + 1].index)}";
          //       }
          //     }
          //   }
          // }

          // here uncomment
          //

          // resultController.text =
          //     "${tword.substring(0, 1)}" "${resultController.text}";
          //  resultController.text = "$count -- ${list.map((e) => e.string )} ${list.map((e) => e.index )}";

          // await DBProvider.db
          //     .newClient(Client(converted: resultController.text, text: tword))
          //     .then((_) => log("done..."));
          setState(() {});
        },
        tooltip: 'Convert to syllable',
        icon: Icon(
          Icons.done_outline_outlined,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class ListItem {
  final index;
  final string;

  ListItem(this.index, this.string);
}

class DocMineTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool isEnabled;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final bool showLabel;
  final Function onTap;
  final bool obscureText;
  final String hintText;
  final Widget suffix;
  final Widget suffixIcon;
  final Widget prefix;
  final TextAlignVertical textAlignVertical;
  // final OnValidate<String> validator;
  final TextInputType keyboardType;
  // final List<TextInputFormatter> inputFormatters;
  final int maxLines;
  final int maxLength;
  final Function(String) onChanged;
  final TextStyle style;
  final TextAlign textAlign;
  final String semanticsLabel;
  final bool _expands;
  TextEditingController get ctrl {
    return controller ?? TextEditingController();
  }

  const DocMineTextField({
    Key key,
    this.semanticsLabel,
    this.textInputAction,
    this.textCapitalization,
    this.controller,
    this.textAlignVertical,
    this.isEnabled = true,
    // this.inputFormatters,
    this.onTap,
    this.showLabel = true,
    this.hintText,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.maxLength,
    this.onChanged,
    this.obscureText = false,
    this.suffix,
    this.suffixIcon,
    this.prefix,
    // this.validator,
    this.keyboardType,
    this.style,
  })  : this._expands = false,
        super(key: key);

  const DocMineTextField.expand({
    Key key,
    this.semanticsLabel,
    this.textInputAction,
    this.textCapitalization,
    this.controller,
    this.textAlignVertical,
    this.isEnabled,
    // this.inputFormatters,
    this.onTap,
    this.showLabel = true,
    this.hintText,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.maxLength,
    this.onChanged,
    this.obscureText = false,
    this.suffix,
    this.suffixIcon,
    this.prefix,
    // this.validator,
    this.keyboardType,
    this.style,
  })  : this._expands = true,
        super(key: key);

  @override
  _DocMineTextFieldState createState() => _DocMineTextFieldState();
}

class _DocMineTextFieldState extends State<DocMineTextField>
    with WidgetsBindingObserver {
  final _inputFocus = FocusNode();
  // final ValueNotifier<FocusState> _hasFocus = ValueNotifier(FocusState());

  @override
  void initState() {
    super.initState();
    _inputFocus.addListener(
      () {
        // _hasFocus.value = FocusState(
        //   hasText:
        //       widget.ctrl != null && (widget.ctrl?.text?.isNotEmpty ?? false),
        //   isFocused: _inputFocus.hasFocus,
        // );
      },
    );
  }

  InputDecoration get decoration {
    return InputDecoration(
      filled: false,
      fillColor: Colors.transparent,
      border: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0,
        ),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0,
        ),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0,
        ),
      ),
      labelText: widget?.hintText ?? "",
      labelStyle: TextStyle(
        color: Colors.black.withOpacity(.4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final scaler = context.scaler;

    return IgnorePointer(
      ignoring: !(widget?.isEnabled ?? true),
      child: Semantics(
        label: widget?.semanticsLabel ?? "Input Field",
        child: Container(
          // padding: 10,
          // margin: scaler.insets.zero,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(
              15,
            ),
          ),
          child: TextFormField(
            showCursor: true,
            textAlign: widget.textAlign,
            textAlignVertical: widget.textAlignVertical,
            focusNode: _inputFocus,
            onTap: () {
              FocusScope.of(context).requestFocus(_inputFocus);
            },
            textInputAction: widget?.textInputAction ?? TextInputAction.done,
            textCapitalization:
                widget?.textCapitalization ?? TextCapitalization.none,
            style: widget.style,
            //  ??
            //     DocMineTextStyle.bold.copyWith(fontSize: scaler.fontSizer.sp(55)),
            maxLength: widget.maxLength,
            controller: widget.ctrl,
            enabled: true,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType ?? TextInputType.text,
            // inputFormatters: widget.inputFormatters,
            maxLines: widget.maxLines ?? 1,
            cursorColor: Colors.black,
            onChanged: widget.onChanged,
            decoration: decoration.copyWith(
              alignLabelWithHint: widget._expands,
              // labelStyle: TextStyle(
              //   fontSize: scaler.fontSizer.sp(60),
              //   color: Colors.black.withOpacity(.4),
              // ),
              suffix: widget.suffix,
              suffixIcon:
                  widget.suffixIcon != null ? widget.suffixIcon : Offstage(),
              prefix: widget.prefix,
              counter: null,
              // contentPadding: scaler.insets.symmetric(
              //   horizontal: 3,
              //   // vertical: 1.5,
              // ),
            ),
            validator: (String text) {
              // if (widget.validator != null) {
              //   final error = widget.validator(text);
              //   _hasFocus.value = FocusState(
              //     hasError: error != null,
              //     hasText: _hasFocus?.value?.hasText ?? false,
              //     isFocused: _hasFocus?.value?.isFocused ?? false,
              //   );
              //   return error;
              // }
              // _hasFocus.value = FocusState(
              //   hasError: false,
              //   hasText: _hasFocus?.value?.hasText ?? false,
              //   isFocused: _hasFocus?.value?.isFocused ?? false,
              // );
              // return null;
            },
          ),
        ),
      ),
    );
  }
}
