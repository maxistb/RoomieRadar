// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "RoomieRadarCoreData",
  products: [
    .library(
      name: "RoomieRadarCoreData",
      targets: ["RoomieRadarCoreData"]
    ),
  ],
  dependencies: [
    .package(
      url: "https://github.com/firebase/firebase-ios-sdk.git",
      from: "10.20.0"
    ),
  ],
  targets: [
    .target(
      name: "RoomieRadarCoreData",
      dependencies: [
        .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
        .product(name: "FirebaseAnalyticsSwift", package: "firebase-ios-sdk"),
        .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk"),
        .product(name: "FirebaseDatabaseSwift", package: "firebase-ios-sdk"),
        .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
        .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
        .product(name: "FirebaseFirestoreSwift", package: "firebase-ios-sdk"),
        .product(name: "FirebaseStorage", package: "firebase-ios-sdk"),
      ]
    ),
  ]
)
