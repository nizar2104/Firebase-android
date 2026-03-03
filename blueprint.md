
# Blueprint: USB Validator & Compatibility Checker

## Overview

This document outlines the plan for creating a Flutter application that scans USB drives (via OTG on mobile or direct access on desktop) to check their compatibility with Pioneer DJ equipment like CDJs and XDJs. The app is inspired by the web-based "USB VALIDATOR & COMPATIBILITY CHECKER" and visually mimics the hardware interface of a Pioneer CDJ-3000.

## Core Features

- **CDJ-style UI**: A dark, immersive user interface that resembles the look and feel of a Pioneer CDJ, providing a familiar experience for DJs.
- **USB Drive Selection**: Allow the user to select the root of their USB drive by pressing a hardware-style "USB" button.
- **Compatibility Analysis**: Run a series of checks on the selected drive.
- **Detailed Report**: Display a clear report of the findings on a simulated CDJ screen, indicating whether the drive is compatible and what issues, if any, were found.

## Design and Style

- **Theme**: A dark, CDJ-inspired theme with a black and dark gray color palette, accented with Pioneer DJ red and yellow.
- **Typography**: `google_fonts` are used to match the digital look of DJ equipment displays:
    - `Orbitron`: For titles and headers, providing a tech-inspired feel.
    - `Roboto`: For body text, ensuring readability.
- **Iconography**: Material icons are styled to match the theme and enhance usability.

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
    - Set up the main `MaterialApp` with a dark, CDJ-inspired theme.
    - Define the color scheme and typography to match the hardware aesthetic.
- **`HomePage.dart`**:
    - A `Scaffold` designed to look like a CDJ-3000.
    - A main "screen" area to display information and loading status.
    - A simulated "USB slot" and a large, circular "USB" button to trigger the scan.
- **`ResultsPage.dart`**:
    - A screen styled to look like the CDJ's display, presenting the compatibility results in a clear and concise manner.

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
    - **Check 4: File System Format**:
        - Use a platform channel to get the file system type from the native Android side.
        - Check if the file system is one of the compatible formats (FAT32, exFAT, FAT).

### Step 4: Iteration and Refinement (Completed)

- The UI has been completely redesigned to match the look and feel of a Pioneer CDJ.
- The results page now displays information in a format that is consistent with the new design.

---

## Final Result

The application has been transformed into a CDJ-3000 simulator for the purpose of checking USB drive compatibility. The new design provides a more immersive and familiar experience for DJs. The core functionality remains the same: the app runs a series of checks on a selected directory and presents a report, but now it does so within a much more engaging and stylish interface.
