
# Blueprint: USB Validator & Compatibility Checker

## Overview

This document outlines the plan for creating a Flutter application that scans USB drives to check their compatibility with specific models of Pioneer DJ equipment. The app is inspired by the web-based "USB VALIDATOR & COMPATIBILITY CHECKER" and visually mimics the hardware interface of a Pioneer CDJ-3000.

## Core Features

- **CDJ-style UI**: A dark, immersive user interface that resembles the look and feel of a Pioneer CDJ, providing a familiar experience for DJs.
- **DJ Gear Selection**: Before scanning, the user must select their specific DJ gear model from a comprehensive list using a space-saving dropdown menu.
- **USB Drive Selection**: Allow the user to select the root of their USB drive by pressing a hardware-style "SCAN" button, which is enabled only after selecting a gear model.
- **Model-Specific Compatibility Analysis**: Run a series of checks on the selected drive based on the limitations of the chosen DJ gear model (e.g., FLAC support, exFAT support).
- **Detailed Report**: Display a clear, model-specific report of the findings on a simulated CDJ screen, indicating whether the drive is compatible and what issues were found.
- **Support Section**: A dedicated section with buttons for users to support the developer by following on Instagram or making a donation.

## Design and Style

- **Theme**: A dark, CDJ-inspired theme using the official Rekordbox color palette for an authentic feel:
    - **Primary/Error:** Red (`#FF0000`)
    - **Accent:** Yellow (`#FFFF00`)
    - **Success:** Green (`#00FF00`)
    - **Warning:** Orange (`#FFA500`)
- **Typography**: The app now uses the `Lato` font from `google_fonts` for a clean, modern, and highly readable sans-serif typeface across all text elements.
- **Iconography**: Material and FontAwesome icons are styled to match the theme and enhance usability.

## Technical Plan

### Step 1: Initial Setup & Dependencies (Completed)

- Create this `blueprint.md` file.
- Add initial dependencies to `pubspec.yaml`: `provider`, `google_fonts`, `file_picker`, `permission_handler`, `url_launcher`, `font_awesome_flutter`.

### Step 2: Data Model (Completed)

- **`models/dj_gear.dart`**: Created a `DjGear` class to store the name, category, and compatibility flags (e.g., `hasFlacSupport`, `hasExfatSupport`) for each piece of equipment. Populated a list with all supported models.

### Step 3: Application Structure & UI (In Progress)

- **`main.dart`**: Configured the main `MaterialApp` with the dark, CDJ-inspired theme and set `Lato` as the default font.
- **`HomePage.dart`**: The main screen has been refactored.
    - The DJ gear selection is now a two-tiered dropdown system (category and then gear) to save space.
    - The "CDJ Body" now contains the main "SCAN" button and a new "Support" section.
    - The "Support" section has two distinct buttons: "Follow me on Instagram" and "Buy me a Coffee."
- **`ResultsPage.dart`**: Updated to display a report tailored to the selected model. The title now dynamically shows which gear the report is for (e.g., "Report for XDJ-XZ").

### Step 4: Core Logic (Completed)

- **State Management (`ScanProvider.dart`)**:
    - A `ChangeNotifier` to manage the scan state, results, and the currently selected `DjGear` model.
- **Model-Specific Compatibility Checks (`compatibility_checker.dart`)**:
    - The `checkCompatibility` function now requires a `DjGear` object.
    - **Check 1: File System Format**: The check now cross-references the detected file system (e.g., 'exFAT') with the selected gear's `hasExfatSupport` flag.
    - **Check 2: Audio Files**: The check now differentiates between standard audio files and FLAC files. It will raise a specific error if FLAC files are found and the selected gear's `hasFlacSupport` flag is `false`.
    - Other checks (PIONEER folder, file names, etc.) remain as they are broadly applicable.

### Step 5: Iteration and Refinement (In Progress)

- The application flow is now more robust and user-centric.
- The results are more precise, providing actionable feedback based on the user's specific hardware.
- The main call-to-action button has been updated from "USB" to "SCAN" for clarity.
- The app-wide font has been changed to `Lato` for a cleaner, more modern design.
- The color scheme has been updated to the official Rekordbox palette.
- Added a "By No-Mad" subtitle to the app title.

---

## Final Result

The application is now a powerful, model-specific USB compatibility checker with a highly immersive and intuitive CDJ-inspired interface. It empowers DJs to confidently prepare their USB drives for any gig by verifying compatibility against the exact equipment they will be using. The app also includes a prominent section for users to support the developer.
