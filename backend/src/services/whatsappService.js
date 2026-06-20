// // backend/src/services/whatsappService.js
// // Route Mobile WhatsApp Business Platform Integration

// const axios = require('axios');

// const RM_BASE_URL = 'https://wbs.rmlconnect.net/wbinternals/api';
// const RM_USERNAME = process.env.ROUTEMOBILE_USERNAME;
// const RM_PASSWORD = process.env.ROUTEMOBILE_PASSWORD;
// const RM_SOURCE   = process.env.ROUTEMOBILE_SOURCE || '912162661502';
// const RM_WABA_ID  = process.env.ROUTEMOBILE_WABA_ID || '208515189002852';

// // ── Auth header ────────────────────────────────────────────────
// function getAuthHeader() {
//   const token = Buffer.from(`${RM_USERNAME}:${RM_PASSWORD}`).toString('base64');
//   return { Authorization: `Basic ${token}` };
// }

// // ── Send a simple text message ─────────────────────────────────
// async function sendTextMessage(toPhone, message) {
//   try {
//     // Clean phone number — remove + and spaces
//     const phone = String(toPhone).replace(/\D/g, '');

//     const payload = {
//       source:      RM_SOURCE,
//       destination: phone,
//       message: {
//         type: 'text',
//         text: { body: message }
//       }
//     };

//     const response = await axios.post(
//       `${RM_BASE_URL}/sendmsg`,
//       payload,
//       {
//         headers: {
//           ...getAuthHeader(),
//           'Content-Type': 'application/json',
//         },
//         timeout: 10000,
//       }
//     );

//     console.log(`✅ WhatsApp sent to ${phone}:`, response.data);
//     return { success: true, data: response.data };

//   } catch (err) {
//     console.error(`❌ WhatsApp send failed to ${toPhone}:`, err.message);
//     return { success: false, error: err.message };
//   }
// }

// // ── Send to multiple phones ────────────────────────────────────
// async function sendBulkMessages(phones, message) {
//   const results = [];
//   for (const phone of phones) {
//     const result = await sendTextMessage(phone, message);
//     results.push({ phone, ...result });
//     // Small delay to avoid rate limiting
//     await new Promise(r => setTimeout(r, 200));
//   }
//   return results;
// }

// // ── Send template message (for business-initiated) ────────────
// async function sendTemplateMessage(toPhone, templateName, params = []) {
//   try {
//     const phone = String(toPhone).replace(/\D/g, '');

//     const payload = {
//       source:      RM_SOURCE,
//       destination: phone,
//       message: {
//         type: 'template',
//         template: {
//           name:     templateName,
//           language: { code: 'en' },
//           components: params.length > 0 ? [{
//             type:       'body',
//             parameters: params.map(p => ({ type: 'text', text: p }))
//           }] : []
//         }
//       }
//     };

//     const response = await axios.post(
//       `${RM_BASE_URL}/sendmsg`,
//       payload,
//       {
//         headers: {
//           ...getAuthHeader(),
//           'Content-Type': 'application/json',
//         },
//         timeout: 10000,
//       }
//     );

//     return { success: true, data: response.data };

//   } catch (err) {
//     console.error(`❌ Template send failed:`, err.message);
//     return { success: false, error: err.message };
//   }
// }

// // ── Test connection ────────────────────────────────────────────
// async function testConnection() {
//   try {
//     const response = await axios.get(
//       `${RM_BASE_URL}/profile`,
//       {
//         headers: getAuthHeader(),
//         timeout: 5000,
//       }
//     );
//     return { success: true, data: response.data };
//   } catch (err) {
//     return { success: false, error: err.message };
//   }
// }

// module.exports = {
//   sendTextMessage,
//   sendBulkMessages,
//   sendTemplateMessage,
//   testConnection,
// };















// // backend/src/services/whatsappService.js
// // Route Mobile WhatsApp Business Platform Integration

// const axios = require('axios');
// const https  = require('https');

// // Ignore self-signed certificate from Route Mobile
// const agent = new https.Agent({ rejectUnauthorized: false });

// const RM_BASE_URL = 'https://wbs.rmlconnect.net/wbinternals/api';
// const RM_USERNAME = process.env.ROUTEMOBILE_USERNAME;
// const RM_PASSWORD = process.env.ROUTEMOBILE_PASSWORD;
// const RM_SOURCE   = process.env.ROUTEMOBILE_SOURCE || '912162661502';
// const RM_WABA_ID  = process.env.ROUTEMOBILE_WABA_ID || '208515189002852';

// // ── Auth header ────────────────────────────────────────────────
// function getAuthHeader() {
//   const token = Buffer.from(`${RM_USERNAME}:${RM_PASSWORD}`).toString('base64');
//   return { Authorization: `Basic ${token}` };
// }

// // ── Send a simple text message ─────────────────────────────────
// async function sendTextMessage(toPhone, message) {
//   try {
//     // Clean phone number — remove + and spaces
//     const phone = String(toPhone).replace(/\D/g, '');

//     const payload = {
//       source:      RM_SOURCE,
//       destination: phone,
//       message: {
//         type: 'text',
//         text: { body: message }
//       }
//     };

