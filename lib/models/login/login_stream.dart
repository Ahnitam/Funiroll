import 'package:funiroll/utils/types.dart';

class LoginStream {
  final String usernameOrEmail;
  final String? senha;
  String session;
  bool isPremium;
  final StreamType stream;
  final String idExternal;

  LoginStream({
    required this.usernameOrEmail,
    this.senha,
    required this.session,
    required this.isPremium,
    required this.stream,
    this.idExternal = "",
  });

  factory LoginStream.fromJson(Map<String, dynamic> json) {
    late StreamType s;
    for (var item in StreamType.values) {
      if (item.name == json['stream']) {
        s = item;
      }
    }
    return LoginStream(
      usernameOrEmail: json['usernameOrEmail'],
      session: json['session'],
      isPremium: json['isPremium'],
      senha: json['senha'],
      idExternal: json['idExternal'],
      stream: s,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "usernameOrEmail": usernameOrEmail,
      "session": session,
      "isPremium": isPremium,
      "senha": senha,
      "stream": stream.name,
      "idExternal": idExternal
    };
  }
}
