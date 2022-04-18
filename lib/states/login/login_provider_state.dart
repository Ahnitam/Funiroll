import 'package:funiroll/models/login/login_provider.dart';

abstract class ProviderLoginState {}

class ProviderUnlogedLoginState extends ProviderLoginState {}

class ProviderLoadingLoginState extends ProviderLoginState {}

class ProviderSucessLoginState extends ProviderLoginState {
  final LoginProvider user;
  ProviderSucessLoginState(this.user);
}

class ProviderErrorLoginState extends ProviderLoginState {
  final String menssage;
  ProviderErrorLoginState(this.menssage);
}
