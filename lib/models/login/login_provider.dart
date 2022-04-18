import 'package:funiroll/utils/types.dart';

class LoginProvider {
  final String usernameOrEmail;
  final String? senha;
  String session;
  final ProvidersType provider;
  final bool isWebLogin;

  LoginProvider({
    required this.usernameOrEmail,
    this.senha,
    required this.session,
    required this.provider,
    this.isWebLogin = false,
  });

  factory LoginProvider.fromJson(Map<String, dynamic> json) {
    late ProvidersType s;
    for (var item in ProvidersType.values) {
      if (item.name == json['provider']) {
        s = item;
      }
    }
    return LoginProvider(
      usernameOrEmail: json['usernameOrEmail'],
      session: json['session'],
      senha: json['senha'],
      provider: s,
      isWebLogin: json['isWebLogin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "usernameOrEmail": usernameOrEmail,
      "session": session,
      "senha": senha,
      "provider": provider.name,
      "isWebLogin": isWebLogin,
    };
  }
}
