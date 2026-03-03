
# Blueprint: USB Validator & Compatibility Checker

## Overview

This document outlines the plan for creating a Flutter application that scans USB drives to check their compatibility with specific models of Pioneer DJ equipment. The app is inspired by the web-based "USB VALIDATOR & COMPATIBILITY CHECKER" and visually mimics the hardware interface of a Pioneer CDJ-3000.

## Core Features

- **CDJ-style UI**: A dark, immersive user interface that resembles the look and feel of a Pioneer CDJ, providing a familiar experience for DJs.
- **DJ Gear Selection**: Before scanning, the user must select their specific DJ gear model from a comprehensive list. This tailors the compatibility check to the selected hardware.
- **USB Drive Selection**: Allow the user to select the root of their USB drive by pressing a hardware-style "SCAN" button, which is enabled only after selecting a gear model.
- **Model-Specific Compatibility Analysis**: Run a series of checks on the selected drive based on the limitations of the chosen DJ gear model (e.g., FLAC support, exFAT support).
- **Detailed Report**: Display a clear, model-specific report of the findings on a simulated CDJ screen, indicating whether the drive is compatible and what issues were found.

## Design and Style

- **Theme**: A dark, CDJ-inspired theme with a black and dark gray color palette, accented with Pioneer DJ red and yellow.
- **Typography**: The app now uses the `Lato` font from `google_fonts` for a clean, modern, and highly readable sans-serif typeface across all text elements.
- **Iconography**: Material icons are styled to match the theme and enhance usability.

## Technical Plan

### Step 1: Initial Setup & Dependencies (Completed)

- Create this `blueprint.md` file.
- Add initial dependencies to `pubspec.yaml`: `provider`, `google_fonts`, `file_picker`, `permission_handler`.

### Step 2: Data Model (Completed)

- **`models/dj_gear.dart`**: Created a `DjGear` class to store the name, category, and compatibility flags (e.g., `hasFlacSupport`, `hasExfatSupport`) for each piece of equipment. Populated a list with all supported models.

### Step 3: Application Structure & UI (Completed)

- **`main.dart`**: Configured the main `MaterialApp` with the dark, CDJ-inspired theme and set `Lato` as the default font.
- **`HomePage.dart`**: Redesigned into a gear selection screen. The main "screen" area now lists all DJ gear models, grouped by category. The user must select a model before the "SCAN" button becomes active.
- **`ResultsPage.dart`**: Updated to display a report tailored to the selected model. The title now dynamically shows which gear the report is for (e.g., "Report for XDJ-XZ").

### Step 4: Core Logic (Completed)

- **State Management (`ScanProvider.dart`)**:
    - A `ChangeNotifier` to manage the scan state, results, and the currently selected `DjGear` model.
- **Model-Specific Compatibility Checks (`compatibility_checker.dart`)**:
    - The `checkCompatibility` function now requires a `DjGear` object.
    - **Check 1: File System Format**: The check now cross-references the detected file system (e.g., 'exFAT') with the selected gear's `hasExfatSupport` flag.
    - **Check 2: Audio Files**: The check now differentiates between standard audio files and FLAC files. It will raise a specific error if FLAC files are found and the selected gear's `hasFlacSupport` flag is `false`.
    - Other checks (PIONEER folder, file names, etc.) remain as they are broadly applicable.

### Step 5: Iteration and Refinement (Completed)

- The application flow is now more robust and user-centric.
- The results are more precise, providing actionable feedback based on the user's specific hardware.
- The main call-to-action button has been updated from "USB" to "SCAN" for clarity.
- The app-wide font has been changed to `Lato` for a cleaner, more modern design.

---

## Final Result

The application is now a powerful, model-specific USB compatibility checker with a highly immersive and intuitive CDJ-inspired interface. It empowers DJs to confidently prepare their USB drives for any gig by verifying compatibility against the exact equipment they will be using.
