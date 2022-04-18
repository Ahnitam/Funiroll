import 'package:flutter/material.dart';
import 'package:funiroll/stores/login/streams_login_store.dart';
import 'package:funiroll/utils/types.dart';
import 'package:funiroll/views/home_view/components/my_buttom.dart';
import 'package:funiroll/views/home_view/pages/config_page/components/campo_login.dart';
import 'package:provider/provider.dart';

class LoginConfig extends StatelessWidget {
  final StreamType streamType;
  final Color colorBorderField;

  LoginConfig(
      {Key? key, required this.colorBorderField, required this.streamType})
      : super(key: key);

  final TextEditingController userController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController sessionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final store = context.read<StreamsLoginStore>();
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20, top: 25),
              child: CampoLogin(
                "EMAIL/USERNAME",
                controller: userController,
                textType: TextInputType.emailAddress,
                colorBorderField: colorBorderField,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20, top: 10),
              child: CampoLogin(
                "SENHA",
                controller: senhaController,
                isSenha: true,
                colorBorderField: colorBorderField,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  right: 20, left: 20, top: 10, bottom: 25),
              child: CampoLogin(
                "SESSION",
                controller: sessionController,
                colorBorderField: colorBorderField,
              ),
            ),
            MyButtom(
              width: 150,
              height: 40,
              color: colorBorderField,
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                if (userController.text.isNotEmpty &&
                    senhaController.text.isNotEmpty) {
                  store.logar(
                      userController.text, senhaController.text, streamType);
                } else if (sessionController.text.isNotEmpty) {
                  store.logarBySession(sessionController.text, streamType);
                }
              },
              label: "LOGIN",
            ),
          ],
        ),
      ),
    );
  }
}
