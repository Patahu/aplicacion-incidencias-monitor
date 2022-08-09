import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_windows/webview_windows.dart';

import '../bloc/incident_bloc/bloc.dart';
import '../util/incident.dart';
import 'isVideoPlayer.dart';

class photoView extends StatefulWidget {
  final String urlFoto;
  photoView({
    Key? key,
    required this.urlFoto,
  }) : super(key: key);
  @override
  State<photoView> createState() => _ExampleBrowser();
}

class _ExampleBrowser extends State<photoView> {
  final _controller = WebviewController();
  final _textController = TextEditingController();

  late String url;
  String get _cindenteElegido => widget.urlFoto;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    print(_cindenteElegido);
    url = _cindenteElegido;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> initPlatformState() async {
    // Optionally initialize the webview environment using
    // a custom user data directory
    // and/or a custom browser executable directory
    // and/or custom chromium command line flags
    //await WebviewController.initializeEnvironment(
    //    additionalArguments: '--show-fps-counter');

    try {
      await _controller.initialize();
      _controller.url.listen((url) {
        _textController.text = url;
      });

      await _controller.setBackgroundColor(Colors.transparent);
      await _controller.setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);
      await _controller.loadUrl(url);

      if (!mounted) return;
      setState(() {});
    } on PlatformException catch (e) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: Text('Error'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Codigo: ${e.code}'),
                      Text('Mensje: ${e.message}'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      child: Text('Continuar'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      });
    }
  }

  Widget compositeView() {
    if (!_controller.value.isInitialized) {
      return CircularProgressIndicator();
    } else {
      return Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Card(
                  elevation: 0,
                  child: IconButton(
                    icon: Icon(IconData(0xe094, fontFamily: 'MaterialIcons')),
                    onPressed: () {
                      BlocProvider.of<IncidenciasBloc>(context)
                          .add(changeRestartTwoViewUnit());
                    },
                  ),
                ),
                Card(
                  elevation: 0,
                  child: IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      _controller.reload();
                    },
                  ),
                ),
                Card(
                  elevation: 0,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(IconData(0xeb15,
                            fontFamily: 'MaterialIcons',
                            matchTextDirection: true)),
                        onPressed: () {
                          BlocProvider.of<IncidenciasBloc>(context)
                              .add(backPhotoViewUnit());
                        },
                      ),
                      IconButton(
                        icon: Icon(IconData(0xe41d,
                            fontFamily: 'MaterialIcons',
                            matchTextDirection: true)),
                        onPressed: () {
                          BlocProvider.of<IncidenciasBloc>(context)
                              .add(nextPhotoViewUnit());
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
                child: Card(
                    color: Colors.transparent,
                    elevation: 0,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Stack(
                      children: [
                        Webview(
                          _controller,
                          permissionRequested: _onPermissionRequested,
                        ),
                        StreamBuilder<LoadingState>(
                            stream: _controller.loadingState,
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.data == LoadingState.loading) {
                                return LinearProgressIndicator();
                              } else {
                                return SizedBox();
                              }
                            }),
                      ],
                    ))),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey,
        child: Center(
          child: compositeView(),
        ),
      ),
    );
  }

  Future<WebviewPermissionDecision> _onPermissionRequested(
      String url, WebviewPermissionKind kind, bool isUserInitiated) async {
    final decision = await showDialog<WebviewPermissionDecision>(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Permiso WebView solicitado'),
        content: Text('WebView ha solicitado permiso\'$kind\''),
        actions: <Widget>[
          TextButton(
            onPressed: () =>
                Navigator.pop(context, WebviewPermissionDecision.deny),
            child: const Text('Bloquear'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, WebviewPermissionDecision.allow),
            child: const Text('Permitir'),
          ),
        ],
      ),
    );

    return decision ?? WebviewPermissionDecision.none;
  }
}
