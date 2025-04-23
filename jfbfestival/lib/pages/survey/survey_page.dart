// lib/pages/survey/survey_page.dart

import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
import '../../config/supabase_config.dart';
// import '../../models/survey_entry.dart';

class SurveyPage extends StatefulWidget {
  static const routeName = '/survey';
  const SurveyPage({super.key});

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  final _formKey = GlobalKey<FormState>();
  String? gender;
  String? from;
  String? heardFrom;
  String? lookingForward;
  String? age;
  String? cameWith;
  String? participated;

  final genderOther = TextEditingController();
  final fromOther = TextEditingController();
  final heardOther = TextEditingController();
  final lookingOther = TextEditingController();
  final cameWithOther = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final response = {
      'gender': gender == 'Other' ? genderOther.text : gender,
      'from': from == 'Other' ? fromOther.text : from,
      'heard': heardFrom == 'Other' ? heardOther.text : heardFrom,
      'looking': lookingForward == 'Other' ? lookingOther.text : lookingForward,
      'age': age,
      'cameWith': cameWith == 'Other' ? cameWithOther.text : cameWith,
      'participated': participated,
      'timestamp': DateTime.now().toIso8601String(),
    };

    try {
      await supabase.from('survey').insert(response);
    } catch (e) {
      debugPrint('Supabase insert failed: $e');
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thank you for your feedback!')),
    );
    if (mounted) Navigator.of(context).pop();
  }

  Widget _buildRadioGroup(
    String title,
    List<String> options,
    String? groupVal,
    void Function(String?) onChanged, [
    TextEditingController? otherCtrl,
  ]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16)),
        ...options.map(
          (opt) => RadioListTile(
            title: Text(opt),
            value: opt,
            groupValue: groupVal,
            onChanged: onChanged,
          ),
        ),
        if (options.contains('Other') && groupVal == 'Other')
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: TextFormField(
              controller: otherCtrl,
              decoration: const InputDecoration(labelText: 'Other:'),
            ),
          ),
        const SizedBox(height: 24),
      ],
    );
  }

  @override
  void dispose() {
    genderOther.dispose();
    fromOther.dispose();
    heardOther.dispose();
    lookingOther.dispose();
    cameWithOther.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Festival Survey')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildRadioGroup(
                "What is your gender?",
                ["Male", "Female", "Prefer not to say", "Other"],
                gender,
                (val) => setState(() => gender = val),
                genderOther,
              ),

              _buildRadioGroup(
                "Where are you coming from?",
                ["Massachusetts", "Rhode Island", "New Hampshire", "Other"],
                from,
                (val) => setState(() => from = val),
                fromOther,
              ),

              _buildRadioGroup(
                "How did you hear about us?",
                ["Twitter", "Facebook", "Official Website", "Friend", "Other"],
                heardFrom,
                (val) => setState(() => heardFrom = val),
                heardOther,
              ),

              _buildRadioGroup(
                "What were you looking forward to most?",
                ["Stage", "Food", "Culture", "Activities", "Booth", "Other"],
                lookingForward,
                (val) => setState(() => lookingForward = val),
                lookingOther,
              ),

              _buildRadioGroup(
                "Age?",
                ["11-19", "20-29", "30-39", "40-49", "50-59", "60-69", "70-"],
                age,
                (val) => setState(() => age = val),
              ),

              _buildRadioGroup(
                "Did you come with",
                ["Family", "Friends", "On your own", "Other"],
                cameWith,
                (val) => setState(() => cameWith = val),
                cameWithOther,
              ),

              _buildRadioGroup(
                "Did you participate in the past?",
                ["First time!", "2nd or 3rd time", "4 time or more"],
                participated,
                (val) => setState(() => participated = val),
              ),

              const SizedBox(height: 12),
              ElevatedButton(onPressed: _submit, child: const Text('Submit')),
            ],
          ),
        ),
      ),
    );
  }
}
