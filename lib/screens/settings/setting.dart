import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intellectiq/design/app_font.dart';
import 'package:intellectiq/design/colors.dart';
import 'package:intellectiq/utils/standard_format.dart';

import '../../utils/ai_util.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StdFormat(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: AppFont.body,
            fontWeight: FontWeight.bold,
            color: AppTheme.textMainColor,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'OpenAI API Key',
            style: TextStyle(
              fontSize: AppFont.head4,
              fontWeight: FontWeight.bold,
              color: AppTheme.textMainColor,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Enter your OpenAI API key to utilise the power of IntellectiQ app properly',
            style: TextStyle(
              fontSize: AppFont.body,
              color: AppTheme.textMainColor,
            ),
          ),
          const SizedBox(height: 16),
          Consumer<ApiKeyProvider>(
            builder: (context, apiKeyProvider, child) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.primaryAppColor),
                ),
                child: TextField(
                  controller: TextEditingController(text: apiKeyProvider.apiKey),
                  onChanged: (value) => apiKeyProvider.setApiKey(value),
                  decoration: const InputDecoration(
                    hintText: 'Enter your OpenAI API key',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  style: const TextStyle(
                    fontSize: AppFont.body,
                    color: AppTheme.textMainColor,
                    fontWeight: FontWeight.bold
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}