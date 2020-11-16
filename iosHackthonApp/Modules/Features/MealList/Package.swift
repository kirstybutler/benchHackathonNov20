// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MealList",
	platforms: [.iOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "MealList",
            targets: ["MealList"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
		.package(path: "../Shared/Extensions"),
		.package(path: "../Shared/Location"),
		.package(path: "../Shared/Components"),
		.package(name: "shared", path: "/Users/kanecheshire/Projects/benchHackathonNov20/shared/swiftpackage")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "MealList",
            dependencies: ["shared", "Extensions", "Location", "Components"]),
        .testTarget(
            name: "MealListTests",
            dependencies: ["MealList"]),
    ]
)
