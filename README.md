# 🎣 CatchThePhish

CatchThePhish is a Google Chrome Extension that helps users identify potential phishing emails using machine learning. Built with Material Design 3 and powered by Hugging Face's state-of-the-art AI model, this app provides real-time analysis of email content to protect users from phishing attempts.

![CatchThePhish Demo](catchthephish_demo.gif)

## ✨ Features

- 🔍 Real-time phishing detection
- 🌊 Cute wave animation and fish themed interface
- 🎨 Modern Material Design 3 UI
- 🤖 Powered by DistilBERT AI model
- 📱 Cross-platform support (iOS, Android, Web)
- 🔒 Privacy-focused (email content processed securely)

## 🚀 Getting Started

### Prerequisites

- Flutter (latest version)
- Dart SDK
- An IDE (VS Code, Android Studio, or IntelliJ)
- A Hugging Face API token

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/catch-the-phish.git
cd catch-the-phish
```

2. Install dependencies:
```bash
flutter pub get
```

3. Create a `.env` file in the root directory and add your Hugging Face API token:
```
HF_API_TOKEN=your_token_here
```

4. Run the app:
```bash
flutter run
```

## 🛠️ Dependencies

- `wave`: ^0.2.2
- `google_fonts`: ^5.1.0
- `flutter_svg`: ^2.0.7
- `http`: ^1.1.0

## 🎯 How It Works

1. Users paste their suspicious email content into the app
2. The app sends the content to a fine-tuned DistilBERT model
3. AI analysis is performed to detect phishing patterns
4. Results are displayed with clear recommendations
5. Users get instant feedback on whether the email is safe or suspicious

## 🔒 Privacy & Security

- No email content is stored
- All analysis is performed in real-time
- Secure API communication
- No personal data collection

## 🙏 Acknowledgments

- [cybersectony](https://huggingface.co/cybersectony) for the phishing detection model
- icons8 for all the fish icons
- The Flutter team for the amazing framework
- The Hugging Face team for their AI infrastructure
- All contributors who help improve this project

## 📧 Contact

Project Link: [https://github.com/yourusername/catch-the-phish](https://github.com/yourusername/catch-the-phish)

---
Made with ❤️ by Pixory Team
