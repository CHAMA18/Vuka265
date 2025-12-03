# Chat Features Implementation Guide

## Overview
This document outlines the video/voice calling, emoji picker, and multimedia messaging features being added to the SingleChat screen.

## Features Implemented

### 1. **Dependencies Added** (pubspec.yaml)
- `videosdk: ^1.1.5` - For video/voice calling
- `emoji_picker_flutter: ^2.2.0` - For emoji keyboard
- `record: ^5.1.2` - For voice recording
- `audioplayers: ^6.1.0` - For audio playback
- `image_picker` (already present) - For camera/gallery
- `file_picker` (already present) - For document picking

### 2. **Services Created**

#### VideoSDK Service (`lib/services/videosdk_service.dart`)
- API Key: `006aedd2-3c0c-471d-948f-728b84ac35db`
- Secret Key: `6a5a2ebd92d416f3256226ac1fe10421547126514d601d2921a21d532e2eaec6`
- Methods:
  - `createMeeting()` - Creates a new meeting room
  - `validateMeeting(meetingId)` - Validates meeting existence
  - `getMeetingToken(meetingId)` - Gets authentication token

### 3. **Video Call Screen** (`lib/chats/video_call/`)
- `video_call_widget.dart` - Full-featured video/voice call interface
- `video_call_model.dart` - State management for video calls
- Features:
  - Video grid for multiple participants
  - Audio-only mode for voice calls
  - Mute/unmute microphone
  - Enable/disable camera
  - Gradient overlays with professional UI

### 4. **Messages Schema Updates** (`lib/backend/schema/messages_record.dart`)
Added new fields to support multimedia messages:
- `messageType` (String) - Type of message: 'text', 'image', 'document', 'audio', 'video_call', 'voice_call'
- `mediaUrl` (String) - URL of media file
- `mediaDuration` (int) - Duration in seconds for audio/video

### 5. **Single Chat Model Updates** (`lib/chats/single_chat/single_chat_model.dart`)
Added state fields:
- `showEmojiPicker` (bool) - Controls emoji picker visibility
- `isRecording` (bool) - Tracks recording state

## Features to Implement in single_chat_widget.dart

The following changes need to be made to `lib/chats/single_chat/single_chat_widget.dart`:

### Import Statements (lines 1-18)
Add these imports:
```dart
import '/services/videosdk_service.dart';
import '/backend/firebase_storage/storage.dart';
import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
```

### State Variables (lines 37-40)
Add after `late SingleChatModel _model;`:
```dart
final AudioRecorder _audioRecorder = AudioRecorder();
final AudioPlayer _audioPlayer = AudioPlayer();
String? _audioPath;
```

### Voice Call Button (lines 248-250)
Replace `onPressed` with:
```dart
onPressed: () async {
  await _startCall(isVideoCall: false);
},
```

### Video Call Button (lines 268-270)
Replace `onPressed` with:
```dart
onPressed: () async {
  await _startCall(isVideoCall: true);
},
```

### Emoji Icon (lines 965-987)
Wrap the Container in an InkWell:
```dart
InkWell(
  onTap: () {
    setState(() {
      _model.showEmojiPicker = !_model.showEmojiPicker;
      if (_model.showEmojiPicker) {
        FocusScope.of(context).unfocus();
      }
    });
  },
  child: Container(
    // ... existing Container code
  ),
),
```

### Camera Button (lines 1151-1154)
Replace `onPressed` with:
```dart
onPressed: () async {
  await _pickImage(ImageSource.camera);
  _model.other = false;
  safeSetState(() {});
},
```

### Document Button (lines 1192-1195)
Replace `onPressed` with:
```dart
onPressed: () async {
  await _pickDocument();
  _model.other = false;
  safeSetState(() {});
},
```

### Gallery Button (lines 1233-1236)
Replace `onPressed` with:
```dart
onPressed: () async {
  await _pickImage(ImageSource.gallery);
  _model.other = false;
  safeSetState(() {});
},
```

### Audio Button (lines 1274-1277)
Replace `onPressed` with:
```dart
onPressed: () async {
  await _startRecording();
  _model.other = false;
  safeSetState(() {});
},
```

### Emoji Picker Widget (After line 1299, before closing Column)
Add before the closing `],` of the Column:
```dart
if (_model.showEmojiPicker)
  SizedBox(
    height: 250,
    child: EmojiPicker(
      onEmojiSelected: (category, emoji) {
        final controller = _model.textMessageTextController;
        final text = controller!.text;
        final selection = controller.selection;
        final newText = text.replaceRange(
          selection.start,
          selection.end,
          emoji.emoji,
        );
        controller.text = newText;
        controller.selection = TextSelection.collapsed(
          offset: selection.start + emoji.emoji.length,
        );
      },
      config: Config(
        emojiViewConfig: EmojiViewConfig(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          columns: 7,
          emojiSizeMax: 32,
        ),
        categoryViewConfig: CategoryViewConfig(
          iconColor: FlutterFlowTheme.of(context).secondaryText,
          iconColorSelected: FlutterFlowTheme.of(context).primary,
          indicatorColor: FlutterFlowTheme.of(context).primary,
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        ),
        bottomActionBarConfig: BottomActionBarConfig(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        ),
      ),
    ),
  ),
```

### Helper Methods (Before the final closing brace at line 1308)
Add these methods:

