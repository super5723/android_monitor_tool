//@dart=2.12
import 'dart:async';
import 'dart:collection';
import 'package:android_monitor_tool/generated/l10n.dart';
import 'package:android_monitor_tool/network/http_log_client.dart';
import 'package:android_monitor_tool/util.dart';
import 'package:android_monitor_tool/widget/custom_toolbar_icon_widget.dart';
import 'package:flutter/cupertino.dart' hide OverlayVisibilityMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:macos_ui/macos_ui.dart';

/// @Author wangyang
/// @Description veeka http日志查看
/// @Date 2023/4/19
class NetworkInfoPage extends StatefulWidget {
  const NetworkInfoPage({Key? key}) : super(key: key);

  @override
  _NetworkInfoPageState createState() => _NetworkInfoPageState();
}

class _NetworkInfoPageState extends State<NetworkInfoPage> {
  final LinkedHashMap<String, Map> _originDataMap = LinkedHashMap();
  final List<Map> _displayListData = [];
  final _scrollController = ScrollController();
  final _filterController = TextEditingController();
  bool _scrollListenerEnabled = true;
  final ValueNotifier<bool> _scrollToBottom = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      toolBar: ToolBar(
        title: ValueListenableBuilder<ClientStatus>(
          valueListenable: HttpLogClient.instance.statusNotifier,
          builder: (context, clientStatus, child) {
            return Text(
              clientStatus == ClientStatus.connected
                  ? S.current.http_log_server_connected(HttpLogClient.instance.serverName ?? '')
                  : S.current.http_log_server_disconnected,
            );
          },
        ),
        titleWidth: 300,
        actions: [
          CustomToolbarItem(inToolbarBuilder: (BuildContext context) {
            return Container(
              width: 200,
              height: 30,
              margin: const EdgeInsetsDirectional.only(end: 10),
              child: MacosTextField(
                placeholder: S.current.input_http_log_filter_keyword,
                controller: _filterController,
                clearButtonMode: OverlayVisibilityMode.editing,
                onChanged: (s) => _refreshFilter(),
              ),
            );
          }),
          CustomToolbarItem(inToolbarBuilder: (BuildContext context) {
            return ValueListenableBuilder<ClientStatus>(
                valueListenable: HttpLogClient.instance.statusNotifier,
                builder: (context, clientStatus, child) {
                  return CustomToolbarIconWidget(
                    icon: MacosIcon(
                      clientStatus == ClientStatus.connected ? CupertinoIcons.stop : CupertinoIcons.play,
                    ),
                    onPressed: () async {
                      if (clientStatus == ClientStatus.connected) {
                        await HttpLogClient.instance.disconnectServer();
                      } else if (clientStatus == ClientStatus.stopped) {
                        Future.delayed(const Duration(milliseconds: 10), () {
                          Util.showInputDialog(context, S.current.input_http_log_server_host, (value) async {
                            await HttpLogClient.instance.connectServer(value);
                          });
                        });
                      }
                    },
                  );
                });
          }),
          ToolBarIconButton(
            label: S.current.clear,
            icon: const MacosIcon(
              CupertinoIcons.clear_circled,
            ),
            tooltipMessage: S.current.clear,
            onPressed: () {
              _originDataMap.clear();
              _refreshFilter();
            },
            showLabel: false,
          ),
          const ToolBarSpacer(),
        ],
      ),
      children: [
        ContentArea(
          builder: ((context, scrollController) {
            return Stack(
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(top: 10, bottom: 30),
                    child: _buildLogListWidget(),
                  ),
                ),
                PositionedDirectional(
                  bottom: 10,
                  end: 10,
                  child: ValueListenableBuilder<String?>(
                    valueListenable: HttpLogClient.instance.logStringNotifier,
                    builder: (context, value, child) {
                      return Text(
                        value ?? '',
                        style: MacosTheme.of(context).typography.footnote,
                      );
                    },
                  ),
                ),
                PositionedDirectional(
                  bottom: 20,
                  end: 20,
                  child: ValueListenableBuilder<bool>(
                      valueListenable: _scrollToBottom,
                      builder: (context, value, child) {
                        return AnimatedOpacity(
                          opacity: value ? 0 : 1,
                          duration: const Duration(milliseconds: 150),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 60),
                            child: FloatingActionButton(
                              mini: true,
                              clipBehavior: Clip.antiAlias,
                              child: const Icon(
                                Icons.arrow_downward,
                                color: Colors.white,
                              ),
                              onPressed: _scrollToListBottom,
                            ),
                          ),
                        );
                      }),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }

  void _scrollToListBottom() async {
    if (_scrollController.hasClients) {
      _scrollListenerEnabled = false;
      _scrollToBottom.value = true;
      var scrollPosition = _scrollController.position;
      await _scrollController.animateTo(
        scrollPosition.maxScrollExtent,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
      _scrollListenerEnabled = true;
    }
  }

  _buildLogListWidget() {
    if (_displayListData.isEmpty) {
      return const Center(
        child: Text(
          'No Data',
          style: TextStyle(color: Color(0xff666666), fontSize: 20),
        ),
      );
    }
    return ListView.builder(
      controller: _scrollController,
      itemBuilder: (context, index) {
        Map item = _displayListData[index];
        int statusCode = Util.parseInt(item['statusCode']);
        return Padding(
          padding: const EdgeInsetsDirectional.only(bottom: 5),
          child: Container(
              width: MediaQuery.of(context).size.width - 80,
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(left: 16, right: 16, top: 8),
              decoration: BoxDecoration(
                color: statusCode == 200 ? Colors.white.withOpacity(0.1) : Color(0xFFFBC02D),
                borderRadius: BorderRadius.circular(8),
              ),
              child: RichText(
                text: TextSpan(
                  children: <InlineSpan>[
                    TextSpan(text: '[${item['time']}]', style: const TextStyle(fontSize: 9, color: Colors.white54, height: 1.2)),
                    WidgetSpan(
                        child: Container(
                            child: Text('$statusCode', style: const TextStyle(fontSize: 8, color: Color(0xffffffff), height: 1.2)),
                            height: 11,
                            margin: const EdgeInsets.only(left: 4),
                            padding: const EdgeInsets.only(left: 6, right: 6),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(2)),
                                color: (statusCode == 200) ? const Color(0xff337cc4) : const Color(0xffd0607e)))),
                    TextSpan(
                      text: '  ${item['reqMethod']}'
                          '  Cost:${item['duration']}ms '
                          '  Size: -',
                      style: TextStyle(
                        fontSize: 9,
                        color: Util.parseInt(item['duration']) >= 1000 ? Colors.red : const Color(0xff666666),
                        height: 1.5,
                      ),
                    ),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () {
                          String curl = Util.parseSafeStr(item['curlString']);
                          if (curl.isNotEmpty) {
                            Clipboard.setData(ClipboardData(text: curl));
                            Util.showConfirmDialog(context: context, message: S.current.set_clipboard_success);
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 15),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          child: const Text('copy curl', style: TextStyle(fontSize: 12)),
                        ),
                      ),
                    ),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () {
                          String responseJson = Util.parseSafeStr(item['responseBody']);
                          if (responseJson.isNotEmpty) {
                            Clipboard.setData(ClipboardData(text: responseJson));
                            Util.showConfirmDialog(context: context, message: S.current.set_clipboard_success);
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 15),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          child: const Text('copy response', style: TextStyle(fontSize: 12)),
                        ),
                      ),
                    ),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () {
                          String responseJson = Util.parseSafeStr(item['responseBody']);
                          Util.showJsonViewDialog(context: context, json: responseJson);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 15),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          child: const Text('view response', style: TextStyle(fontSize: 12)),
                        ),
                      ),
                    ),
                    const TextSpan(
                        text: '\nUri: ', style: TextStyle(fontSize: 10, color: Colors.white54, height: 1.5, fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: Util.parseSafeStr(item['url']), style: const TextStyle(fontSize: 10, height: 1.5, color: Color(0xffff62a9))),
                    const TextSpan(
                        text: '\nResponse: ',
                        style: TextStyle(fontSize: 10, height: 1.5, color: Colors.white54, fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: Util.parseSafeStr(item['responseBody']),
                        style: const TextStyle(fontSize: 10, height: 1.5, color: Color(0xff666666))),
                    const TextSpan(
                        text: '\nParameters: ',
                        style: TextStyle(fontSize: 10, height: 1.5, color: Colors.white54, fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: Util.parseSafeStr(item['requestBody']),
                        style: const TextStyle(fontSize: 10, height: 1.5, color: Color(0xff666666))),
                  ],
                ),
              )),
        );
      },
      itemCount: _displayListData.length,
      shrinkWrap: true,
    );
  }

  @override
  void initState() {
    super.initState();
    HttpLogClient.instance.addDataListener(_onReceiveData);
    _scrollController.addListener(() {
      if (!_scrollListenerEnabled) return;
      var scrolledToBottom = _scrollController.offset >= _scrollController.position.maxScrollExtent;
      _scrollToBottom.value = scrolledToBottom;
    });
  }

  _onReceiveData(Map logData) {
    String logId = Util.parseSafeStr(logData['logId']);
    if (_originDataMap.containsKey(logId)) {
      Map? logItem = _originDataMap[logId];
      if (logItem != null) {
        logItem.clear();
        logItem.addAll(logData);
      }
    } else {
      _checkListCapacity();
      _originDataMap[logId] = logData;
    }
    _refreshFilter();
  }

  ///列表容量限制
  _checkListCapacity() {
    if (_originDataMap.length > 200) {
      int deleteCount = 30;
      _originDataMap.removeWhere((key, value) {
        return deleteCount-- > 0;
      });
    }
  }

  _refreshFilter() {
    List<Map> filterList = [];
    _originDataMap.forEach((key, value) {
      bool needDisplay = true;
      if (_filterController.text.isNotEmpty) {
        var filterText = _filterController.text.toLowerCase();
        String url = Util.parseSafeStr(value['url']);
        needDisplay = url.toLowerCase().contains(filterText);
      }
      if (needDisplay) {
        filterList.add(value);
      }
    });
    if (mounted) {
      setState(() {
        _displayListData.clear();
        _displayListData.addAll(filterList);
      });

      if (_scrollToBottom.value) {
        Future.delayed(Duration.zero, _scrollToListBottom);
      }
    }
  }

  @override
  void dispose() {
    HttpLogClient.instance.removeDataListener(_onReceiveData);
    _scrollController.dispose();
    _filterController.dispose();
    super.dispose();
  }
}
