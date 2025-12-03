const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");
const {SecretManagerServiceClient} = require("@google-cloud/secret-manager");

admin.initializeApp();

const secretManager = new SecretManagerServiceClient();

/**
 * Gets PawaPay API token from Secret Manager
 */
async function getPawaPayApiToken() {
  try {
    const projectId = process.env.GCLOUD_PROJECT || process.env.GCP_PROJECT;
    const [version] = await secretManager.accessSecretVersion({
      name: `projects/${projectId}/secrets/PAWAPAY_API_TOKEN/versions/latest`,
    });
    return version.payload.data.toString();
  } catch (error) {
    console.error("Error accessing PawaPay secret:", error.message);
    // Fallback to functions config if secret manager fails
    return functions.config().pawapay?.api_token || null;
  }
}

exports.onUserDeleted = functions.auth.user().onDelete(async (user) => {
  let firestore = admin.firestore();
  let userRef = firestore.doc("users/" + user.uid);
  await firestore.collection("users").doc(user.uid).delete();
});

// PawaPay Configuration
const PAWAPAY_BASE_URL = "https://api.pawapay.cloud";

// PawaPay supported correspondents by country
const PAWAPAY_CORRESPONDENTS = {
  // Benin
  BJ: {code: "MTN_MOMO_BEN", currency: "XOF", name: "Benin (MTN)"},
  // Burkina Faso
  BF: {code: "ORANGE_BFA", currency: "XOF", name: "Burkina Faso (Orange)"},
  // Cameroon
  CM_MTN: {code: "MTN_MOMO_CMR", currency: "XAF", name: "Cameroon (MTN)"},
  CM_ORANGE: {code: "ORANGE_CMR", currency: "XAF", name: "Cameroon (Orange)"},
  // Congo Brazzaville
  CG: {code: "MTN_MOMO_COG", currency: "XAF", name: "Congo Brazzaville (MTN)"},
  // Ivory Coast
  CI_MTN: {code: "MTN_MOMO_CIV", currency: "XOF", name: "Ivory Coast (MTN)"},
  CI_ORANGE: {code: "ORANGE_CIV", currency: "XOF", name: "Ivory Coast (Orange)"},
  CI_MOOV: {code: "MOOV_CIV", currency: "XOF", name: "Ivory Coast (Moov)"},
  CI_WAVE: {code: "WAVE_CIV", currency: "XOF", name: "Ivory Coast (Wave)"},
  // DRC
  CD_AIRTEL: {code: "AIRTEL_COD", currency: "USD", name: "DRC (Airtel)"},
  CD_ORANGE: {code: "ORANGE_COD", currency: "USD", name: "DRC (Orange)"},
  CD_VODACOM: {code: "VODACOM_COD", currency: "USD", name: "DRC (Vodacom)"},
  // Ghana
  GH_MTN: {code: "MTN_MOMO_GHA", currency: "GHS", name: "Ghana (MTN)"},
  GH_VODAFONE: {code: "VODAFONE_GHA", currency: "GHS", name: "Ghana (Vodafone)"},
  GH_AIRTELTIGO: {code: "AIRTELTIGO_GHA", currency: "GHS", name: "Ghana (AirtelTigo)"},
  // Guinea
  GN: {code: "MTN_MOMO_GIN", currency: "GNF", name: "Guinea (MTN)"},
  // Kenya
  KE: {code: "MPESA_KEN", currency: "KES", name: "Kenya (M-Pesa)"},
  // Malawi
  MW_TNM: {code: "TNM_MMALAWI", currency: "MWK", name: "Malawi (TNM)"},
  MW_AIRTEL: {code: "AIRTEL_MWI", currency: "MWK", name: "Malawi (Airtel)"},
  // Mozambique
  MZ_VODACOM: {code: "VODACOM_MOZ", currency: "MZN", name: "Mozambique (Vodacom)"},
  MZ_MPESA: {code: "MPESA_MOZ", currency: "MZN", name: "Mozambique (M-Pesa)"},
  // Nigeria
  NG: {code: "OPAY_NGR", currency: "NGN", name: "Nigeria (OPay)"},
  // Rwanda
  RW: {code: "MTN_MOMO_RWA", currency: "RWF", name: "Rwanda (MTN)"},
  // Senegal
  SN_ORANGE: {code: "ORANGE_SEN", currency: "XOF", name: "Senegal (Orange)"},
  SN_FREE: {code: "FREE_SEN", currency: "XOF", name: "Senegal (Free)"},
  SN_WAVE: {code: "WAVE_SEN", currency: "XOF", name: "Senegal (Wave)"},
  // Sierra Leone
  SL: {code: "ORANGE_SLE", currency: "SLE", name: "Sierra Leone (Orange)"},
  // Tanzania
  TZ_VODACOM: {code: "VODACOM_TZN", currency: "TZS", name: "Tanzania (Vodacom)"},
  TZ_AIRTEL: {code: "AIRTEL_TZN", currency: "TZS", name: "Tanzania (Airtel)"},
  TZ_TIGO: {code: "TIGO_TZN", currency: "TZS", name: "Tanzania (Tigo)"},
  TZ_HALOTEL: {code: "HALOTEL_TZN", currency: "TZS", name: "Tanzania (Halotel)"},
  // Uganda
  UG_MTN: {code: "MTN_MOMO_UGA", currency: "UGX", name: "Uganda (MTN)"},
  UG_AIRTEL: {code: "AIRTEL_UGA", currency: "UGX", name: "Uganda (Airtel)"},
  // Zambia
  ZM_MTN: {code: "MTN_MOMO_ZMB", currency: "ZMW", name: "Zambia (MTN)"},
  ZM_AIRTEL: {code: "AIRTEL_ZMB", currency: "ZMW", name: "Zambia (Airtel)"},
  // Zimbabwe
  ZW: {code: "ECOCASH_ZWE", currency: "ZWG", name: "Zimbabwe (EcoCash)"},
};

