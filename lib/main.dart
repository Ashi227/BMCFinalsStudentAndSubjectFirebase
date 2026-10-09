import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'indicator.dart';
import 'input.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RegistrationFlow(),
    );
  }
}

// Details
class RegistrationFlow extends StatefulWidget {
  const RegistrationFlow({super.key});

  @override
  State<RegistrationFlow> createState() => _RegistrationFlowState();
}

class _RegistrationFlowState extends State<RegistrationFlow> {
  final name = TextEditingController();
  final section = TextEditingController();
  final course = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Your Profile'), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            StepIndicator(activeStep: 1),
            SizedBox(height: 20),
            Column(mainAxisAlignment: MainAxisAlignment.center, 
            children: [
              Text(
                'USER REGISTRATION',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(
                'Enter your registration details',
                style: TextStyle(fontSize: 14, color: Colors.grey)),
            ]),
            SizedBox(height: 50),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Personal Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('Tell us a little about your enrollment', style: TextStyle(fontSize: 14, color: Colors.grey)),
              ]),
            InputField(label: 'Name', icon: Icons.person, controller: name),
            InputField(label: 'Section', icon: Icons.category, controller: section),
            InputField(label: 'Course', icon: Icons.school, controller: course),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (name.text.trim().isEmpty ||
                    section.text.trim().isEmpty ||
                    course.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill in all fields')),
                  );
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubjectPage(
                      name: name.text,
                      section: section.text,
                      course: course.text,
                    ),
                  ),
                );
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

// subjects
class SubjectPage extends StatefulWidget {
  final String name;
  final String section;
  final String course;

  const SubjectPage({
    super.key,
    required this.name,
    required this.section,
    required this.course,
  });

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  final subject1 = TextEditingController();
  final subject2 = TextEditingController();
  TimeOfDay? start1, end1, start2, end2;

  Widget timeButton(String label, TimeOfDay? value, ValueChanged<TimeOfDay> onPicked) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: OutlinedButton(
          onPressed: () async {
            final t = await showTimePicker(
              context: context,
              initialTime: value ?? TimeOfDay.now(),
            );
            if (t != null) setState(() => onPicked(t));
          },
          child: Text(value == null ? label : value.format(context)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Your Subjects'), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            StepIndicator(activeStep: 2),
            SizedBox(height: 20),
            SizedBox(
              child: Column( mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('SUBJECT ENROLLMENT', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('Add subject and their class time', style: TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ),

            SizedBox(height: 50),
            SizedBox(
              child: Column( mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Your Subjects', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('Add subject and set its class schedule', style: TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ),

            InputField(label: 'Subject 1', icon: Icons.book, controller: subject1),
            Row(children: [
              timeButton('Start time', start1, (t) => start1 = t),
              timeButton('End time', end1, (t) => end1 = t),
            ]),

            SizedBox(height: 20),

            InputField(label: 'Subject 2', icon: Icons.book, controller: subject2),
            Row(children: [
              timeButton('Start time', start2, (t) => start2 = t),
              timeButton('End time', end2, (t) => end2 = t),
            ]),

            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (subject1.text.trim().isEmpty ||
                        subject2.text.trim().isEmpty ||
                        start1 == null ||
                        end1 == null ||
                        start2 == null ||
                        end2 == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Fill in both subjects and all times')),
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewPage(
                          name: widget.name,
                          section: widget.section,
                          course: widget.course,
                          subject1: subject1.text,
                          time1: '${start1!.format(context)} - ${end1!.format(context)}',
                          subject2: subject2.text,
                          time2: '${start2!.format(context)} - ${end2!.format(context)}',
                        ),
                      ),
                    );
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// review page
class ReviewPage extends StatelessWidget {
  final String name, section, course;
  final String subject1, time1, subject2, time2;

  const ReviewPage({
    super.key,
    required this.name,
    required this.section,
    required this.course,
    required this.subject1,
    required this.time1,
    required this.subject2,
    required this.time2,
  });

  Widget row(IconData icon, String value, String label) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue),
          SizedBox(
            width: 110,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Review'), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            StepIndicator(activeStep: 3),
            SizedBox(height: 20),
            SizedBox(
              child: Column( mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Verification', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('Review your details before saving', style: TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ),
            SizedBox(height: 50),
            Text('Review your Details?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text('Make sure all the information is correct before saving', style: TextStyle(fontSize: 14, color: Colors.grey)),
            SizedBox(height: 20),
            row(Icons.person, name, 'Name:'),
            row(Icons.group, section, 'Section:'),
            row(Icons.school, course, 'Course:'),
            Divider(),
            SizedBox(height: 20),
            SizedBox(
              child: Column( mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Class Schedule', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(height: 20),
            row(Icons.book, '', subject1),
            row(Icons.access_time, '', time1),
            Divider(),
            row(Icons.book, '', subject2),
            row(Icons.access_time, '', time2),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: () {
                    FirebaseFirestore.instance.collection('users').add({
                      'name': name,
                      'section': section,
                      'course': course,
                      'subjects': [
                        {'subject': subject1, 'time': time1},
                        {'subject': subject2, 'time': time2},
                      ],
                    });
                      ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Saved!')),
                    );
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}