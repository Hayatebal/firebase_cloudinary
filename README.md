# Firebase and Cloudinary Inventory

The app provides a shared item inventory with Google sign-in. Items are stored
in the default Cloud Firestore database with a name, quantity, and optional
Cloudinary image URL.

## Required Firebase setup

1. Enable Google under **Firebase Console → Authentication → Sign-in method**.
2. Register the Android SHA-1 and SHA-256 fingerprints, then download an updated
   `google-services.json` to `android/app/`.
3. For iOS, download `GoogleService-Info.plist`, add it to the Runner target,
   and add its `REVERSED_CLIENT_ID` as a URL scheme in `ios/Runner/Info.plist`.
4. Create the default Firestore database in `nam5` and publish `firestore.rules`
   with `firebase deploy --only firestore:rules --project fir-cloudinary-b2c9a`.
5. For web, add your app's host to Firebase Authentication's authorized domains.

The repository currently has no Firestore database and its Android Firebase
configuration has no Google OAuth clients. The app will not be able to sign in
or load items until these Firebase Console steps are completed. All signed-in
Google users can read, add, edit, and delete items in the shared collection.

## Cloudinary setup

The upload uses cloud name `bsa2xrur` and unsigned upload preset
`firebase_cloudinary`. Make sure the preset is enabled for unsigned uploads.
Restrict the preset by file type, size, and folder. Never put the Cloudinary API
secret in the Flutter app.

Deleting an inventory item removes its Firestore document; the image stays in
Cloudinary because deleting remote assets requires a trusted backend.

## Run

Run `flutter pub get`, then `flutter run`. Use **Continue with Google** to open
the shared inventory. Add, edit, or delete items with the buttons on the list.
