// ============================================================
// Simple Rule-Based NLP Service
// Handles keyword matching for learner questions via WhatsApp
// Replace with Python AI service or OpenAI API for production
// ============================================================

const NLP_KNOWLEDGE_BASE = [
  {
    keywords: ['internet', 'what is internet', 'define internet'],
    answer: '🌐 *The Internet* is a global network of interconnected computers that communicate using standardized protocols. It allows sharing of information, communication, and access to resources worldwide.\n\n📌 Key uses: Email, browsing websites, online learning, social media.',
  },
  {
    keywords: ['cloud computing', 'cloud', 'what is cloud'],
    answer: '☁️ *Cloud Computing* is the delivery of computing services (servers, storage, databases, software) over the internet ("the cloud").\n\n📌 Examples: Google Drive, Dropbox, Gmail — your files are stored on remote servers, not just your device.',
  },
  {
    keywords: ['digital literacy', 'digital skills', 'digital'],
    answer: '💻 *Digital Literacy* is the ability to use digital tools, internet, and technology effectively and safely.\n\n📌 Key skills: Using computers/smartphones, online communication, finding reliable information, staying safe online.',
  },
  {
    keywords: ['computer', 'what is computer', 'basic computer'],
    answer: '🖥️ A *Computer* is an electronic device that processes data and performs tasks based on instructions (programs).\n\n📌 Main parts: CPU (brain), Memory (RAM), Storage (Hard Drive), Input (keyboard/mouse), Output (screen/printer).',
  },
  {
    keywords: ['email', 'what is email', 'electronic mail'],
    answer: '📧 *Email* (Electronic Mail) is a method of sending messages digitally over the internet.\n\n📌 How to use: Create account (Gmail, Yahoo), compose message, enter recipient address, click Send.',
  },
  {
    keywords: ['password', 'strong password', 'security'],
    answer: '🔐 A *Strong Password* protects your online accounts.\n\n📌 Tips:\n• Use 8+ characters\n• Mix uppercase, lowercase, numbers, symbols\n• Never share your password\n• Use different passwords for different accounts',
  },
  {
    keywords: ['browser', 'web browser', 'chrome', 'firefox'],
    answer: '🌍 A *Web Browser* is software that lets you access websites on the internet.\n\n📌 Popular browsers: Chrome, Firefox, Safari, Edge\n\nTo visit a website, type the web address (URL) in the address bar.',
  },
  {
    keywords: ['social media', 'facebook', 'whatsapp', 'social network'],
    answer: '📱 *Social Media* are online platforms that allow people to connect, share content, and communicate.\n\n📌 Examples: Facebook, WhatsApp, Instagram, Twitter/X\n\n⚠️ Tip: Be careful what personal information you share online.',
  },
  {
    keywords: ['virus', 'malware', 'cyber', 'hacking', 'phishing'],
    answer: '🛡️ *Cybersecurity* is protecting your devices and data from digital attacks.\n\n📌 Common threats:\n• Viruses: Harmful programs\n• Phishing: Fake emails stealing info\n• Malware: Software that damages your device\n\n✅ Stay safe: Use antivirus, don\'t click unknown links.',
  },
  {
    keywords: ['wifi', 'wi-fi', 'wireless', 'network'],
    answer: '📶 *Wi-Fi* is wireless technology that allows devices to connect to the internet without cables.\n\n📌 Tips:\n• Use strong Wi-Fi passwords\n• Avoid using public Wi-Fi for banking\n• Your router needs to be connected to your ISP for internet access.',
  },
  {
    keywords: ['search engine', 'google', 'how to search'],
    answer: '🔍 A *Search Engine* helps you find information on the internet.\n\n📌 How to use Google:\n1. Go to google.com\n2. Type your question or keywords\n3. Click Search\n4. Choose from the results shown\n\n💡 Tip: Use specific words for better results.',
  },
  {
    keywords: ['smartphone', 'mobile phone', 'android', 'iphone'],
    answer: '📱 A *Smartphone* is a mobile phone with advanced features like internet access, apps, and camera.\n\n📌 Common uses in adult learning:\n• Watch video lessons\n• Take quizzes via WhatsApp\n• Access learning materials\n• Communicate with facilitators',
  },
];

/**
 * Process a learner question and return an NLP answer
 * @param {string} text - The message from the learner
 * @returns {string|null} - Answer or null if no match
 */
function processNLPQuery(text) {
  const lowerText = text.toLowerCase().trim();

  for (const entry of NLP_KNOWLEDGE_BASE) {
    for (const keyword of entry.keywords) {
      if (lowerText.includes(keyword)) {
        return entry.answer;
      }
    }
  }
  return null;
}

/**
 * Check if a message looks like a question / NLP query
 */
function isQuestion(text) {
  const lower = text.toLowerCase();
  return (
    lower.startsWith('what') ||
    lower.startsWith('how') ||
    lower.startsWith('why') ||
    lower.startsWith('when') ||
    lower.startsWith('who') ||
    lower.startsWith('define') ||
    lower.startsWith('explain') ||
    lower.startsWith('tell me') ||
    lower.includes('?')
  );
}

module.exports = { processNLPQuery, isQuestion, NLP_KNOWLEDGE_BASE };
