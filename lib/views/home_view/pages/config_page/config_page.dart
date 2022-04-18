import 'package:flutter/material.dart';
import 'package:funiroll/interfaces/info_provider.dart';
import 'package:funiroll/views/home_view/pages/config_page/components/provider_config.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:funiroll/utils/types.dart';
import 'package:funiroll/interfaces/stream.dart';
import 'package:funiroll/views/home_view/pages/config_page/components/stream_config.dart';

class ConfigPage extends StatelessWidget {
  const ConfigPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final streams = context.read<Map<StreamType, Stream>>();
    final providers = context.read<Map<ProvidersType, InfoProvider>>();
    final tabs = List<Tab>.generate(streams.length + providers.length, (index) {
      if (index < streams.length) {
        return Tab(
          icon: SvgPicture.asset(
            streams.values.elementAt(index).pathLogo,
            width: 25,
            color: streams.values.elementAt(index).color,
          ),
        );
      } else {
        return Tab(
          icon: SvgPicture.asset(
            providers.values.elementAt(index - streams.length).pathLogo,
            width: 25,
            color: providers.values.elementAt(index - streams.length).color,
          ),
        );
      }
    });

    final tabViews =
        List<Widget>.generate(streams.length + providers.length, (index) {
      if (index < streams.length) {
        return StreamConfig(
          streamType: streams.values.elementAt(index).type,
        );
      } else {
        return ProvidersConfig(
            providerType:
                providers.values.elementAt(index - streams.length).type);
      }
    });

    return DefaultTabController(
      length: streams.length + 1,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(25, 80, 25, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Theme(
              data: ThemeData().copyWith(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
              ),
              child: TabBar(
                indicatorColor: Colors.green[900],
                indicator: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Color.fromARGB(155, 33, 33, 33),
                ),
                tabs: tabs,
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                child: Container(
                  color: const Color.fromARGB(155, 33, 33, 33),
                  child: TabBarView(
                    physics: const BouncingScrollPhysics(),
                    children: tabViews,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
