# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2026-01-10

### 🔥 BREAKING CHANGES
- **iOS Support**: Minimum iOS version updated to 13.0 (previously 12.0).
- **Test Architecture**: Complete test suite restructure with removal of legacy test files.
- **Dependencies**: Major dependency updates that may affect existing integrations.

### ✨ Added
- **CI/CD Pipeline**: GitHub Actions workflow for automated Flutter tests and coverage checks.
- **Unit Testing Suite**: Comprehensive unit tests for multiple components.
- **Integration Testing**: Add integration test framework for login validation.
- **TestLab Integration**: Automated integration tests using Firebase TestLab.
- **Development Tools**:
  - VS Code settings for Flutter SDK path configuration.
  - FVM (Flutter Version Manager) integration with Flutter 3.38.5.

### 🚀 Enhanced
- **State Management**: 
  - Migration to `AsyncNotifier` pattern for better async state handling.
  - Improved provider syntax across authentication and home features.
  - Enhanced error handling in providers with proper failure propagation.
- **Navigation**: Enhanced splash screen with better state management and timer handling.

### 🔧 Changed
- **Flutter Version**: Updated to Flutter 3.38.5 via FVM.
- **Dependencies**: Updated multiple dependencies in `pubspec.yaml` for better compatibility.
- **iOS Configuration**: Updated deployment target and Xcode project settings.
- **Android Configuration**: 
  - Updated Java version from 11 to 17 for better compatibility with Flutter 3.38.5.
  - Updated Gradle version from 8.10.2 to 8.14.
  - Updated Android Gradle Plugin from 8.7.0 to 8.11.1.
  - Updated Kotlin version from 1.8.22 to 2.2.20.
  - Improved Gradle configuration with better build directory handling.
  - Removed hardcoded Java home path for better cross-platform compatibility.
  - Updated NDK version to use Flutter's default configuration.
  - Updated minSdk to use Flutter's default configuration.
- **Provider Patterns**: Migrated from legacy provider patterns to modern Riverpod syntax.

### 🗑️ Removed
- **Unused Dependencies**: Cleaned up unused packages and imports.

### 🐛 Fixed
- **Authentication**: Fixed Firebase Auth instance management in sign-up flow.
- **Type Safety**: Corrected type assertions in user model validation.
- **Coverage Integration**: Fixed coverage threshold configuration in CI/CD pipeline.
- **iOS Compatibility**: Resolved iOS deployment target compatibility issues.
- **Android Compatibility**: 
  - Fixed Java version compatibility issues with Flutter 3.38.5.
  - Resolved Gradle build configuration for modern Android toolchain.
  - Fixed NDK version conflicts by using Flutter's managed configuration.
  - Corrected minSdk configuration to prevent compilation errors.
- **Provider Initialization**: Fixed async provider initialization patterns.

### 📊 Testing
- **Coverage Threshold**: Set the minimum variable configuration for CI/CD pipeline.
- **Automation**: Automated test execution with coverage reporting.

### 📱 Platform Support
- **iOS**: Minimum version 13.0+.
- **Android**: Enhanced compatibility with modern Android toolchain (Java 17, Gradle 8.14, AGP 8.11.1, Kotlin 2.2.20).
- **Flutter**: 3.38.5 via FVM management.

## [1.0.0] - Previous Release
- Initial release of Marvel Animation App.
- Basic authentication and hero browsing functionality.
- Core UI components and navigation structure.