import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:funiroll/interfaces/stream.dart';
import 'package:funiroll/models/login/login_stream.dart';
import 'package:funiroll/states/login/login_stream_state.dart';
import 'package:funiroll/utils/types.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StreamsLoginStore extends ChangeNotifier {
  final Map<StreamType, StreamLoginState> logins = {};
  final Map<StreamType, Stream> streams;
  StreamsLoginStore(this.streams) {
    for (var stream in StreamType.values) {
      logins[stream] = StreamUnlogedLoginState();
    }
  }

  Future checkLogins() async {
    final prefs = await SharedPreferences.getInstance();
    streams.forEach((streamType, stream) async {
      stream.logins = logins;
      logins[streamType] = StreamLoadingLoginState();
      notifyListeners();
      final login = prefs.getString('S${streamType.name}Login');
      if (login != null) {
        LoginStream l = LoginStream.fromJson(jsonDecode(login));
        try {
          await stream.updateInfo(l);
          logins[streamType] = StreamSucessLoginState(l);
          notifyListeners();
        } catch (e) {
          if (l.senha != null) {
            logar(l.usernameOrEmail, l.senha!, streamType);
          } else {
            logout(streamType);
          }
        }
      } else {
        logins[streamType] = StreamUnlogedLoginState();
        notifyListeners();
      }
    });
  }

  Future logar(String user, String senha, StreamType stream) async {
    logins[stream] = StreamLoadingLoginState();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    try {
      final userLogin = await streams[stream]!.login(user, senha);
      prefs.setString("S${stream.name}Login", jsonEncode(userLogin.toJson()));
      logins[stream] = StreamSucessLoginState(userLogin);
      notifyListeners();
    } catch (e) {
      logins[stream] = StreamErrorLoginState(e.toString());
      notifyListeners();
    }
  }

  Future logarBySession(String session, StreamType stream) async {
    logins[stream] = StreamLoadingLoginState();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    try {
      final userLogin = await streams[stream]!.loginBySession(session);
      prefs.setString("S${stream.name}Login", jsonEncode(userLogin.toJson()));
      logins[stream] = StreamSucessLoginState(userLogin);
      notifyListeners();
    } catch (e) {
      logins[stream] = StreamErrorLoginState(e.toString());
      notifyListeners();
    }
  }

  Future logout(StreamType stream) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("S${stream.name}Login");
    logins[stream] = StreamUnlogedLoginState();
    notifyListeners();
  }
}
