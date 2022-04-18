import 'package:funiroll/models/login/login_stream.dart';

abstract class StreamLoginState {}

class StreamUnlogedLoginState extends StreamLoginState {}

class StreamLoadingLoginState extends StreamLoginState {}

class StreamSucessLoginState extends StreamLoginState {
  final LoginStream user;
  StreamSucessLoginState(this.user);
}

class StreamErrorLoginState extends StreamLoginState {
  final String menssage;
  StreamErrorLoginState(this.menssage);
}
