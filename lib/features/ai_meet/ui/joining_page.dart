import 'package:flutter/material.dart';
import 'package:vibe_connect/features/ai_meet/services/api_call.dart';
import 'package:vibe_connect/features/ai_meet/additional%20ui/testui/meeting_screen.dart';
import 'package:vibe_connect/features/ai_meet/additional%20ui/askjoin.dart';
import 'package:vibe_connect/features/ai_meet/ui/meet_page.dart';

class JoiningPage extends StatefulWidget {
  const JoiningPage({super.key});

  @override
  State<JoiningPage> createState() => _JoiningPageState();
}

class _JoiningPageState extends State<JoiningPage> {
  final TextEditingController _meetingIdController = TextEditingController();

  @override
  void dispose() {
    _meetingIdController.dispose();
    super.dispose();
  }

  void _onJoinMeeting(BuildContext context) {
    String meetingId = _meetingIdController.text;
    var re = RegExp(r"\w{4}-\w{4}-\w{4}");
    if (meetingId.isNotEmpty && re.hasMatch(meetingId)) {
      _meetingIdController.clear();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MeetPage(
            meetingId: meetingId,
            token: token,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter a valid meeting ID"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF58A0C8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              minimumSize: const Size(80, 60), // Ensures width for 'Cancel'
              padding: EdgeInsets.zero, // Avoid extra padding
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.blue, fontSize: 15),
            ),
          ),
        ),
        titleSpacing: 20,
        title: const Text(
          'Join with a code',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the bottom sheet
                _onJoinMeeting(context);
              },
              style: TextButton.styleFrom(
                minimumSize: const Size(80, 60), // Ensures width for 'Cancel'
                padding: EdgeInsets.zero, // Avoid extra padding
              ),
              child: const Text(
                'Join',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter the code provided by the\nmeeting organiser',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _meetingIdController,
              autofocus: true, // This will automatically pop up the keyboard
              decoration: InputDecoration(
                hintText: 'Example: abc-mnop-xyz',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 12.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
