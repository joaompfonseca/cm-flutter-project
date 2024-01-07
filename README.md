# CM Project - Flutter

## Description

This Flutter based application provides a community collaboration platform for bicycle users. It provides a map using CyclOSM (a custom OpenStreetMap layer), allows the creation of points of interest using the camera, recording of routes using the location and getting directions from any location to a destination by calling GraphHopper, an external routing engine. As a community, users can rate points of interest and level up in the ranking system.
The backend is deployed on AWS and was developed using FastAPI. The authentication mechanism is provided by AWS Cognito, the database to store the information is provided by Amazon RDS and we used Amazon S3 to store all the images.

**Course:** Mobile Computing (2023/2024).

## Installation

- Run `flutter pub get` in root to install project dependencies.

## Running the application

- Run `flutter run` in root to run the project.

## Building the application APK

- Run `flutter build apk` in root to build the APK, that can be installed on an
Android device.

## Authors

- Diogo Paiva, 103183

- João Fonseca, 103154
