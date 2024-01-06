# Movie App Readme

## Overview

The Movie App is a Flutter-based mobile application designed to provide users with information about various TV shows. It utilizes the [TVmaze API](https://api.tvmaze.com/search/shows?q=all) to fetch details about TV shows.

## Video Link

You can check out the video [here](https://drive.google.com/file/d/1DUKd6XWEd-a9VogJn3XACNTGlArHe4fp/view?usp=drivesdk)

## Features

- **Show Listings:** View a list of TV shows retrieved from the TVmaze API.
- **Show Details:** Get detailed information about a specific TV show.
- **Image Caching:** Utilizes the `cached_network_image` package to efficiently cache and display images.
- **Responsive Design:** Adopts responsive design principles through the use of the `flutter_screenutil` package for consistent layouts on different screen sizes.
- **HTTP Requests:** Fetches data from the TVmaze API using the `http` package.
- **Custom Fonts:** Implements custom fonts using the `google_fonts` package for enhanced visual appeal.
- **SVG Support:** Renders SVG images with the `flutter_svg` package, offering flexibility in image resources.
- **State Management:** Employs the `get` package for effective and concise state management.
- **Loading Effects:** Enhances user experience with shimmering loading effects using the `shimmer` package.
- **HTML Rendering:** Displays HTML content with the `flutter_html` package.
- **HTML Unescaping:** Uses the `html_unescape` package to handle HTML character entities.

## Dependencies

Ensure the following dependencies are added to your `pubspec.yaml` file:

```yaml
dependencies:
  cupertino_icons: ^1.0.2
  cached_network_image: ^3.3.0
  flutter_screenutil: ^5.9.0
  http: ^1.1.0
  google_fonts: ^6.1.0
  flutter_svg: ^2.0.9
  get: ^4.6.5
  shimmer: ^3.0.0
  flutter_html: ^3.0.0-beta.2
  html_unescape: ^2.0.0
```

## Getting Started

1. Clone the repository: `git clone [repository_url]`
2. Navigate to the project directory: `cd movie_app`
3. Run `flutter pub get` to install dependencies.
4. Open the project in your preferred Flutter development environment.
5. Run the app on an emulator or physical device: `flutter run`

## Feedback and Contributions

Feel free to provide feedback or contribute to the project by submitting issues or pull requests. Your input is highly appreciated!

Happy coding! 🎬🍿
