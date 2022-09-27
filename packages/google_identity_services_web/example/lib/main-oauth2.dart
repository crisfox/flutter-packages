// import 'package:flutter/material.dart';
import 'package:google_identity_services_web/id.dart' as id show setLogLevel;
import 'package:google_identity_services_web/loader.dart' as gis;
import 'package:google_identity_services_web/oauth2.dart' as oauth2;
import 'package:http/http.dart' as http;
import 'package:js/js.dart' show allowInterop;

const List<String> scopes = <String>[
  'email', 'profile', 'https://www.googleapis.com/auth/contacts.readonly',
];

void main() async {
  await gis.loadWebSdk(); // Load the GIS SDK

  id.setLogLevel('debug');

  final oauth2.TokenClientConfig config = oauth2.TokenClientConfig(
    client_id: '933321482045-m78qk55i00hu4r3s7o2nc5j4gatr1vp7.apps.googleusercontent.com',
    scope: scopes.join(' '),
    callback: allowInterop(onTokenResponse),
  );

  final oauth2.OverridableTokenClientConfig overridableCfg = oauth2.OverridableTokenClientConfig(
    prompt: '',
  );

  final oauth2.TokenClient client = oauth2.initTokenClient(config);

  // Disable the Popup Blocker for this to work, or move this to a Button press.
  client.requestAccessToken(overridableCfg);
}

///
void onTokenResponse(oauth2.TokenResponse response) async {
  if (response.error != null) {
    print('Authorization error!');
    print(response.error);
    print(response.error_description);
    print(response.error_uri);
    return;
  }

  // Has granted all the scopes?
  if (!oauth2.hasGrantedAllScopes(response, scopes[2])) {
    print('The user has NOT granted the required scope!');
    return;
  }

  final http.Response apiResponse = await http.get(
    Uri.parse('https://people.googleapis.com/v1/people/me/connections'
        '?requestMask.includeField=person.names'),
    headers: <String, String>{
      'Authorization': '${response.token_type} ${response.access_token}',
    },
  );
  if (apiResponse.statusCode == 200) {
    print('People API ${apiResponse.statusCode} OK!');
  } else {
    print('People API ${apiResponse.statusCode} Oops! Something wrong happened!');
  }
  print(apiResponse.body);

  print('Revoking token...');
  oauth2.revokeToken(response.access_token, allowInterop((String status) {
    print(status);
  }));
}