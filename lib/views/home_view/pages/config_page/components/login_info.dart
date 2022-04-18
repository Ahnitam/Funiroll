import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:funiroll/states/login/login_stream_state.dart';
import 'package:funiroll/stores/login/streams_login_store.dart';
import 'package:funiroll/utils/types.dart';
import 'package:funiroll/views/home_view/components/my_buttom.dart';
import 'package:provider/provider.dart';

class LoginInfo extends StatelessWidget {
  final SvgPicture streamLogo;
  final StreamType streamType;
  final Color colorPrimary;

  const LoginInfo(
      {Key? key,
      required this.streamLogo,
      required this.streamType,
      required this.colorPrimary})
      : super(key: key);

  Widget textLeft(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontFamily: "Bree Serif",
      ),
    );
  }

  Widget textRigth(String label) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Text(
        label,
        style: TextStyle(
          fontStyle: FontStyle.italic,
          color: colorPrimary,
          fontFamily: "Bree Serif",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StreamsLoginStore>(context, listen: false);
    final login = store.logins[streamType] as StreamSucessLoginState;

    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: textLeft("SESSION: "),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: textRigth(login.user.session),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: textLeft("USER/EMAIL: "),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: textRigth(login.user.usernameOrEmail),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: textLeft("PLANO: "),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: textRigth(
                          (login.user.isPremium) ? "Premium" : "Free"),
                    ),
                  )
                ],
              ),
            ),
            MyButtom(
              height: 40,
              width: 80,
              color: colorPrimary,
              onPressed: () => store.logout(streamType),
              label: "LOGOUT",
            )
          ],
        ),
      ),
    );
  }
}
