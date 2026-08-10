# 🛒 Mobile POS & Billing App 

A feature-rich, high-performance offline-first billing and Point of Sale (POS) application built with Flutter. Designed for seamless retail checkout operations featuring barcode scanning, thermal Bluetooth printing, and robust local data persistence.

## Screenshot


https://github.com/user-attachments/assets/f2d16454-5408-43b3-b207-cd843bbc2c9e



## 🎯 Project Scope

This application serves as a complete offline POS system for small to medium-sized retail shops. It streamlines the checkout process, catalog management, and receipt generation securely entirely on-device.

### Core Features:
- **Product Management System**: Complete CRUD operations for inventory items with barcode/QR code support.
- **Smart Checkout System**: Rapid cart building via camera-based barcode scanning or manual entry, and robust order calculation functionality.
- **Bluetooth Thermal Printing**: Direct integration with thermal printers (`print_bluetooth_thermal`) to instantly output physical receipts.
- **Shop Settings & Customization**: Centrally managed shop details printed dynamically on receipts.
- **Offline-First Architecture**: Powered by `Hive` for lightning-fast localized NoSQL data storage. No active internet connectivity required.

## 🛠 Tech Stack & Architecture

Built leveraging industry-standard architectural principles (Clean Architecture & Feature-Driven Design) ensuring scalability, separation of concerns, and robust testability. 

- **Framework**: [Flutter](https://flutter.dev/) (SDK >=3.1.0)
- **State Management**: `flutter_bloc`
- **Dependency Injection**: `get_it`
- **Routing**: `go_router`
- **Local Database**: `hive` & `hive_flutter`
- **Data Modeling**: `json_serializable`, `equatable`
- **Functional Programming**: `fpdart`
- **Hardware Integrations**: `mobile_scanner` (barcodes), `print_bluetooth_thermal`

## 📁 File Structure

The codebase is organized using a **Feature-First Clean Architecture** utilizing domain-driven concepts.

```text
lib/
├── core/                       # Core application utilities and shared components
│   ├── data/                   # Global data sources (e.g., Hive initialization)
│   ├── error/                  # Standardized Failure/Exception models (fpdart compatible)
│   ├── theme/                  # UI aesthetics, typography, styling
│   ├── usecase/                # Base UseCase contracts
│   ├── utils/                  # Helpers (e.g., PrinterHelper, formatters)
│   ├── widgets/                # Reusable global UI widgets (AppBars, generic buttons)
│   └── service_locator.dart    # get_it dependency injection setup
│
└── features/                   # Independent feature modules
    ├── billing/                # Core POS operations: Cart, Checkout, Invoice Generation
    ├── product/                # Inventory management: Adding, Listing, Scanning products
    ├── settings/               # App configuration: Printer connections, App settings
    └── shop/                   # Shop details configuration
```

*Note: Each feature is further subdivided internally into Clean Architecture layers: `data`, `domain`, and `presentation`.*

## 💡 Use Cases

- **Rapid Billing Entry**: A cashier launches the app, navigates to the checkout page, and uses the device camera to instantly scan product barcodes. The products are added to the cart, the total is calculated including taxes, and a receipt is finalized.
- **Physical Receipt Generation**: After checkout confirmation, the app triggers a connected external Bluetooth thermal POS printer to instantly print an itemized paper receipt with the shop’s header.
- **Inventory Sideloading**: A manager opens the Product feature to add new stock to the local database, taking a picture of the barcode to bind the SKU for future lightning-fast checkouts.
- **No-Connection Operation**: The business operates a stall at an exhibition with poor networking. The app functions entirely via its embedded Hive local database and Bluetooth, completely undisturbed by network drops.

## 🚀 Getting Started

### Prerequisites
- Flutter SDK `^3.1.0` or higher
- Android Studio / Xcode for emulators and building.
- *Optional*: A physical Android/iOS device and a Bluetooth Thermal Printer for testing hardware integrations natively.

### Installation

1. Clone the repository and navigate to the project directory:
   ```bash
   git clone <repository_url>
   cd billing_app
   ```

2. Fetch dependencies:
   ```bash
   flutter pub get
   ```

3. Run code generation (required for Hive adapters and JSON serialization):
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. Run the project:
   ```bash
   flutter run
   ```

## 🌍 Languages & Currency

This build adds full trilingual support and Algerian Dinar pricing on top of the original app:

- **Languages**: Arabic (default, full RTL), French, and English — switchable anytime from **Settings → Language**, and the choice is remembered (saved in Hive) between app launches.
- **Currency**: All prices are now formatted as **Algerian Dinar (DZD)** — shown as `د.ج` in Arabic and `DA` in French/English, with locale-aware number formatting.
- Translations live in `lib/l10n/app_en.arb`, `app_ar.arb`, and `app_fr.arb`. Flutter's official `gen-l10n` tool generates the `AppLocalizations` class from these at build time — no extra packages beyond `flutter_localizations` (already added to `pubspec.yaml`).

To add or tweak text, edit the `.arb` files and run:
```bash
flutter gen-l10n
```

## ☁️ Deploying a preview to Vercel

This is a Flutter **mobile** app, so to preview it on Vercel it's built for the **web** target. Vercel's build servers (unlike some sandboxed environments) have full internet access, so the included `vercel_build.sh` script downloads the Flutter SDK during the build itself — you don't need Flutter installed locally.

**Option A — one-click via Vercel dashboard (recommended, proven to work):**
1. Push this project to a GitHub repo.
2. On [vercel.com](https://vercel.com), "Add New Project" → import that repo.
3. Vercel reads `vercel.json` automatically and:
   - **Install step**: clones the Flutter stable SDK, runs `flutter doctor`, enables web support, and fetches packages (`flutter pub get`).
   - **Build step**: generates the translations (`flutter gen-l10n`) and builds the release web bundle (`flutter build web --release`) into `build/web`, which Vercel serves.
4. Deploy — you'll get a live URL to test language switching and DZD pricing in the browser.

If Vercel's dashboard shows a "Framework Preset" other than the one from `vercel.json`, go to **Project Settings → Build & Development Settings**, set Framework Preset to **Other**, and paste these manually (this is the most common reason a Flutter-on-Vercel deploy fails — the dashboard setting can silently override `vercel.json`):
- **Install Command**: `if cd flutter; then git pull && cd .. ; else git clone https://github.com/flutter/flutter.git -b stable --depth 1; fi && flutter/bin/flutter doctor && flutter/bin/flutter config --enable-web --no-analytics && flutter/bin/flutter pub get`
- **Build Command**: `flutter/bin/flutter gen-l10n && flutter/bin/flutter build web --release`
- **Output Directory**: `build/web`

**Option B — Vercel CLI:**
```bash
npm i -g vercel
vercel        # first deploy, follow prompts
vercel --prod # promote to production URL
```

**If the deploy still fails:** open the failed deployment in the Vercel dashboard → **Building** section, copy the exact error text, and send it to me — that's the fastest way to pin down the real cause (build timeout, a plugin without web support, a dependency version conflict, etc.) rather than guessing blind.

**Good to know about the web build:**
- The barcode camera scanner works in the browser (it'll ask for camera permission) and the UI/RTL/currency/language switching all work fully.
- Bluetooth thermal printing, vibration, and `permission_handler`/`app_settings` calls are mobile-only — they simply won't do anything in the browser preview. That's expected; test those features by building the real Android/iOS app.