```dart
Future<void> _startCall({required bool isVideoCall}) async {
  try {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(
          color: FlutterFlowTheme.of(context).primary,
        ),
      ),
    );

    final meetingId = await VideoSDKService.createMeeting();
    Navigator.of(context).pop();

    if (!mounted) return;

    context.pushNamed(
      'VideoCall',
      extra: {
        'meetingId': meetingId,
        'userName': widget.chatWithName ?? 'User',
        'isAudioOnly': !isVideoCall,
      },
    );

    await MessagesRecord.createDoc(widget.recieveChats!).set(
      createMessagesRecordData(
        timestamp: getCurrentTimestamp,
        messageText: isVideoCall ? '📹 Video call' : '📞 Voice call',
        senderId: currentUserReference,
        senderName: currentUserDisplayName,
        messageType: isVideoCall ? 'video_call' : 'voice_call',
        mediaUrl: meetingId,
      ),
    );
  } catch (e) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to start call: $e'),
        backgroundColor: FlutterFlowTheme.of(context).error,
      ),
    );
  }
}

Future<void> _pickImage(ImageSource source) async {
  try {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(
            color: FlutterFlowTheme.of(context).primary,
          ),
        ),
      );

      final bytes = await pickedFile.readAsBytes();
      final uploadedUrl = await uploadData(pickedFile.path, bytes);

      if (uploadedUrl != null) {
        await _sendMediaMessage(
          messageType: 'image',
          mediaUrl: uploadedUrl,
          messageText: '📷 Photo',
        );
      }

      Navigator.of(context).pop();
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to send image: $e'),
        backgroundColor: FlutterFlowTheme.of(context).error,
      ),
    );
  }
}

Future<void> _pickDocument() async {
  try {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(
            color: FlutterFlowTheme.of(context).primary,
          ),
        ),
      );

      final bytes = file.bytes;
      if (bytes != null) {
        final uploadedUrl = await uploadData(file.name, bytes);

        if (uploadedUrl != null) {
          await _sendMediaMessage(
            messageType: 'document',
            mediaUrl: uploadedUrl,
            messageText: '📄 ${file.name}',
          );
        }
      }

      Navigator.of(context).pop();
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to send document: $e'),
        backgroundColor: FlutterFlowTheme.of(context).error,
      ),
    );
  }
}

Future<void> _startRecording() async {
  try {
    if (await _audioRecorder.hasPermission()) {
      setState(() => _model.isRecording = true);

      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: path,
      );

      _audioPath = path;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.mic,
                color: FlutterFlowTheme.of(context).error,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'Recording...',
                style: FlutterFlowTheme.of(context).titleMedium,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () async {
                      await _audioRecorder.stop();
                      setState(() => _model.isRecording = false);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await _stopRecordingAndSend();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FlutterFlowTheme.of(context).primary,
                    ),
                    child: Text(
                      'Send',
                      style: TextStyle(
                        color: FlutterFlowTheme.of(context).info,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Microphone permission denied'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    }
  } catch (e) {
    setState(() => _model.isRecording = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to record audio: $e'),
        backgroundColor: FlutterFlowTheme.of(context).error,
      ),
    );
  }
}

Future<void> _stopRecordingAndSend() async {
  try {
    final path = await _audioRecorder.stop();
    setState(() => _model.isRecording = false);

    if (path != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(
            color: FlutterFlowTheme.of(context).primary,
          ),
        ),
      );

      final bytes = await File(path).readAsBytes();
      final uploadedUrl = await uploadData(path, bytes);

      if (uploadedUrl != null) {
        await _sendMediaMessage(
          messageType: 'audio',
          mediaUrl: uploadedUrl,
          messageText: '🎤 Voice message',
        );
      }

      Navigator.of(context).pop();
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to send audio: $e'),
        backgroundColor: FlutterFlowTheme.of(context).error,
      ),
    );
  }
}

Future<void> _sendMediaMessage({
  required String messageType,
  required String mediaUrl,
  required String messageText,
  int? mediaDuration,
}) async {
  try {
    await MessagesRecord.createDoc(widget.recieveChats!).set(
      createMessagesRecordData(
        timestamp: getCurrentTimestamp,
        messageText: messageText,
        senderId: currentUserReference,
        senderName: currentUserDisplayName,
        messageType: messageType,
        mediaUrl: mediaUrl,
        mediaDuration: mediaDuration,
      ),
    );

    final chatDoc = await widget.recieveChats!.get();
    final chatData = ChatsRecord.fromSnapshot(chatDoc);

    for (final userRef in chatData.userIDs) {
      if (userRef != currentUserReference) {
        await NotificationsRecord.collection.doc().set(
          createNotificationsRecordData(
            notificationTitle: 'New Message',
            notficationContent:
                'You received a new message from $currentUserDisplayName',
            timeDate: getCurrentTimestamp,
            user: userRef,
            delivered: false,
            senderID: currentUserReference,
          ),
        );
      }
    }

    await widget.recieveChats!.update({
      ...createChatsRecordData(
        lastMessage: messageText,
        lastMessageTime: getCurrentTimestamp,
      ),
      ...mapToFirestore({
        'lastSeenBy': FieldValue.delete(),
      }),
    });

    await widget.recieveChats!.update({
      ...mapToFirestore({
        'lastSeenBy': FieldValue.arrayUnion([currentUserReference]),
      }),
    });
  } catch (e) {
    rethrow;
  }
}

@override
void dispose() {
  _audioRecorder.dispose();
  _audioPlayer.dispose();
  super.dispose();
}
```

## Next Steps

1. Apply all the changes listed above to `single_chat_widget.dart`
2. Update the navigation configuration to include the VideoCall route
3. Add necessary permissions to platform-specific files:
   - Android: `android/app/src/main/AndroidManifest.xml`
   - iOS: `ios/Runner/Info.plist`
4. Test each feature individually
5. Handle message rendering for different media types in the ListView

## Required Permissions

### Android (AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
```

### iOS (Info.plist)
```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is required for video calls and photo sharing</string>
<key>NSMicrophoneUsageDescription</key>
<string>Microphone access is required for voice/video calls and voice messages</string>
```
