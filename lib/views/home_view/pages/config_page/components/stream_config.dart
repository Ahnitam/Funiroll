import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:funiroll/states/login/login_stream_state.dart';
import 'package:funiroll/stores/login/streams_login_store.dart';
import 'package:funiroll/utils/types.dart';
import 'package:funiroll/interfaces/stream.dart';
import 'package:funiroll/views/home_view/pages/config_page/components/login_config.dart';
import 'package:funiroll/views/home_view/pages/config_page/components/login_info.dart';
import 'package:provider/provider.dart';

class StreamConfig extends StatelessWidget {
  final StreamType streamType;

  const StreamConfig({Key? key, required this.streamType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stream = context.read<Map<StreamType, Stream>>()[streamType]!;
    final store = context.watch<StreamsLoginStore>();
    final login = store.logins[streamType]!;

    Widget? child;
    if (login is StreamSucessLoginState) {
      child = LoginInfo(
        streamLogo: SvgPicture.asset(
          stream.pathLogoTexto,
          color: stream.color,
        ),
        colorPrimary: stream.color,
        streamType: streamType,
      );
    } else if (login is StreamLoadingLoginState) {
      child = const Center(
        child: CircularProgressIndicator(
          color: Colors.green,
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: SizedBox(
              height: 40,
              width: 160,
              child: SvgPicture.asset(
                stream.pathLogoTexto,
                color: stream.color,
              ),
            ),
          ),
          Expanded(
            child: child ??
                LoginConfig(
                  streamType: streamType,
                  colorBorderField: stream.color,
                ),
          ),
        ],
      ),
    );
  }
}
