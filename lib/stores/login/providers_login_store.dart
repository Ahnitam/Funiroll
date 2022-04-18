import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:funiroll/interfaces/info_provider.dart';
import 'package:funiroll/models/login/login_provider.dart';
import 'package:funiroll/states/login/login_provider_state.dart';
import 'package:funiroll/utils/types.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProvidersLoginStore extends ChangeNotifier {
  final Map<ProvidersType, ProviderLoginState> logins = {};
  final Map<ProvidersType, InfoProvider> providers;
  ProvidersLoginStore(this.providers) {
    providers.forEach((key, value) {
      logins[key] = ProviderUnlogedLoginState();
    });
  }

  Future checkLogins() async {
    final prefs = await SharedPreferences.getInstance();
    providers.forEach((providerType, provider) async {
      provider.logins = logins;
      logins[providerType] = ProviderLoadingLoginState();
      notifyListeners();
      final login = prefs.getString('P${providerType.name}Login');
      if (login != null) {
        LoginProvider l = LoginProvider.fromJson(jsonDecode(login));
        try {
          await provider.checkLogin(l);
          logins[providerType] = ProviderSucessLoginState(l);
          notifyListeners();
        } catch (e) {
          logout(providerType);
        }
      } else {
        logins[providerType] = ProviderUnlogedLoginState();
        notifyListeners();
      }
    });
  }

  Future logar(String user, String senha, ProvidersType provider) async {
    logins[provider] = ProviderLoadingLoginState();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    try {
      final userLogin = await providers[provider]!.login(user, senha);
      prefs.setString("${provider.name}Login", jsonEncode(userLogin.toJson()));
      logins[provider] = ProviderSucessLoginState(userLogin);
      notifyListeners();
    } catch (e) {
      logins[provider] = ProviderErrorLoginState(e.toString());
      notifyListeners();
    }
  }

  Future logout(ProvidersType provider) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("${provider.name}Login");
    logins[provider] = ProviderUnlogedLoginState();
    notifyListeners();
  }
}
