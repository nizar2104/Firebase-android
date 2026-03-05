{ pkgs, ... }: {
  # To find more packages, search 'nix search <pkg>' in the terminal
  # or visit https://search.nixos.org/packages.
  channel = "stable-23.11";

  # Packages to make available in the environment.
  packages = [
    pkgs.flutter
    pkgs.dart
    pkgs.android-sdk
  ];

  # Environment variables to set in the workspace.
  env = {
    ANDROID_SDK_ROOT = "${pkgs.android-sdk}/share/android-sdk";
  };

  # VS Code extensions to install in the workspace.
  extensions = [
    "dart-code.flutter"
    "dart-code.dart-code"
  ];

  # Commands to run when the workspace starts.
  onStart = {
    # Automatically accept Android SDK licenses.
    accept-licenses = "yes | ${pkgs.android-sdk}/bin/sdkmanager --licenses || true";
    # Verify the setup.
    doctor-check = "flutter doctor";
  };
}
