// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Memory`
  String get sidebar_name_memory {
    return Intl.message(
      'Memory',
      name: 'sidebar_name_memory',
      desc: '',
      args: [],
    );
  }

  /// `CPU`
  String get sidebar_name_cpu {
    return Intl.message(
      'CPU',
      name: 'sidebar_name_cpu',
      desc: '',
      args: [],
    );
  }

  /// `Memory Info`
  String get memory_page_title_default {
    return Intl.message(
      'Memory Info',
      name: 'memory_page_title_default',
      desc: '',
      args: [],
    );
  }

  /// `Process:{process}`
  String memory_page_title_common(Object process) {
    return Intl.message(
      'Process:$process',
      name: 'memory_page_title_common',
      desc: '',
      args: [process],
    );
  }

  /// `Control`
  String get control {
    return Intl.message(
      'Control',
      name: 'control',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get start {
    return Intl.message(
      'Start',
      name: 'start',
      desc: '',
      args: [],
    );
  }

  /// `Stop`
  String get stop {
    return Intl.message(
      'Stop',
      name: 'stop',
      desc: '',
      args: [],
    );
  }

  /// `Setting`
  String get setting {
    return Intl.message(
      'Setting',
      name: 'setting',
      desc: '',
      args: [],
    );
  }

  /// `Shell interval`
  String get set_command_interval {
    return Intl.message(
      'Shell interval',
      name: 'set_command_interval',
      desc: '',
      args: [],
    );
  }

  /// `set Process`
  String get set_process_name {
    return Intl.message(
      'set Process',
      name: 'set_process_name',
      desc: '',
      args: [],
    );
  }

  /// `File`
  String get file {
    return Intl.message(
      'File',
      name: 'file',
      desc: '',
      args: [],
    );
  }

  /// `Import`
  String get import {
    return Intl.message(
      'Import',
      name: 'import',
      desc: '',
      args: [],
    );
  }

  /// `Export`
  String get export {
    return Intl.message(
      'Export',
      name: 'export',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `Select path`
  String get select_export_path {
    return Intl.message(
      'Select path',
      name: 'select_export_path',
      desc: '',
      args: [],
    );
  }

  /// `Select file`
  String get select_import_file {
    return Intl.message(
      'Select file',
      name: 'select_import_file',
      desc: '',
      args: [],
    );
  }

  /// `input process name`
  String get hint_input_process_name {
    return Intl.message(
      'input process name',
      name: 'hint_input_process_name',
      desc: '',
      args: [],
    );
  }

  /// `input interval,must greater than 1000`
  String get hint_input_interval {
    return Intl.message(
      'input interval,must greater than 1000',
      name: 'hint_input_interval',
      desc: '',
      args: [],
    );
  }

  /// `interval not valid,must greater than 1000`
  String get input_interval_not_valid {
    return Intl.message(
      'interval not valid,must greater than 1000',
      name: 'input_interval_not_valid',
      desc: '',
      args: [],
    );
  }

  /// `process is empty`
  String get status_error_process_name_empty {
    return Intl.message(
      'process is empty',
      name: 'status_error_process_name_empty',
      desc: '',
      args: [],
    );
  }

  /// `export success:{file}`
  String exporting_success(Object file) {
    return Intl.message(
      'export success:$file',
      name: 'exporting_success',
      desc: '',
      args: [file],
    );
  }

  /// `export fail:{msg}`
  String exporting_fail(Object msg) {
    return Intl.message(
      'export fail:$msg',
      name: 'exporting_fail',
      desc: '',
      args: [msg],
    );
  }

  /// `success`
  String get success {
    return Intl.message(
      'success',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `clear data`
  String get clear {
    return Intl.message(
      'clear data',
      name: 'clear',
      desc: '',
      args: [],
    );
  }

  /// `Cpu Usage`
  String get cpu_page_title {
    return Intl.message(
      'Cpu Usage',
      name: 'cpu_page_title',
      desc: '',
      args: [],
    );
  }

  /// `current usage:{usage}%`
  String realtime_cpu_usage(Object usage) {
    return Intl.message(
      'current usage:$usage%',
      name: 'realtime_cpu_usage',
      desc: '',
      args: [usage],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
