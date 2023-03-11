// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs, avoid_print

import 'package:flutter/material.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart' as web;

typedef OnWebConfigChangeFn = void Function(web.ButtonConfiguration newConfig);

Widget renderWebButtonConfiguration(web.ButtonConfiguration? currentConfig, { 
  required OnWebConfigChangeFn onChange,
}) {
  final ScrollController scrollController = ScrollController();
  return Scrollbar(
    controller: scrollController,
    thumbVisibility: true,
    interactive: true,
    child: SingleChildScrollView (
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _renderRadioListTileCard<web.ButtonType>(
            title: 'ButtonType',
            values: web.ButtonType.values,
            selected: currentConfig?.type, 
            onChanged: (web.ButtonType? value) {
              onChange(_copyConfigWith(currentConfig, value));
            }),
          _renderRadioListTileCard<web.ButtonShape>(
            title: 'ButtonShape',
            values: web.ButtonShape.values,
            selected: currentConfig?.shape,
            onChanged: (web.ButtonShape? value) {
              onChange(_copyConfigWith(currentConfig, value));
            }),
          _renderRadioListTileCard<web.ButtonSize>(
            title: 'ButtonSize',
            values: web.ButtonSize.values,
            selected: currentConfig?.size, 
            onChanged: (web.ButtonSize? value) {
              onChange(_copyConfigWith(currentConfig, value));
            }),
          _renderRadioListTileCard<web.ButtonTheme>(
            title: 'ButtonTheme',
            values: web.ButtonTheme.values,
            selected: currentConfig?.theme,
            onChanged: (web.ButtonTheme? value) {
              onChange(_copyConfigWith(currentConfig, value));
            }),
          _renderRadioListTileCard<web.ButtonText>(
            title: 'ButtonText',
            values: web.ButtonText.values,
            selected: currentConfig?.text,
            onChanged: (web.ButtonText? value) {
              onChange(_copyConfigWith(currentConfig, value));
            }),
          // _renderRadioListTileCard<web.ButtonLogoAlignment>(
          //   title: 'ButtonLogoAlignment',
          //   values: web.ButtonLogoAlignment.values,
          //   selected: currentConfig?.logoAlignment,
          //   onChanged: (web.ButtonLogoAlignment? value) {
          //     onChange(_copyConfigWith(currentConfig, value));
          //   }),
        ],
      )
    )
  );
}

Widget _renderRadioListTileCard<T extends Enum>({
  required String title,
  required List<T> values,
  T? selected, 
  void Function(T?)? onChanged
}) {
  return Container(
    constraints: const BoxConstraints(maxWidth: 200),
    child: Card(
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(title),
              titleTextStyle: const TextStyle(fontWeight: FontWeight.bold),
              dense: true,
            ),
            ...values.map((T value) => 
              RadioListTile<T>(
                  value: value,
                  groupValue: selected,
                  onChanged: onChanged,
                  selected: value == selected,
                  title: Text(value.name),
                  dense: true,
                )
            ),
          ],
        )
    )
  );
}

web.ButtonConfiguration _copyConfigWith(web.ButtonConfiguration? old, Object? value) {
  return web.ButtonConfiguration(
    locale: old?.locale,
    minimumWidth: old?.minimumWidth,
    type: value is web.ButtonType ? value : old?.type,
    theme: value is web.ButtonTheme ? value : old?.theme,
    size: value is web.ButtonSize ? value : old?.size,
    text: value is web.ButtonText ? value : old?.text,
    shape: value is web.ButtonShape ? value : old?.shape,
    logoAlignment: value is web.ButtonLogoAlignment ? value : old?.logoAlignment,
  );
}