// Base plan amounts in USD (will be converted per currency)
const PLAN_AMOUNTS_USD = {
  Daily: 1.20,
  Weekly: 8.00,
  Yearly: 15.00,
  Gold: 50.00,
};

// Approximate exchange rates from USD (updated periodically)
const EXCHANGE_RATES = {
  USD: 1,
  MWK: 1700,
  KES: 155,
  GHS: 15,
  NGN: 1500,
  TZS: 2700,
  UGX: 3800,
  ZMW: 27,
  ZWG: 14,
  RWF: 1300,
  XOF: 610,
  XAF: 610,
  GNF: 8600,
  MZN: 64,
  SLE: 22,
};

/**
 * Converts USD amount to local currency
 */
function convertToLocalCurrency(usdAmount, currency) {
  const rate = EXCHANGE_RATES[currency] || 1;
  return Math.round(usdAmount * rate);
}

/**
 * Initiates a PawaPay deposit
 */
exports.initiatePawaPayDeposit = functions.https.onCall(
  async (data, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "User must be authenticated"
      );
    }

    const {planTitle, phoneNumber, depositId, correspondentKey} = data;

    if (!planTitle || !phoneNumber || !depositId || !correspondentKey) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Missing required fields"
      );
    }

    const correspondent = PAWAPAY_CORRESPONDENTS[correspondentKey];
    if (!correspondent) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Invalid country/provider selected"
      );
    }

    const usdAmount = PLAN_AMOUNTS_USD[planTitle];
    if (!usdAmount) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Invalid plan selected"
      );
    }

    const localAmount = convertToLocalCurrency(usdAmount, correspondent.currency);

    // Get API token from Secret Manager
    const apiToken = await getPawaPayApiToken();
    if (!apiToken) {
      throw new functions.https.HttpsError(
        "internal",
        "Payment service configuration error"
      );
    }

    try {
      const response = await axios.post(
        `${PAWAPAY_BASE_URL}/deposits`,
        {
          depositId: depositId,
          amount: localAmount.toString(),
          currency: correspondent.currency,
          correspondent: correspondent.code,
          payer: {
            type: "MSISDN",
            address: {
              value: phoneNumber,
            },
          },
          customerTimestamp: new Date().toISOString(),
          statementDescription: `Vuka265 ${planTitle} Subscription`,
        },
        {
          headers: {
            Authorization: `Bearer ${apiToken}`,
            "Content-Type": "application/json",
            Accept: "application/json",
          },
          timeout: 30000,
        }
      );

      await admin
        .firestore()
        .collection("payment_transactions")
        .doc(depositId)
        .set({
          userId: context.auth.uid,
          depositId: depositId,
          planTitle: planTitle,
          amount: localAmount,
          currency: correspondent.currency,
          correspondentKey: correspondentKey,
          correspondent: correspondent.code,
          phoneNumber: phoneNumber,
          status: response.data.status || "PENDING",
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });

      return {
        success: true,
        depositId: response.data.depositId,
        status: response.data.status,
        amount: localAmount,
        currency: correspondent.currency,
        data: response.data,
      };
    } catch (error) {
      console.error(
        "PawaPay deposit error:",
        error.response?.data || error.message
      );

      throw new functions.https.HttpsError(
        "internal",
        error.response?.data?.message || "Payment initiation failed",
        {details: error.response?.data}
      );
    }
  }
);

