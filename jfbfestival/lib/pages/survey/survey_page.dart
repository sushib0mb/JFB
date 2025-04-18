// lib/pages/survey/survey_page.dart
//
// Uses Hive for local cache + Supabase for backend storage.

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';         // 🔄

import '../../models/survey_entry.dart';

// quick alias if you need the client elsewhere in this file
final supabase = Supabase.instance.client;                       // 🔄

class SurveyPage extends StatefulWidget {
  static const routeName = '/survey';
  const SurveyPage({super.key});

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  final _formKey = GlobalKey<FormState>();
  int _usability = 3;
  int _features  = 3;
  final _commentsCtrl = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // 1) Build entry
    final entry = SurveyEntry(
      timestamp: DateTime.now(),
      usabilityRating: _usability,
      featureRating: _features,
      comments: _commentsCtrl.text.trim(),
    );

    // 2) Save locally in Hive
    final box = Hive.box<SurveyEntry>('survey');
    await box.add(entry);

    // 3) Send to Supabase ---------------------------------------------- 🔄
    try {
      await supabase.from('survey').insert({
        'timestamp': entry.timestamp.toIso8601String(),
        'usability': entry.usabilityRating,
        'features' : entry.featureRating,
        'comments' : entry.comments,
      });                                                           // :contentReference[oaicite:0]{index=0}
    } catch (e) {
      debugPrint('Supabase write failed: $e');
      // consider retry / offline‑queue logic here
    }

    // 4) Notify & pop
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thank you for your feedback!')),
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _commentsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App Feedback Survey')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text('1. How usable did you find the app?',
                  style: TextStyle(fontSize: 16)),
              Slider(
                value: _usability.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                label: '$_usability',
                onChanged: (v) => setState(() => _usability = v.round()),
              ),
              const SizedBox(height: 16),
              const Text('2. How do you rate the feature set?',
                  style: TextStyle(fontSize: 16)),
              Slider(
                value: _features.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                label: '$_features',
                onChanged: (v) => setState(() => _features = v.round()),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _commentsCtrl,
                decoration: const InputDecoration(
                  labelText: 'Any additional comments?',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
