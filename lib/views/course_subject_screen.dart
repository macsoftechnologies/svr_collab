import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:svr/views/home_icons_views/test_questions.dart';

class CourseSubjectScreen extends StatefulWidget {
  final String courseId;

  const CourseSubjectScreen({super.key, required this.courseId});

  @override
  _CourseSubjectScreenState createState() => _CourseSubjectScreenState();
}

class _CourseSubjectScreenState extends State<CourseSubjectScreen> {
  List<dynamic> subjects = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchSubjects();
  }

  Future<void> fetchSubjects() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('https://svracademy.in/services/users/getCoursebasedsubjects'),
        headers: {
          'Content-Type': 'application/json',
          'Auth-Key': 'svrapi',
        },
        body: jsonEncode({'course_id': widget.courseId}),
      );

      print('Subjects API response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = json.decode(response.body);

        if (result['result'] != null && result['result'] is List) {
          setState(() {
            subjects = result['result'] as List<dynamic>;
            isLoading = false;
          });
        } else {
          setState(() {
            subjects = [];
            isLoading = false;
            errorMessage = 'No subjects found.';
          });
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'API Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      print('Error fetching subjects: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Something went wrong. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Subjects'),
      ),
      body: RefreshIndicator(
        onRefresh: fetchSubjects,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(child: Text(errorMessage!))
                : subjects.isEmpty
                    ? const Center(child: Text('No subjects available.'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: subjects.length,
                        itemBuilder: (context, index) {
                          final subject = subjects[index];
                          return Card(
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue.shade100,
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                subject['subject_name'] ?? 'Untitled Subject',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              // subtitle: Text(
                              //   'Test ID: ${subject['test_id'] ?? '-'}',
                              // ),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => TestQuestions(
        courseId: widget.courseId,
      ),
    ),
  );

                              },
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}