import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

/// @Author wangyang
/// @Description
/// @Date 2023/4/20
class HttpLogClient {
  static HttpLogClient? _instance;
  Socket? _socket;
  final int port = 9799;
  final ValueNotifier<ClientStatus> _statusNotifier = ValueNotifier(ClientStatus.stopped);
  final StringBuffer _buffer = StringBuffer();
  final List<OnReceiveDataListener> _listenerList = [];
  final String endTag = '#END#';
  final Utf8Decoder _utf8decoder = const Utf8Decoder();
  final ValueNotifier<String?> _logStringNotifier=ValueNotifier(null);

  HttpLogClient._internal();

  factory HttpLogClient() {
    _instance ??= HttpLogClient._internal();
    return _instance!;
  }

  static HttpLogClient get instance {
    return HttpLogClient();
  }

  connectServer(String host) async {
    _log('HttpLogClient->connectServer:current status=${_statusNotifier.value}');
    if (_statusNotifier.value != ClientStatus.stopped) {
      return;
    }
    try {
      _statusNotifier.value = ClientStatus.connecting;
      _socket = await Socket.connect(host, port);
      _socket?.listen(_receiveDataFromServer, onDone: () {
        _log('HttpLogClient->onDone');
        _socket?.close();
        _reset();
      }, onError: (e) {
        _log('HttpLogClient->onError:$e');
        _socket?.close();
        _reset();
      });
      _statusNotifier.value = ClientStatus.connected;
    } catch (e) {
      _log('HttpLogClient->connectServer fail=$e');
      _reset();
    }
  }

  disconnectServer() async {
    _log('HttpLogClient->disconnectServer:current status=${_statusNotifier.value}');
    if (_statusNotifier.value == ClientStatus.connected) {
      try {
        await _socket?.close();
      } catch (e) {
        _log('HttpLogClient->disconnectServer fail:$e');
      }
      _reset();
    }
  }

  _receiveDataFromServer(Uint8List data) {
    String dataString = _utf8decoder.convert(data);

    ///处理分包、粘包问题
    int start = 0;
    String tmpStr = dataString;
    int tmpIndex = -1;
    while ((tmpIndex = tmpStr.indexOf(endTag)) != -1) {
      _buffer.write(tmpStr.substring(0, tmpIndex));
      try {
        Map json = jsonDecode(_buffer.toString());
        notifyReceiveData(json);
      } catch (e) {
        _log('HttpLogClient->_receiveDataFromServer exception:$e');
      }
      _buffer.clear();
      start += tmpIndex + endTag.length;
      if (start >= dataString.length) {
        break;
      }
      tmpStr = dataString.substring(start);
    }
    if (start < dataString.length) {
      _buffer.write(dataString.substring(start));
    }
  }

  _reset() {
    _socket = null;
    _statusNotifier.value = ClientStatus.stopped;
    _buffer.clear();
  }

  addDataListener(OnReceiveDataListener l) {
    _listenerList.add(l);
  }

  removeDataListener(OnReceiveDataListener l) {
    _listenerList.remove(l);
  }

  notifyReceiveData(Map data) {
    for (var l in _listenerList) {
      l.call(data);
    }
  }

  ValueNotifier<ClientStatus> get statusNotifier {
    return _statusNotifier;
  }

  String? get serverName {
    return _socket?.remoteAddress.address;
  }

  _log(String message) {
    _logStringNotifier.value = message;
    debugPrint(message);
  }

  ValueNotifier<String?> get logStringNotifier {
    return _logStringNotifier;
  }
}

typedef OnReceiveDataListener = void Function(Map data);

enum ClientStatus {
  stopped,
  connecting,
  connected,
}
