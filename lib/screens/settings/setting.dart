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
          _buildApiKeyInput(
            context,
            'OpenAI API Key',
            'Enter your OpenAI API key',
                (value) => context.read<ApiKeyProvider>().setOpenAiKey(value),
                () => context.read<ApiKeyProvider>().openAiKey,
          ),
          const SizedBox(height: 24),
          _buildApiKeyInput(
            context,
            'AssemblyAI API Key',
            'Enter your AssemblyAI API key',
                (value) => context.read<ApiKeyProvider>().setAssemblyAiKey(value),
                () => context.read<ApiKeyProvider>().assemblyAiKey,
          ),
        ],
      ),
    );
  }

  Widget _buildApiKeyInput(
      BuildContext context,
      String title,
      String hint,
      Function(String) onChanged,
      String Function() getValue,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: AppFont.head4,
            fontWeight: FontWeight.bold,
            color: AppTheme.textMainColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.primaryAppColor),
          ),
          child: TextField(
            controller: TextEditingController(text: getValue()),
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            style: const TextStyle(
              fontSize: AppFont.body,
              color: AppTheme.textMainColor,
            ),
          ),
        ),
      ],
    );
  }
}