import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping/bindings/general_bindings.dart';
import 'package:shopping/features/authentication/screens/onboarding/onboarding.dart';
import 'package:shopping/routes/app_routes.dart';
import 'package:shopping/utils/constants/colors.dart';
import 'package:shopping/utils/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      initialBinding: GeneralBindings(),
      getPages: AppRoutes.pages,
      home: const Scaffold(
        backgroundColor: TColors.primary,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      ),
    );
  }
}
