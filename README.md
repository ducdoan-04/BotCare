# CareBot 🏥

CareBot is a comprehensive and smart medical management system built with Flutter. It streamlines day-to-day healthcare operations with a modern interface, providing powerful tools to manage and track doctors, patients, appointments, and multi-platform integrations effectively.

---

## ✨ Features

*   **Dashboard & Analytics**: Intuitive overview of daily operations including total doctors, active appointments, and patient recovery ratios with interactive visual charts (using `fl_chart`).
*   **Patient Management**: Complete record system displaying basic info, conditions, last visits, and easy-to-use search and filtering options.
*   **Appointment Tracking**: A dedicated module tracking all upcoming and completed medical appointments with full visibility, detailed action sheets, and integrated calendar features.
*   **Smart Settings Suite**:
    *   **Appearance**: Easily switch between Light and Dark mode, toggle custom app theme colors, and specify localization languages and regions.
    *   **Account Settings**: Secure center for 2-step verifications, email configurations, avatar changes, and data access.
    *   **Notifications**: Comprehensive toggles for Email, In-app warnings, chat messages, and appointment alerts.
    *   **API & Integrations**: Integration panel linking services like Google Calendar, Slack, and Zapier for extended healthcare automations.
*   **UI/UX**: Refined, responsive Pixel-Perfect design inspired by modern styling, making use of `Cupertino` & `Material` aesthetics with consistent tokens.

---

## 🛠️ Built With

*   **Framework:** [Flutter](https://flutter.dev/) (Dart) 
*   **Charts:** `fl_chart`
*   **Architecture:** Stateful Widgets & modular UI component design.

---

## 📂 Project Structure

```text
lib/
├── screens/                  # Main UI Screens
│   ├── dashboard_screen.dart # Main Analytics UI
│   ├── patients_screen.dart  # Patient Records
│   ├── appointments_screen.dart # Medical Schedules
│   ├── settings_screen.dart  # Detailed Setting Menus
│   └── ... 
├── theme/                    # App Branding
│   └── app_colors.dart       # Core Color references
├── main.dart                 # Application Entry Point
```

---

## 🚀 Getting Started

### Prerequisites
Make sure you have installed:
*   [Flutter SDK](https://docs.flutter.dev/get-started/install) 
*   An IDE like VS Code or Android Studio
*   For running in a web environment, ensure your Flutter is web enabled.

### Installation & Run

1.  **Clone the repository** (or navigate to the project directory):
    ```bash
    cd CareBot
    ```

2.  **Get dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Run the App**:
    You can run it on your mobile simulator or right on a web server:
    ```bash
    # Run on Chrome/Web Sandbox:
    flutter run -d web-server --web-hostname 192.168.x.x --web-port 8080 
    
    # Or deploy normally to connected device:
    flutter run
    ```

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check out the issues page if you want to contribute.

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.
