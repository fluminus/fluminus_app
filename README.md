# Fluminus App

[![Build Status](https://travis-ci.com/fluminus/fluminus_app.svg?branch=master)](https://travis-ci.com/fluminus/fluminus_app) 
[![Codemagic build status](https://api.codemagic.io/apps/5d109d3d99fdb7140ed490bd/5d109d3d99fdb7140ed490bc/status_badge.svg)](https://codemagic.io/apps/5d109d3d99fdb7140ed490bd/5d109d3d99fdb7140ed490bc/latest_build)
[![License](https://img.shields.io/badge/license-Apache2-blue.svg)](https://github.com/fluminus/fluminus_app/blob/feature__refresh/LICENSE)

An overall much better LMS (Learning management system) experience on [LumiNUS](https://luminus.nus.edu.sg/), and more to truly *illuminate your learning path*, written in [Dart](https://dart.dev/), built with [Flutter](https://flutter.dev/), available on **both** iOS and Android.

## Features

*Features implemented by milestone 2 are labeled with a ✔*

* A better LumiNUS mobile experience
    * push notifications powered by Firebase Cloud Messaging ✔
        * announcement
        * file upload
        * forum posts & reply  //wonderful if we only receive “favourite” ones
        * web lecture update
    * offline file management (SQLite) ✔
    * gmail-like announcement management (schedule & archive announcements) ✔
* A task management tool (todo-list)
    * Basic task management ✔
    * Intelligent suggestions (extract event and time info from announcements) ✔
    * Progress track (allow users to break one big task into baby steps, and track the progress)
* A [forum](https://forum.tyhome.site) for module-related discussions ✔
    * share past year materials
    * more user-friendly forum experience than LumiNUS forums

## Milestones

Please look at our [Project board](https://github.com/fluminus/fluminus_app/projects) for both finished features/bug fixes/enhancements and future plans.

## Related work

[fluminus](https://github.com/indocomsoft/fluminus) the project that inspired this project, a library in Elixir to access the reverse-engineered LumiNUS API.

[luminus_api](https://github.com/fluminus/luminus_api) a Dart library providing abstraction for LumiNUS's OpenID Connect authentication flow and API responses.

[fluminus_server](https://github.com/fluminus/server) server-side application that currently mainly powers the push notification service.

## "Pulse"

### Stats (by 01/07/2019)

* Within Fluminus app itself, **3741** lines of Dart code is written under `\lib` folder.
   * Note that we abstracted out almost any repetitive UI element into `\lib\widgets` folder and any repetitive helper functions into `\lib\db` and `\lib\util.dart` respectively, and Flutter (or SwiftUI or any declarative frameworks) are much more concise compared with imperative implementations.
* On the fluminus_app, from June 1, 2019 – July 1, 2019, excluding merges, 2 authors have pushed 69 commits to master and 85 commits to all branches. On master, 93 files have changed and there have been 4,369 additions and 668 deletions.

### Development stack

[Flutter](https://github.com/flutter/flutter), [SQLite in Flutter](https://pub.dev/packages/sqflite), [Express (A web framework written in NodeJS)](https://github.com/expressjs/express), [Firebase](https://firebase.google.com/)

[Fabric](https://fabric.io/home), Travis CI, Codemagic (CI/CD for Flutter)

## Developers

[Tan Yuanhong](https://github.com/le0tan)
* Overall architecture of the Fluminus app
   * Kickstarter of Fluminus by writing and maintaining [luminus_api](https://github.com/fluminus/luminus_api)
   * Main writer of the file management and push notification sections
   * Maintainer of server-side applications (push notification service & forum)
* iOS-side platform-specific optimization and distribution

[Zhang Xiaoyu](https://github.com/ZhangHuafan)
* Overall UI&UX design of the Fluminus app
   * Main writer of the announcement & task management sections
   * Introduces Redux as the complex state management method for the app
   * Abstracted UI elements into reusable widgets under `\lib\widgets`
* Android-side platform-specific optimization and distribution

## Tester

[Raivat Shah](https://github.com/raivatshah)