//     const response = await axios.post(
//       `${RM_BASE_URL}/sendmsg`,
//       payload,
//       {
//         headers: {
//           ...getAuthHeader(),
//           'Content-Type': 'application/json',
//         },
//         httpsAgent: agent,
//         timeout: 10000,
//       }
//     );

//     console.log(`✅ WhatsApp sent to ${phone}:`, response.data);
//     return { success: true, data: response.data };

//   } catch (err) {
//     console.error(`❌ WhatsApp send failed to ${toPhone}:`, err.message);
//     return { success: false, error: err.message };
//   }
// }

// // ── Send to multiple phones ────────────────────────────────────
// async function sendBulkMessages(phones, message) {
//   const results = [];
//   for (const phone of phones) {
//     const result = await sendTextMessage(phone, message);
//     results.push({ phone, ...result });
//     // Small delay to avoid rate limiting
//     await new Promise(r => setTimeout(r, 200));
//   }
//   return results;
// }

// // ── Send template message (for business-initiated) ────────────
// async function sendTemplateMessage(toPhone, templateName, params = []) {
//   try {
//     const phone = String(toPhone).replace(/\D/g, '');

//     const payload = {
//       source:      RM_SOURCE,
//       destination: phone,
//       message: {
//         type: 'template',
//         template: {
//           name:     templateName,
//           language: { code: 'en' },
//           components: params.length > 0 ? [{
//             type:       'body',
//             parameters: params.map(p => ({ type: 'text', text: p }))
//           }] : []
//         }
//       }
//     };

//     const response = await axios.post(
//       `${RM_BASE_URL}/sendmsg`,
//       payload,
//       {
//         headers: {
//           ...getAuthHeader(),
//           'Content-Type': 'application/json',
//         },
//         httpsAgent: agent,
//         timeout: 10000,
//       }
//     );

//     return { success: true, data: response.data };

//   } catch (err) {
//     console.error(`❌ Template send failed:`, err.message);
//     return { success: false, error: err.message };
//   }
// }

// // ── Test connection ────────────────────────────────────────────
// async function testConnection() {
//   try {
//     const response = await axios.get(
//       `${RM_BASE_URL}/profile`,
//       {
//         headers: getAuthHeader(),
//         httpsAgent: agent,
//         timeout: 5000,
//       }
//     );
//     return { success: true, data: response.data };
//   } catch (err) {
//     return { success: false, error: err.message };
//   }
// }

// module.exports = {
//   sendTextMessage,
//   sendBulkMessages,
//   sendTemplateMessage,
//   testConnection,
// };

























// backend/src/services/whatsappService.js
// Twilio WhatsApp Integration

const axios = require('axios');
const https = require('https');
const agent = new https.Agent({ rejectUnauthorized: false });

const TWILIO_ACCOUNT_SID = process.env.TWILIO_ACCOUNT_SID;
const TWILIO_AUTH_TOKEN  = process.env.TWILIO_AUTH_TOKEN;
const TWILIO_FROM        = process.env.TWILIO_WHATSAPP_FROM || 'whatsapp:+14155238886'; // Twilio sandbox number

// ── Send a text message via Twilio WhatsApp ────────────────────
async function sendTextMessage(toPhone, message) {
  try {
    const phone = String(toPhone).replace(/\D/g, '');
    const to    = `whatsapp:+${phone}`;

    const response = await axios.post(
      `https://api.twilio.com/2010-04-01/Accounts/${TWILIO_ACCOUNT_SID}/Messages.json`,
      new URLSearchParams({
        From: TWILIO_FROM,
        To:   to,
        Body: message,
      }),
      {
        auth: {
          username: TWILIO_ACCOUNT_SID,
          password: TWILIO_AUTH_TOKEN,
        },
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        httpsAgent: agent,
        timeout: 10000,
      }
    );

    console.log(`✅ WhatsApp sent to ${phone}:`, response.data.sid);
    return { success: true, sid: response.data.sid };

  } catch (err) {
    const errMsg = err.response?.data?.message || err.message;
    console.error(`❌ WhatsApp send failed to ${toPhone}:`, errMsg);
    return { success: false, error: errMsg };
  }
}

// ── Send to multiple phones ────────────────────────────────────
async function sendBulkMessages(phones, message) {
  const results = [];
  for (const phone of phones) {
    const result = await sendTextMessage(phone, message);
    results.push({ phone, ...result });
    await new Promise(r => setTimeout(r, 300));
  }
  return results;
}

// ── Test connection ────────────────────────────────────────────
async function testConnection() {
  try {
    const response = await axios.get(
      `https://api.twilio.com/2010-04-01/Accounts/${TWILIO_ACCOUNT_SID}.json`,
      {
        auth: {
          username: TWILIO_ACCOUNT_SID,
          password: TWILIO_AUTH_TOKEN,
        },
        httpsAgent: agent,
        timeout: 5000,
      }
    );
    return {
      success: true,
      account: response.data.friendly_name,
      status:  response.data.status,
    };
  } catch (err) {
    return { success: false, error: err.response?.data?.message || err.message };
  }
}

module.exports = { sendTextMessage, sendBulkMessages, testConnection };