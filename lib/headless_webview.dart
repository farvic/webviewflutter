import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class HeadlessWebView extends StatefulWidget {
  static const routeName = '/headless-webview';
  @override
  _HeadlessWebViewState createState() => new _HeadlessWebViewState();
}

class _HeadlessWebViewState extends State<HeadlessWebView> {
  HeadlessInAppWebView headlessWebView;
  String url = "";
  String consoleText = "Mensagem do console: ";

  @override
  void initState() {
    super.initState();

    headlessWebView = new HeadlessInAppWebView(
      initialUrl: "https://flutter.dev/",
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          debuggingEnabled: true,
        ),
      ),
      onWebViewCreated: (controller) {
        print('HeadlessInAppWebView created!');
      },
      onConsoleMessage: (controller, consoleMessage) {
        print("CONSOLE MESSAGE: " + consoleMessage.message);
        setState(() {
          consoleText = consoleMessage.message;
        });
      },
      onLoadStart: (controller, url) async {
        print("onLoadStart $url");
        setState(() {
          this.url = url;
        });
      },
      onLoadStop: (controller, url) async {
        print("onLoadStop $url");
        setState(() {
          this.url = url;
        });
      },
      onUpdateVisitedHistory: (InAppWebViewController controller, String url,
          bool androidIsReload) {
        print("onUpdateVisitedHistory $url");
        setState(() {
          this.url = url;
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    headlessWebView.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int valor = 0;
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
              title: Text(
            "HeadlessInAppWebView",
          )),
          body: SafeArea(
              child: Column(children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              child: Text(
                  "CURRENT URL\n${(url.length > 50) ? url.substring(0, 50) + "..." : url}"),
            ),
            Center(
              child: RaisedButton(
                  onPressed: () async {
                    await headlessWebView.dispose();
                    await headlessWebView.run();
                  },
                  child: Text("Run HeadlessInAppWebView")),
            ),
            Center(
              child: RaisedButton(
                  onPressed: () async {
                    try {
                      // await headlessWebView.webViewController.injectJavascriptFileFromAsset(assetFilePath: 'assets/app.js').then((value) {
                      //   headlessWebView.webViewController.evaluateJavascript(source: "test()");
                      //   print(valor);
                      // });
                      await headlessWebView.webViewController.injectJavascriptFileFromAsset(assetFilePath: 'assets/app.js');
                      await headlessWebView.webViewController.evaluateJavascript(source: "test()").then((value) {
                        print('E AGORA? $value');
                      });
                      await headlessWebView.webViewController
                          .evaluateJavascript(source: 'loadDoc()')
                          .then((value) {
                        print('RESULTADO: $value');
                      });
                    } on MissingPluginException catch (e) {
                      print(
                          "HeadlessInAppWebView is not running. Click on \"Run HeadlessInAppWebView\"!");
                    }
                  },
                  child: Text("Send console.log message")),
            ),
            Center(
              child: RaisedButton(
                  onPressed: () {
                    headlessWebView.dispose();
                  },
                  child: Text("Dispose HeadlessInAppWebView")),
            ),
            Text(consoleText),
          ]))),
    );
  }
}
