import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:funiroll/interfaces/info_provider.dart';
import 'package:funiroll/states/login/login_provider_state.dart';
import 'package:funiroll/stores/login/providers_login_store.dart';
import 'package:funiroll/utils/types.dart';
import 'package:funiroll/views/home_view/components/my_buttom.dart';
import 'package:provider/provider.dart';

class ProvidersConfig extends StatelessWidget {
  final ProvidersType providerType;

  const ProvidersConfig({Key? key, required this.providerType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<Map<ProvidersType, InfoProvider>>(context)[providerType]!;
    final loginStore = Provider.of<ProvidersLoginStore>(context, listen: true);
    final login = loginStore.logins[providerType]!;

    Widget? child;
    if (login is ProviderSucessLoginState && !provider.isWebLogin) {
    } else if (login is ProviderLoadingLoginState) {
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
                provider.pathLogoTexto,
                color: provider.color,
              ),
            ),
          ),
          Expanded(
            child: child ??
                ((provider.isWebLogin)
                    ? Center(
                        child: MyButtom(
                          label: "Go To Web",
                          onPressed: () async {
                            await loginStore.logar("", "", providerType);
                            Navigator.pushNamed(
                                context, "/${providerType.name}");
                          },
                          width: 100,
                          height: 50,
                        ),
                      )
                    : Container()),
          )
        ],
      ),
    );
  }
}
