import "package:flutter/material.dart";
import "package:mailer/mailer.dart";
import "package:mailer/smtp_server.dart";

class SmtpParams {
  final String host;
  final String username;
  final String key;
  final String port;

  SmtpParams({
    required this.host,
    required this.username,
    required this.key,
    required this.port,
  });
}

class EmailComposeScreen extends StatefulWidget {
  final SmtpParams params;
  EmailComposeScreen({required this.params});

  @override
  _EmailComposeScreenState createState() => _EmailComposeScreenState();
}

class _EmailComposeScreenState extends State<EmailComposeScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  String? emailResponse;

  @override
  Widget build(BuildContextcontext) {
    return Scaffold(
      appBar: AppBar(title: Text("ComposeEmail")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "EmailAddress"),
            ),
            TextField(
              controller: subjectController,
              decoration: InputDecoration(labelText: "Subject"),
            ),
            TextField(
              controller: messageController,
              decoration: InputDecoration(labelText: "Message"),
            ),
            ElevatedButton(
              onPressed: () async {
                String email = emailController.text;
                String subject = subjectController.text;
                String message = messageController.text;
                String username = widget.params.username;
                String password = widget.params.key;
                final smtpServer = SmtpServer(
                  widget.params.host,
                  port: int.parse(widget.params.port),
                  ssl: true,
                  username: username,
                  password: password,
                );
                final emailMessage = Message()
                  ..from = Address(username, "DanilaPalych")
                  ..recipients.add(email)
                  ..subject = subject
                  ..text = message;

                try {
                  final sendReport = await send(emailMessage, smtpServer);
                  setState(() {
                    emailResponse = "Message sent: " + sendReport.toString();
                  });
                } catch (e) {
                  setState(() {
                    emailResponse = "Errorsendingmessage:$e";
                  });
                }
              },
              child: Text("SendEmail"),
            ),
            SizedBox(height: 16.0),
            Text(emailResponse ?? ""),
          ],
        ),
      ),
    );
  }
}
