# 🎭 DailyMood

![Flutter](https://img.shields.io/badge/Flutter-3.7.2+-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![SQflite](https://img.shields.io/badge/SQLite-Local_Storage-003B57?style=for-the-badge&logo=sqlite&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-iOS%20|%20Android%20|%20Web%20|%20Desktop-lightgrey?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)

**DailyMood** est une application de journal émotionnel multiplateforme développée avec Flutter. Elle permet aux utilisateurs de suivre leur état d'esprit quotidien, d'ajouter des notes contextuelles et de recevoir des conseils personnalisés, le tout stocké localement pour une confidentialité totale.

##  Fonctionnalités Clés

* **📝 Journaling Émotionnel :** Sélection intuitive d'humeurs via emojis (😄, 😐, 😢, 😠, 😍).
* **💾 Persistance Locale :** Toutes les données sont stockées sur l'appareil via **SQLite** (aucune donnée ne part dans le cloud).
* **💡 Feedback Intelligent :** Conseils contextuels affichés immédiatement après l'enregistrement d'une humeur.
* **🎲 Inspiration :** Générateur de citations positives aléatoires à chaque ouverture.
* **🌍 Internationalisation :** Support natif configuré pour le Français (FR) et l'Anglais (EN).

## 🛠️ Stack Technique

* **Framework :** Flutter (SDK ^3.7.2)
* **Langage :** Dart
* **Base de données :** `sqflite` (v2.3.0) + `path`
* **Architecture :** Stateful Widget Pattern (Logique intégrée)
* **Design System :** Material Design 3 (Thème `Teal`)

## 📂 Structure du Projet

```text
DailyMood/
├── android/            # Configuration native Android (Gradle, Kotlin)
├── ios/                # Configuration native iOS (Runner, Info.plist)
├── lib/
│   └── main.dart       # Point d'entrée, UI, Logique DB et Navigation
├── web/                # Configuration PWA
├── windows/            # Configuration Win32 (CMake, C++)
├── linux/              # Configuration GTK (CMake, C++)
├── macos/              # Configuration Cocoa (Swift)
└── pubspec.yaml        # Gestion des dépendances

🔧 Installation & Démarrage
Prérequis

    Flutter SDK installé

    Android Studio / Xcode / VS Code

1. Cloner le dépôt
Bash

git clone [https://github.com/Ramzi-su/DailyMood.git](https://github.com/Ramzi-su/DailyMood.git)
cd DailyMood

2. Installer les dépendances
Bash

flutter pub get

3. Lancer l'application
Bash

# Pour lancer en mode debug (choisir un device connecté)
flutter run

# Pour nettoyer le build si nécessaire
flutter clean && flutter pub get

📱 Aperçu du Code (Logique Base de Données)

Le projet utilise une table SQL simple pour la persistance :
SQL

CREATE TABLE moods(
    id INTEGER PRIMARY KEY,
    date TEXT,
    mood TEXT,
    note TEXT
)

🤝 Contribuer

Les contributions sont les bienvenues !

    Forkez le projet.

    Créez votre branche de fonctionnalité (git checkout -b feature/AmazingFeature).

    Commitez vos changements (git commit -m 'Add some AmazingFeature').

    Pushez sur la branche (git push origin feature/AmazingFeature).

    Ouvrez une Pull Request.

📄 Licence

Ce projet est distribué sous licence MIT. Voir le fichier LICENSE pour plus d'informations.
