// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:google_identity_services_web/id.dart' as id;
import 'package:js/js_util.dart' as js_util;

id.GsiButtonConfiguration? convertButtonConfiguration(ButtonConfiguration? config) {
  if (config == null) {
    return null;
  }
  return js_util.jsify(<String, Object?>{
    if (config.type != null) 'type': _idType[config.type],
    if (config.theme != null) 'theme': _idTheme[config.theme],
    if (config.size != null) 'size': _idSize[config.size],
    if (config.text != null) 'text': _idText[config.text],
    if (config.shape != null) 'shape': _idShape[config.shape],
    if (config.logoAlignment != null) 'logo_alignment': _idLogoAlignment[config.logoAlignment],
    if (config.minimumWidth != null) 'width': config.minimumWidth,
    if (config.locale != null) 'locale': config.locale,
  }) as id.GsiButtonConfiguration;
}

/// A class to configure the Google Sign-In Button for web.
///
/// https://developers.google.com/identity/gsi/web/reference/js-reference#GsiButtonConfiguration
class ButtonConfiguration {
  /// Constructs a button configuration object.
  ButtonConfiguration({
    this.type, this.theme, this.size, this.text, this.shape, this.logoAlignment, this.minimumWidth, this.locale
  }) : assert(minimumWidth == null || minimumWidth > 0 || minimumWidth <= 400);

  /// The button type: icon, or standard button.
  final ButtonType? type;

  /// The button theme.
  ///
  /// For example, filledBlue or filledBlack.
  final ButtonTheme? theme;

  /// The button size.
  ///
  /// For example, small or large.
  final ButtonSize? size;

  /// The button text.
  ///
  /// For example "Sign in with Google" or "Sign up with Google".
  final ButtonText? text;

  /// The button shape.
  ///
  /// For example, rectangular or circular.
  final ButtonShape? shape;

  /// The Google logo alignment: left or center.
  final ButtonLogoAlignment? logoAlignment;

  /// The minimum button width, in pixels.
  ///
  /// The maximum width is 400 pixels.
  final double? minimumWidth;

  /// The pre-set locale of the button text.
  ///
  /// If not set, the browser's default locale or the Google session user's
  /// preference is used.
  /// 
  /// Different users might see different versions of localized buttons, possibly
  /// with different sizes.
  final String? locale;
}

/// The type of button to be rendered.
///
/// https://developers.google.com/identity/gsi/web/reference/js-reference#type
enum ButtonType {
  /// A button with text or personalized information.
  standard,
  /// An icon button without text.
  icon;
}

const Map<ButtonType, id.ButtonType> _idType = <ButtonType, id.ButtonType> {
  ButtonType.icon: id.ButtonType.icon,
  ButtonType.standard: id.ButtonType.standard,
};

/// The theme of the button to be rendered.
///
/// https://developers.google.com/identity/gsi/web/reference/js-reference#theme
enum ButtonTheme {
  /// A standard button theme.
  outline,
  /// A blue-filled button theme.
  filledBlue,
  /// A black-filled button theme.
  filledBlack;
}

const Map<ButtonTheme, id.ButtonTheme> _idTheme = <ButtonTheme, id.ButtonTheme> {
  ButtonTheme.outline: id.ButtonTheme.outline,
  ButtonTheme.filledBlue: id.ButtonTheme.filled_blue,
  ButtonTheme.filledBlack: id.ButtonTheme.filled_black,
};

/// The size of the button to be rendered.
///
/// https://developers.google.com/identity/gsi/web/reference/js-reference#size
enum ButtonSize {
  /// A large button (about 40px tall).
  large,
  /// A medium-sized button (about 32px tall).
  medium,
  /// A small button (about 20px tall).
  small;
}

const Map<ButtonSize, id.ButtonSize> _idSize = <ButtonSize, id.ButtonSize> {
  ButtonSize.large: id.ButtonSize.large,
  ButtonSize.medium: id.ButtonSize.medium,
  ButtonSize.small: id.ButtonSize.small,
};

/// The button text.
///
/// https://developers.google.com/identity/gsi/web/reference/js-reference#text
enum ButtonText {
  /// The button text is "Sign in with Google".
  signinWith,
  /// The button text is "Sign up with Google".
  signupWith,
  /// The button text is "Continue with Google".
  continueWith,
  /// The button text is "Sign in".
  signin;
}

const Map<ButtonText, id.ButtonText> _idText = <ButtonText, id.ButtonText> {
  ButtonText.signinWith: id.ButtonText.signin_with,
  ButtonText.signupWith: id.ButtonText.signup_with,
  ButtonText.continueWith: id.ButtonText.continue_with,
  ButtonText.signin: id.ButtonText.signin,
};

/// The button shape.
///
/// https://developers.google.com/identity/gsi/web/reference/js-reference#shape
enum ButtonShape {
  /// The rectangular-shaped button.
  rectangular,
  /// The circle-shaped button.
  pill;
  // Does this need circle and square?
}

const Map<ButtonShape, id.ButtonShape> _idShape = <ButtonShape, id.ButtonShape> {
  ButtonShape.rectangular: id.ButtonShape.rectangular,
  ButtonShape.pill: id.ButtonShape.pill,
};

/// The alignment of the Google logo. The default value is left. This attribute only applies to the standard button type.
///
/// https://developers.google.com/identity/gsi/web/reference/js-reference#logo_alignment
enum ButtonLogoAlignment {
  /// Left-aligns the Google logo.
  left,
  /// Center-aligns the Google logo.
  center;
}

const Map<ButtonLogoAlignment, id.ButtonLogoAlignment> _idLogoAlignment = <ButtonLogoAlignment, id.ButtonLogoAlignment> {
  ButtonLogoAlignment.left: id.ButtonLogoAlignment.left,
  ButtonLogoAlignment.center: id.ButtonLogoAlignment.center,
};
