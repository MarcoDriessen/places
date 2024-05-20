# Description

## About
iOS technical assignment Marco Driessen. 

## Goal

### Wikipedia app
- Adjust the Wikipedia app, so different apps can deeplink into the Wikipedia app. The deeplink has to open the "Places" tab, and show a location on the map.

### Places app
- Show a list of locations.
- Upon tapping on one of those locations, open the Wikipedia app and show the location on the map.
- Allow the user to add custom locations.
- Use SwiftUI
- Add a Readme
- Include Unit Tests
- Accessibility and Concurrency

## Prerequisites
- Xcode 15 or higher
- iOS 17 of higher

## Instructions for reviewer
- Clone the Wikipedia app from GitHub (https://github.com/wikimedia/wikipedia-ios).
- Apply git patch `patch.diff` to see changes made in the Wikipedia app: `git apply patch.diff`.
- Build and run the `Places` iOS app.

# Considerations
- Added reverse geocoding to allow the user to preview a location name, or to enter just a location name.
- System UI is used for built in basic accessibility features.

## Future enhancements
- UI enhancements.
- Impement a more robust API Service that handles more than just a URL.
- Implement a separate ViewModel for SearchView for better separation of concerns.
- Improve initialization and location of initial Views.
- Proper use of #Preview and Preview Content.
- Full accessibility support.
- Concurrency improvements.



