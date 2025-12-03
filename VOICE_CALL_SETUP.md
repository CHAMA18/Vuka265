# Free Voice Call Setup Guide

## Overview
I've removed the video chat icon and implemented a **completely free voice calling solution** using Agora's free tier, which provides 10,000 minutes of voice calling per month at no cost.

## Changes Made

### 1. Removed Video Chat Icon
- ✅ Removed the video camera icon from the chat screen
- ✅ Kept only the voice call (phone) icon

### 2. Replaced VideoSDK with Agora
- ✅ Removed `videosdk: ^2.2.0` dependency
- ✅ Removed `flutter_webrtc: ^1.0.0` dependency  
- ✅ Added `agora_rtc_engine: ^6.0.0` (completely free for up to 10,000 minutes/month)

### 3. New Files Created
- `lib/services/agora_service.dart` - Agora integration service
- Updated `lib/chats/video_call/video_call_widget.dart` - Voice-only call screen
- Updated `lib/chats/single_chat/single_chat_widget.dart` - Integrated Agora calling

## Setup Instructions

### Step 1: Create Free Agora Account

1. Go to [https://www.agora.io](https://www.agora.io)
2. Click "Sign Up" and create a free account
3. Once logged in, go to the Agora Console: [https://console.agora.io](https://console.agora.io)

### Step 2: Create a Project

1. In the Agora Console, click "Projects" in the left sidebar
2. Click "Create" button
3. Enter a project name (e.g., "VukaVoiceChat")
4. For "Authentication mechanism", select **"Testing Mode (Not secured)"** for now
   - This allows testing without token generation (perfect for development)
   - For production, you should enable "Secured mode" and generate tokens server-side
5. Click "Submit"

### Step 3: Get Your App ID

1. After creating the project, you'll see your **App ID** displayed
2. Copy this App ID

### Step 4: Update the Code

Open `lib/services/agora_service.dart` and replace the placeholder:

```dart
static const String appId = 'your_agora_app_id_here';
```

With your actual App ID:

```dart
static const String appId = 'YOUR_ACTUAL_APP_ID';
```

### Step 5: Platform-Specific Configuration

#### Android Configuration
The `agora_rtc_engine` package needs some Android permissions. These should already be in your `android/app/src/main/AndroidManifest.xml`, but verify these permissions are present:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
<uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
```

#### iOS Configuration
For iOS, add these to `ios/Runner/Info.plist`:

```xml
<key>NSMicrophoneUsageDescription</key>
<string>We need access to your microphone for voice calls</string>
```

### Step 6: Test the Implementation

1. Hot Restart your app (click the "Hot Restart" button in Dreamflow)
2. Navigate to any chat
3. Click the voice call (phone) icon
4. The call screen should appear with:
   - User name
   - Connection status
   - Mute button
   - End call button
   - Speaker button

## Features

✅ **Free Voice Calling** - 10,000 minutes/month completely free
✅ **Peer-to-Peer** - Direct voice connection between users
✅ **Low Latency** - Agora provides high-quality, low-latency audio
✅ **Auto-Reconnect** - Handles network issues automatically
✅ **Mute Control** - Users can mute/unmute during calls
✅ **Call Duration Timer** - Shows call duration in real-time
✅ **Incoming Call Screen** - Beautiful ring screen for incoming calls

## How It Works

1. **Initiating a Call:**
   - User clicks the phone icon
   - A unique channel name is generated using Agora
   - A notification is sent to the other user
   - The caller joins the Agora voice channel

2. **Receiving a Call:**
   - The receiver sees an incoming call overlay
   - They can Accept or Decline
   - If accepted, they join the same Agora channel
   - Voice connection is established automatically

3. **During the Call:**
   - Both users can mute/unmute their microphone
   - Call duration is displayed
   - Either user can end the call
   - When one user leaves, the call ends for both

## Limitations & Notes

- **Free Tier Limits:** 10,000 minutes per month (plenty for most apps)
- **Testing Mode:** Currently configured for development (no token authentication)
- **Production:** For production apps, enable "Secured mode" in Agora Console and implement server-side token generation

## Troubleshooting

### App doesn't start after changes
- Click the "Hot Restart" button in Dreamflow Preview panel
- If that doesn't work, close and reopen the Preview

### Voice call button does nothing
- Make sure you've updated the App ID in `agora_service.dart`
- Check that microphone permissions are granted
- Verify your Agora project is in "Testing Mode"

### Call connects but no audio
- Ensure microphone permission is granted
- Check device volume is not muted
- Try the speaker button during the call

### "Failed to start call" error
- Verify your Agora App ID is correct
- Check your internet connection
- Ensure your Agora project is active (not suspended)

## Upgrading to Production

When ready for production:

1. Enable "Secured mode" in Agora Console
2. Set up a backend server to generate Agora tokens
3. Update `AgoraService.getToken()` to call your backend
4. Never expose your Agora App Certificate in client code

## Free Tier Details

Agora's free tier includes:
- ✅ 10,000 minutes of voice calling per month
- ✅ Unlimited users
- ✅ Worldwide coverage
- ✅ Technical support
- ✅ No credit card required

After 10,000 minutes, usage is charged at ~$0.99 per 1,000 minutes (very affordable).

## Support

For Agora-specific issues, check:
- [Agora Documentation](https://docs.agora.io)
- [Agora Community](https://www.agora.io/en/community/)
- [Flutter SDK Guide](https://docs.agora.io/en/voice-calling/get-started/get-started-sdk?platform=flutter)
