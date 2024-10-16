import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'ai_util.dart';

class GptService {
  static const String _apiUrl = 'https://api.openai.com/v1/chat/completions';

  static Future<String> generateCourse(BuildContext context, String courseContent) async {
    final apiKey = Provider.of<ApiKeyProvider>(context, listen: false).openAiKey;
    if (apiKey.isEmpty) {
      throw Exception('OpenAI API key not set');
    }

    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-4o-2024-08-06',
        'messages': [
          {
            'role': 'system',
            'content': 'You are a course creator. Create a course based on the given context for your user to help them learn that document much better so they can ace their exams.'
          },
          {
            'role': 'user',
            'content': courseContent,
          },
        ],
        'response_format': {
          'type': 'json_schema',
          'json_schema': {
            'name': 'course',
            'strict': true,
            'schema': {
              'type': 'object',
              'properties': {
                'title': {
                  'type': 'string',
                  'description': 'The title of the course.'
                },
                'summary': {
                  'type': 'string',
                  'description': 'A summary of the course content.'
                },
                'modules': {
                  'type': 'array',
                  'items': {
                    'type': 'object',
                    'properties': {
                      'title': {
                        'type': 'string',
                        'description': 'The title of the module.'
                      },
                      'description': {
                        'type': 'string',
                        'description': 'Content of the given module that teaches users specifically about the module in detail.'
                      }
                    },
                    'required': ['title', 'description'],
                    'additionalProperties': false
                  },
                  'description': 'A list of modules in the course.'
                },
                'quiz': {
                  'type': 'array',
                  'items': {
                    'type': 'object',
                    'properties': {
                      'question': {
                        'type': 'string',
                        'description': 'The quiz question.'
                      },
                      'options': {
                        'type': 'array',
                        'items': {
                          'type': 'string'
                        },
                        'description': 'A list of answer options.'
                      },
                      'correctAnswer': {
                        'type': 'string',
                        'description': 'The correct answer to the question.'
                      }
                    },
                    'required': ['question', 'options', 'correctAnswer'],
                    'additionalProperties': false
                  },
                  'description': 'A list of quiz questions for the course.'
                }
              },
              'required': ['title', 'summary', 'modules', 'quiz'],
              'additionalProperties': false
            }
          }
        }
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to generate course: ${response.body}');
    }
  }
}