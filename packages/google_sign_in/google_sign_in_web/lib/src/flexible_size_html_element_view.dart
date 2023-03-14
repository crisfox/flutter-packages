// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:js/js_util.dart';

import 'dom.dart';

/// An HTMLElementView widget that resizes with its contents.
class FlexHtmlElementView extends StatefulWidget {
  /// Constructor
  const FlexHtmlElementView({ super.key, required this.viewType, this.onPlatformViewCreated, this.initialSize });

  final String viewType;
  final PlatformViewCreatedCallback? onPlatformViewCreated;
  final Size? initialSize;

  @override
  State<StatefulWidget> createState() => _FlexHtmlElementView();
}

class _FlexHtmlElementView extends State<FlexHtmlElementView> {
  Size _lastReportedSize = const Size(1, 1);

  DomMutationObserver? mutationObserver;
  DomResizeObserver? resizeObserver;

  void _registerListeners(DomElement? root) {
    assert (root != null, 'DOM is not ready for the FlexHtmlElementView');
    mutationObserver = createDomMutationObserver(allowInterop((List<DomMutationRecord> mutations, DomMutationObserver observer) {
      for (final DomMutationRecord mutation in mutations) {
        if (mutation.addedNodes != null) {
          final DomElement? element = _locateSizeProvider(mutation.addedNodes!);
          if (element != null) {
            resizeObserver = createDomResizeObserver((List<DomResizeObserverEntry> resizes, DomResizeObserver observer) {
              final DomRectReadOnly rect = resizes.last.contentRect;
              if (rect.width > 0 && rect.height > 0) {
                setState(() {
                  domConsole.log('Resizing FlexHtmlElementView', <Object>[rect.width, rect.height]);
                  _lastReportedSize = Size(rect.width, rect.height);              
                });
              }
            });
            resizeObserver?.observe(element);
          }
        }
      }
    }));
    // Monitor the size of the child element, whenever it's created...
    mutationObserver!.observe(root!, childList: true, );//subtree: true);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: _lastReportedSize,
      child: HtmlElementView(
        viewType: widget.viewType,
        onPlatformViewCreated: (int viewId) async {
          _registerListeners(_defaultRootLocator(viewId));
          if (widget.onPlatformViewCreated != null) {
            widget.onPlatformViewCreated!(viewId);
          }
        }
      ),
    );
  }
}

DomElement? _locateSizeProvider(List<DomElement> elements) {
  return elements.first;
  // for (final DomElement element in elements) {
  //   if (element.tagName != null && element.tagName == 'IFRAME') {
  //     return element;
  //   }
  // }
  // return null;
}

DomElement? _defaultRootLocator(int viewId) {
  return domDocument.querySelector('flt-platform-view[slot\$="-$viewId"] :first-child');
}