/**
 * Checks the status of a PawaPay deposit
 */
exports.checkPawaPayDepositStatus = functions.https.onCall(
  async (data, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "User must be authenticated"
      );
    }

    const {depositId} = data;

    if (!depositId) {
      throw new functions.https.HttpsError("invalid-argument", "Missing depositId");
    }

    // Get API token from Secret Manager
    const apiToken = await getPawaPayApiToken();
    if (!apiToken) {
      throw new functions.https.HttpsError(
        "internal",
        "Payment service configuration error"
      );
    }

    try {
      const response = await axios.get(
        `${PAWAPAY_BASE_URL}/deposits/${depositId}`,
        {
          headers: {
            Authorization: `Bearer ${apiToken}`,
            "Content-Type": "application/json",
            Accept: "application/json",
          },
          timeout: 15000,
        }
      );

      const transactionRef = admin
        .firestore()
        .collection("payment_transactions")
        .doc(depositId);
      const transactionDoc = await transactionRef.get();

      if (transactionDoc.exists) {
        await transactionRef.update({
          status: response.data.status,
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
          responseData: response.data,
        });

        if (
          response.data.status === "COMPLETED" ||
          response.data.status === "ACCEPTED"
        ) {
          const transaction = transactionDoc.data();
          await updateUserSubscription(context.auth.uid, transaction.planTitle);
        }
      }

      return {
        success: true,
        status: response.data.status,
        data: response.data,
      };
    } catch (error) {
      console.error(
        "PawaPay status check error:",
        error.response?.data || error.message
      );

      throw new functions.https.HttpsError("internal", "Status check failed", {
        details: error.response?.data,
      });
    }
  }
);

/**
 * Sends push notification when a new message is created
 */
