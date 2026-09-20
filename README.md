# Fast Pizza 🍕

A Flutter pizza ordering app with Firebase Authentication, a shopping basket, simulated order tracking, and local delivery notifications on iOS.

## Features

- Sign up and sign in with email and password.
- Browse pizzas with images, descriptions, and prices.
- Add pizzas to the basket and adjust quantities.
- View the total price before ordering.
- Place an order and automatically clear the basket.
- View order progress in the profile.
- Delete individual orders or all orders.
- Receive a local iOS notification when an order reaches Delivered.

## Order Tracking

Each order progresses through five stages:

1. Order received
2. Preparing your order
3. Courier picked up your order
4. Courier is almost there
5. Delivered

Delivery tracking is simulated. A timer advances the order every 15 seconds; it is not connected to a restaurant or courier.

## Built With

- **Flutter & Dart** — application UI and logic
- **flutter_bloc** — state management
- **Firebase Authentication** — email and password authentication
- **flutter_local_notifications** — local notifications

## Getting Started

### Requirements

- Flutter SDK compatible with the project dependencies
- A Firebase project
- Xcode for running on an iPhone or iOS Simulator
- Firebase CLI and FlutterFire CLI for Firebase configuration

### Installation

Clone the repository:

```bash
git clone https://github.com/SargisKhachikyan/Pizza_delivery_app.git
cd Pizza_delivery_app
```

Install dependencies:

```bash
flutter pub get
```

Configure Firebase using your own Firebase project:

```bash
firebase login
flutterfire configure
```

In the Firebase Console, open **Authentication → Sign-in method** and enable **Email/Password**.

Start an iOS Simulator or connect your device, then run:

```bash
flutter run
```

Allow notifications when prompted to receive delivery alerts.

## Usage

1. Create an account or sign in.
2. Add pizzas to your basket.
3. Open the basket and tap **Place order**.
4. Follow the order progress in your profile.
5. Keep the app open during the demo to see the order reach **Delivered** and receive a notification.

## How It Works

`PizzaBloc` manages the basket and order state.

When an order is placed, the app saves its items and total in memory, clears the basket, and starts a timer. The timer triggers status updates, and the interface rebuilds to show the current delivery stage.

When the order reaches **Delivered**, the notification service displays a local notification.

Deleting an order cancels its timer. Deleting all orders cancels all active order timers.

## Current Limitations

- Basket contents and orders are stored in memory and are lost when the app restarts.
- Signing out clears the basket and orders.
- iOS may suspend the timer when the app is in the background.
- Delivery notifications are triggered by the running app; they are not server push notifications.
- Local notifications are configured for iOS.
- Real order processing, payments, and courier tracking are not implemented.

## Tests

Run the Flutter tests:

```bash
flutter test
```

## Future Improvements

- Persistent basket and order storage
- Delivery address management
- Restaurant and courier integration
- Push notifications
- Payment processing

## Author

[Sargis Khachikyan](https://github.com/SargisKhachikyan)
