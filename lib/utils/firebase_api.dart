import 'package:firebase_messaging/firebase_messaging.dart';
im<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Git Commit UI</title>
  <style>
    body { font-family: Arial, sans-serif; padding: 2em; background: #f5f5f5; }
    .container { max-width: 500px; margin: auto; background: white; padding: 2em; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
    label { display: block; margin-top: 1em; }
    input, textarea, button { width: 100%; padding: 0.8em; margin-top: 0.5em; }
    button { background: #2d8cf0; color: white; border: none; border-radius: 4px; }
  </style>
</head>
<body>
  <div class="container">
    <h2>Git Commit UI</h2>
    <form id="commitForm">
      <label for="filename">File name:</label>
      <input type="text" id="filename" name="filename" placeholder="e.g. main.py">

      <label for="message">Commit message:</label>
      <textarea id="message" name="message" rows="4" placeholder="e.g. Fix bug in login function"></textarea>

      <button type="submit">Commit</button>
    </form>
  </div>

  <script>
    document.getElementById('commitForm').addEventListener('submit', function(e) {
      e.preventDefault();
      const filename = document.getElementById('filename').value;
      const message = document.getElementById('message').value;
      alert(`git add ${filename}\ngit commit -m "${message}"`);
      // Thực tế cần xử lý server-side hoặc sử dụng Node.js để chạy Git lệnh.
    });
  </script>
</body>
</html>

    FirebaseMessaging.onMessage.listen((message) {
      final context = Get.context;

      if (context != null && message.notification != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message.notification?.title ?? 'No Title'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    });
    initPushNotification();
  }
}
