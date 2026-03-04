import 'package:flutter/material.dart';
import 'package:responsive_app/configure/app_colors.dart';
import 'package:responsive_app/configure/app_text_styles.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactFooter extends StatelessWidget {
  const ContactFooter({super.key});

  void launchInternalUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textColor = isDark ? Colors.white : AppColors.primaryTextLight;
    final iconColor = isDark ? AppColors.goldDark : AppColors.buttonGreenLight;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.goldLightDark : AppColors.borderLight,
            width: 2.0,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.instagram,
                          color: iconColor, size: 32),
                      onPressed: () =>
                          launchInternalUrl('https://instagram.com'),
                    ),
                    const SizedBox(width: 24),
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.facebook,
                          color: iconColor, size: 32),
                      onPressed: () =>
                          launchInternalUrl('https://facebook.com'),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () =>
                      launchInternalUrl('mailto:fiumicello.co@gmail.com'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.email_outlined, color: iconColor, size: 20),
                      const SizedBox(width: 8),
                      Text('fiumicello.co@gmail.com',
                          style: AppTextStyles.text(
                              color: textColor, fontSize: 14)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => launchInternalUrl('https://wa.me/573004499576'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(FontAwesomeIcons.whatsapp,
                          color: iconColor, size: 20),
                      const SizedBox(width: 8),
                      Text('300 4499576',
                          style: AppTextStyles.text(
                              color: textColor, fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Text(
                  'Direcciones',
                  style: AppTextStyles.text(color: textColor, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  'Carrera 7 #113-43 Torre Samsung Local L-108, Usaquen, Bogota.',
                  style: AppTextStyles.text(color: textColor, fontSize: 14),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => launchInternalUrl('https://wa.me/573212879920'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(FontAwesomeIcons.whatsapp,
                          color: iconColor, size: 20),
                      const SizedBox(width: 8),
                      Text('321 2879920',
                          style: AppTextStyles.text(
                              color: textColor, fontSize: 14)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Calle 19 #15-10, Sector Calambeo, Local 13, Ibagué, Tolima.',
                  style: AppTextStyles.text(color: textColor, fontSize: 14),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => launchInternalUrl('https://wa.me/573239426812'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(FontAwesomeIcons.whatsapp,
                          color: iconColor, size: 20),
                      const SizedBox(width: 8),
                      Text('323 9426812',
                          style: AppTextStyles.text(
                              color: textColor, fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
