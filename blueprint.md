
# Blueprint: USB Validator & Compatibility Checker

## Overview

This document outlines the plan for creating a Flutter application that scans USB drives (via OTG on mobile or direct access on desktop) to check their compatibility with Pioneer DJ equipment like CDJs and XDJs. The app is inspired by the web-based "USB VALIDATOR & COMPATIBILITY CHECKER".

## Core Features

- **USB Drive Selection**: Allow the user to select the root of their USB drive.
- **Compatibility Analysis**: Run a series of checks on the selected drive.
- **Detailed Report**: Display a clear report of the findings, indicating whether the drive is compatible and what issues, if any, were found.
- **Modern UI**: A clean, intuitive, and visually appealing user interface based on Material Design 3.
- **Cross-Platform**: The app will be built with Flutter to target both mobile (Android/iOS) and web/desktop from a single codebase.

## Design and Style

- **Theme**: Material 3 with a dark and light mode.
- **Color Scheme**: A modern color palette will be chosen to create a visually appealing experience.
- **Typography**: `google_fonts` will be used for clean and readable text.
- **Iconography**: Material icons will be used to enhance usability.

## Technical Plan

### Step 1: Initial Setup & Dependencies (Completed)

- Create this `blueprint.md` file.
- Add initial dependencies to `pubspec.yaml`:
  - `provider`: For state management.
  - `google_fonts`: For custom fonts.
  - `file_picker`: To allow the user to select their USB drive directory.
  - `permission_handler`: To request storage permissions on mobile.

### Step 2: Application Structure & UI (Completed)

- **`main.dart`**:
    - Set up the main `MaterialApp` with a `ThemeProvider`.
    - Define the Material 3 light and dark themes.
    - Create a home screen (`HomePage`).
- **`HomePage.dart`**:
    - A `Scaffold` with an `AppBar`.
    - A central button labeled "Select & Scan USB Drive".
    - A loading indicator that shows when analysis is in progress.
- **`ResultsPage.dart`**:
    - A screen to display the compatibility check results in a clear, list-based format.

### Step 3: Core Logic (Completed)

- **State Management (`ScanProvider.dart`)**:
    - A `ChangeNotifier` to manage the state of the scan (e.g., `isLoading`, `results`).
- **USB Selection**:
    - Use the `file_picker` package to get the path to the user-selected directory.
    - Use `permission_handler` to ensure the app has the necessary permissions before trying to access storage.
- **Compatibility Checks (`compatibility_checker.dart`)**:
    - A function that takes the directory path as input.
    - **Check 1: File & Folder Structure**:
        - Check for the existence of a `PIONEER` directory.
        - Check for the presence of audio files (e.g., `.mp3`, `.wav`, `.flac`, `.aiff`).
    - **Check 2: File Name Analysis**:
        - Check for file and folder names exceeding 255 characters.
        - Check for the presence of unsupported special characters in file names.
    - **Check 3: Album Art**:
        - Detect the presence of common image formats that could be album art.
    - **Check 4: File System Format (New)**:
        - Use a platform channel to get the file system type from the native Android side.
        - Check if the file system is one of the compatible formats (FAT32, exFAT, FAT).

### Step 4: Iteration and Refinement (Completed)

- Implement the UI for the results page to handle different result types (booleans, strings, lists).
- Test on different platforms (Android, web, desktop).
- Gather user feedback for future improvements.

---

## Final Result

The initial version of the USB Validator & Compatibility Checker is now complete. The application allows users to select a directory, and then it runs a series of checks to determine if the selected media is likely to be compatible with Pioneer DJ equipment. The results are presented in a clear and easy-to-understand format. Future work could include adding more detailed checks and providing more detailed explanations and solutions for any issues found.
