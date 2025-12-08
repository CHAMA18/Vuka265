# Vuka265

A dating app for African users with mobile money and card payment support.

## Getting Started

FlutterFlow projects are built to run on the Flutter _stable_ release.

---

## Payment Integration Setup

The app uses **PawaPay** for Mobile Money payments, supporting 25+ African countries.

### PawaPay Setup

PawaPay supports the following countries and providers:

| Country | Providers |
|---------|-----------|
| Benin | MTN |
| Burkina Faso | Orange |
| Cameroon | MTN, Orange |
| Congo Brazzaville | MTN |
| Ivory Coast | MTN, Orange, Moov, Wave |
| DRC | Airtel, Orange, Vodacom |
| Ghana | MTN, Vodafone, AirtelTigo |
| Guinea | MTN |
| Kenya | M-Pesa |
| Malawi | TNM, Airtel |
| Mozambique | Vodacom, M-Pesa |
| Nigeria | OPay |
| Rwanda | MTN |
| Senegal | Orange, Free, Wave |
| Sierra Leone | Orange |
| Tanzania | Vodacom, Airtel, Tigo, Halotel |
| Uganda | MTN, Airtel |
| Zambia | MTN, Airtel |
| Zimbabwe | EcoCash |

#### Step 1: Get PawaPay API Credentials

1. Sign up at [PawaPay Dashboard](https://dashboard.pawapay.cloud)
2. Complete business verification
3. Get your API token from the dashboard

#### Step 2: Store API Token in Google Cloud Secret Manager

```bash
# Enable Secret Manager API
gcloud services enable secretmanager.googleapis.com

# Create the secret
echo -n "YOUR_PAWAPAY_API_TOKEN" | gcloud secrets create PAWAPAY_API_TOKEN --data-file=-

# Grant Cloud Functions access
gcloud secrets add-iam-policy-binding PAWAPAY_API_TOKEN \
  --member="serviceAccount:YOUR_PROJECT_ID@appspot.gserviceaccount.com" \
  --role="roles/secretmanager.secretAccessor"
```

#### Step 3: Deploy Cloud Functions

```bash
cd firebase/functions
npm install
firebase deploy --only functions
```

### Deploy Firestore Security Rules

```bash
firebase deploy --only firestore:rules
```

---

## Push Notifications Setup

Push notifications are sent when users receive new direct messages.

### Firebase Cloud Messaging (FCM)

1. FCM is already configured in the Cloud Functions
2. The app automatically registers FCM tokens on user login
3. Notifications are sent via the `onNewMessage` Cloud Function

### Required Permissions

**Android** (`android/app/src/main/AndroidManifest.xml`):
- `POST_NOTIFICATIONS` (Android 13+)

**iOS** (`ios/Runner/Info.plist`):
- Push notification capability enabled in Xcode

---

## Architecture Overview

```
lib/
├── auth/                    # Firebase authentication
├── backend/                 # Firebase/Firestore schemas
├── chats/                   # Chat screens and components
├── home/                    # Home screen, swiper, filters
├── matches/                 # Matches list and user profiles
├── profile/                 # User profile screens
├── register/                # Sign up and onboarding
├── services/                # Business logic services
│   ├── pawapay_service.dart # PawaPay API calls
│   └── push_notification_service.dart
├── settings/                # Settings screens
│   ├── subscription/        # Subscription plans
│   └── pawapay_payment_dialog/ # Payment UI
└── flutter_flow/            # UI utilities and theme

firebase/
├── functions/
│   └── index.js            # Cloud Functions (payments, notifications)
└── firestore.rules         # Security rules
```

---

## Environment Variables

| Variable | Description | Where to Set |
|----------|-------------|--------------|
| `PAWAPAY_API_TOKEN` | PawaPay API token | Google Secret Manager |

---

## Testing Payments

### PawaPay Sandbox
- Use PawaPay sandbox credentials for testing
- Test phone numbers are provided in PawaPay docs

---

## PawaPay Secret Setup (Quick Guide)

The Cloud Functions are configured to use **Google Cloud Secret Manager** to securely store the PawaPay API token.

### Option 1: Google Cloud Console (Easiest)

1. Go to [Google Cloud Console - Secret Manager](https://console.cloud.google.com/security/secret-manager)
2. Select your Firebase project
3. Click **"Create Secret"**
4. Set the name to: `PAWAPAY_API_TOKEN`
5. Paste your PawaPay API token as the secret value
6. Click **"Create"**

Then grant access to Cloud Functions:
1. Click on the secret `PAWAPAY_API_TOKEN`
2. Go to **"Permissions"** tab
3. Click **"Grant Access"**
4. Add principal: `YOUR_PROJECT_ID@appspot.gserviceaccount.com`
5. Select role: **"Secret Manager Secret Accessor"**
6. Save

### Option 2: Firebase Functions Config (Alternative)

If Secret Manager isn't available, you can use Firebase Functions config:

```bash
firebase functions:config:set pawapay.api_token="YOUR_PAWAPAY_API_TOKEN"
firebase deploy --only functions
```

### After Setup

1. **Regenerate your PawaPay API token** from the PawaPay dashboard (if it was exposed)
2. Deploy the Cloud Functions: `firebase deploy --only functions`
3. Test a payment in the app
