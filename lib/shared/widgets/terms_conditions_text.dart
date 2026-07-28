import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/app_route.dart';
import '../../core/theme/pk_design.dart';

class TermsConditionsText extends StatefulWidget {
  const TermsConditionsText({super.key});

  @override
  State<TermsConditionsText> createState() => _TermsConditionsTextState();
}

class _TermsConditionsTextState extends State<TermsConditionsText> {
  late final TapGestureRecognizer _recognizerSnK;
  late final TapGestureRecognizer _recognizerPrivacy;

  @override
  void initState() {
    super.initState();
    _recognizerSnK = TapGestureRecognizer()
      ..onTap = () {
        context.pushNamed(AppRoute.termsConditions.name);
      };
    _recognizerPrivacy = TapGestureRecognizer()
      ..onTap = () {
        context.pushNamed(AppRoute.privacyPolicy.name);
      };
  }

  @override
  void dispose() {
    _recognizerSnK.dispose();
    _recognizerPrivacy.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: PkSpacing.lg, bottom: PkSpacing.sm),
      child: Text.rich(
        TextSpan(
          text: 'Dengan masuk atau mendaftar, saya menyetujui ',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: PkColors.text2, height: 1.5),
          children: [
            TextSpan(
              text: 'Syarat dan Ketentuan',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
              recognizer: _recognizerSnK,
            ),
            const TextSpan(text: ' serta '),
            TextSpan(
              text: 'Kebijakan Privasi',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
              recognizer: _recognizerPrivacy,
            ),
            const TextSpan(text: ' PeduliKeluarga'),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