exports.onNewMessage = functions.firestore
  .document("chats/{chatId}/messages/{messageId}")
  .onCreate(async (snapshot, context) => {
    const messageData = snapshot.data();
    const chatId = context.params.chatId;

    // Skip if no sender or it's a system message
    if (!messageData.senderId) {
      console.log("No senderId, skipping notification");
      return null;
    }

    try {
      // Get the chat document to find all participants
      const chatDoc = await admin
        .firestore()
        .collection("chats")
        .doc(chatId)
        .get();

      if (!chatDoc.exists) {
        console.log("Chat document not found");
        return null;
      }

      const chatData = chatDoc.data();
      const userIDs = chatData.userIDs || [];

      // Find recipients (everyone except the sender)
      const senderRef = messageData.senderId;
      const senderPath = typeof senderRef === "string" ? senderRef : senderRef.path;

      const recipientPromises = userIDs
        .filter((userRef) => {
          const userPath = typeof userRef === "string" ? userRef : userRef.path;
          return userPath !== senderPath;
        })
        .map(async (userRef) => {
          const userPath = typeof userRef === "string" ? userRef : userRef.path;
          const userId = userPath.split("/").pop();
          const userDoc = await admin
            .firestore()
            .collection("users")
            .doc(userId)
            .get();

          if (!userDoc.exists) return null;

          const userData = userDoc.data();

          // Check if user wants to receive direct messages
          if (userData.receiveDirectMessages === false) {
            console.log(`User ${userId} has disabled direct messages`);
            return null;
          }

          // Get FCM token
          const fcmToken = userData.fcmToken;
          if (!fcmToken) {
            console.log(`No FCM token for user ${userId}`);
            return null;
          }

          return {
            userId,
            fcmToken,
            displayName: userData.display_name || "User",
          };
        });

      const recipients = (await Promise.all(recipientPromises)).filter(Boolean);

      if (recipients.length === 0) {
        console.log("No valid recipients found");
        return null;
      }

      // Prepare notification content
      const senderName = messageData.senderName || "Someone";
      let notificationBody = messageData.messageText || "Sent you a message";

      // Customize based on message type
      const messageType = messageData.messageType;
      if (messageType === "image") {
        notificationBody = "Sent you a photo";
      } else if (messageType === "audio") {
        notificationBody = "Sent you a voice message";
      } else if (messageType === "video") {
        notificationBody = "Sent you a video";
      } else if (messageType === "document" || messageType === "file") {
        notificationBody = "Sent you a document";
      } else if (messageType === "voice_call") {
        notificationBody = "Started a voice call";
      }

      // Truncate long messages
      if (notificationBody.length > 100) {
        notificationBody = notificationBody.substring(0, 97) + "...";
      }

      // Send notifications to all recipients
      const sendPromises = recipients.map(async (recipient) => {
        const message = {
          token: recipient.fcmToken,
          notification: {
            title: `New message from ${senderName}`,
            body: notificationBody,
          },
          data: {
            type: "new_message",
            chatId: chatId,
            senderId: senderPath,
            senderName: senderName,
            messageType: messageType || "text",
            click_action: "FLUTTER_NOTIFICATION_CLICK",
          },
          android: {
            priority: "high",
            notification: {
              channelId: "messages",
              priority: "high",
              defaultSound: true,
              defaultVibrateTimings: true,
            },
          },
          apns: {
            payload: {
              aps: {
                alert: {
                  title: `New message from ${senderName}`,
                  body: notificationBody,
                },
                badge: 1,
                sound: "default",
              },
            },
          },
        };

        try {
          const response = await admin.messaging().send(message);
          console.log(`Notification sent to ${recipient.userId}: ${response}`);
          return {success: true, userId: recipient.userId};
        } catch (error) {
          console.error(
            `Failed to send notification to ${recipient.userId}:`,
            error
          );

          // If token is invalid, remove it from user's document
          if (
            error.code === "messaging/invalid-registration-token" ||
            error.code === "messaging/registration-token-not-registered"
          ) {
            await admin
              .firestore()
              .collection("users")
              .doc(recipient.userId)
              .update({
                fcmToken: admin.firestore.FieldValue.delete(),
              });
            console.log(`Removed invalid FCM token for user ${recipient.userId}`);
          }

          return {success: false, userId: recipient.userId, error: error.message};
        }
      });

      const results = await Promise.all(sendPromises);
      console.log("Notification results:", results);

      return results;
    } catch (error) {
      console.error("Error sending push notification:", error);
      return null;
    }
  });

async function updateUserSubscription(userId, planTitle) {
  const subscriptionData = {
    plan: planTitle,
    status: "active",
    startDate: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  };

  const now = new Date();
  switch (planTitle) {
    case "Daily":
      subscriptionData.endDate = new Date(
        now.getTime() + 24 * 60 * 60 * 1000
      );
      break;
    case "Weekly":
      subscriptionData.endDate = new Date(
        now.getTime() + 7 * 24 * 60 * 60 * 1000
      );
      break;
    case "Yearly":
      subscriptionData.endDate = new Date(
        now.getTime() + 365 * 24 * 60 * 60 * 1000
      );
      break;
    case "Gold":
      subscriptionData.endDate = null;
      subscriptionData.isLifetime = true;
      break;
  }

  await admin
    .firestore()
    .collection("subscriptions")
    .doc(userId)
    .set(subscriptionData, {merge: true});
}

/**
 * Returns the list of supported PawaPay correspondents with pricing
 */
exports.getPawaPayCorrespondents = functions.https.onCall(
  async (data, context) => {
    const {planTitle} = data || {};

    // Build response with all correspondents
    const correspondents = Object.entries(PAWAPAY_CORRESPONDENTS).map(
      ([key, value]) => {
        const result = {
          key: key,
          code: value.code,
          currency: value.currency,
          name: value.name,
        };

        // If planTitle provided, include the local price
        if (planTitle && PLAN_AMOUNTS_USD[planTitle]) {
          result.amount = convertToLocalCurrency(
            PLAN_AMOUNTS_USD[planTitle],
            value.currency
          );
        }

        return result;
      }
    );

    return {
      success: true,
      correspondents: correspondents,
      planAmountsUSD: PLAN_AMOUNTS_USD,
    };
  }
);
