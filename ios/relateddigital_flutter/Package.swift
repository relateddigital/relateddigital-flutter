// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "relateddigital_flutter",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        .library(name: "relateddigital-flutter", targets: ["relateddigital_flutter"])
    ],
    dependencies: [
        .package(url: "https://github.com/relateddigital/visilabs-ios.git", exact: "4.5.0"),
        .package(url: "https://github.com/relateddigital/euromessage-ios.git", exact: "2.7.2"),
    ],
    targets: [
        .target(
            name: "relateddigital_flutter",
            dependencies: [
                .product(name: "VisilabsIOS", package: "visilabs-ios"),
                .product(name: "Euromsg", package: "euromessage-ios"),
            ]
        )
    ]
)
