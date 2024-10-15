import 'package:flutter/material.dart';
import 'package:ssoauth/oidc_auth_service.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  void initState() {
    super.initState();
    initAction();
  }

  initAction() async {
    final bool isAuth = await OIDCAuthService.instance.init();
    if (isAuth) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter OIDC SSO APP 1'),
      ),
      body: Center(
          child: OIDCAuthService.instance.profile != null
              ? Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await OIDCAuthService.instance.logout();
                        setState(() {});
                      },
                      child: Text('logout'),
                    ),
                    Text("Name: ${OIDCAuthService.instance.profile?.name}"),
                    Text("Email: ${OIDCAuthService.instance.profile?.email}")
                  ],
                )
              : Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await OIDCAuthService.instance.login();
                        setState(() {});
                      },
                      child: Text('Sign in with OIDC'),
                    ),
                  ],
                )),
    );
  }
}
