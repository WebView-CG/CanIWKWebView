# WKWebView Configuration Settings

## Settings Categories

### JavaScript
- **JavaScript Enabled**: Enable/disable JavaScript execution (uses modern WKWebpagePreferences API)
- **Can Open Windows Automatically**: Allow JavaScript to open windows without user interaction

### Media Playback
- **Inline Media Playback**: Allow videos to play inline instead of fullscreen
- **Require User Action for Media**: Require user tap to start media playback
- **Picture in Picture**: Enable picture-in-picture mode for videos
- **AirPlay for Media**: Enable AirPlay streaming for media content

### Content & Rendering
- **Suppress Incremental Rendering**: Wait for full page load before displaying
- **Ignore Viewport Scale Limits**: Override viewport meta tag scaling restrictions
- **Data Detector Types**: Auto-detect and link phone numbers, addresses, dates, etc.
- **Preferred Content Mode**: Choose between Mobile, Desktop, or Recommended rendering

### Security & Privacy
- **Fraudulent Website Warning**: Show warnings for suspected phishing sites
- **Limit to App-Bound Domains**: Restrict navigation to declared app-bound domains
- **Upgrade Known Hosts to HTTPS**: Automatically upgrade HTTP to HTTPS for known sites

### Interaction
- **Link Preview**: Enable 3D Touch/long-press link previews
- **Swipe Navigation Gestures**: Enable back/forward swipe gestures

### Text & Typography
- **Text Interaction Enabled**: Allow text selection and interaction
- **Minimum Font Size**: Set minimum font size for better readability

### Advanced Settings
- **Print Backgrounds**: Include background colors/images when printing
- **Element Fullscreen Enabled**: Allow HTML elements to go fullscreen
- **Site-Specific Quirks Mode**: Enable compatibility fixes for specific sites
- **Custom User Agent**: Override the default user agent string
- **Application Name for User Agent**: Add custom app name to user agent

## Technical Implementation

All settings are:
- Persisted in UserDefaults across app launches
- Applied to WKWebView configuration at initialization
- Updated dynamically when changed (where supported by WebKit)
- Compatible with both iOS and macOS Catalyst without conditional compilation
- Using modern non-deprecated APIs (e.g., WKWebpagePreferences for JavaScript control)

## Network Access Fix for Catalyst

The entitlements file was updated to include `com.apple.security.network.client` which is required for WKWebView to function properly on macOS Catalyst with sandboxing enabled.
