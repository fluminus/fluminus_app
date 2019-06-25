# Fluminus App

[![Build Status](https://travis-ci.com/fluminus/fluminus_app.svg?branch=master)](https://travis-ci.com/fluminus/fluminus_app) 
[![Codemagic build status](https://api.codemagic.io/apps/5d109d3d99fdb7140ed490bd/5d109d3d99fdb7140ed490bc/status_badge.svg)](https://codemagic.io/apps/5d109d3d99fdb7140ed490bd/5d109d3d99fdb7140ed490bc/latest_build)
[![License](https://img.shields.io/badge/license-Apache2-blue.svg)](https://github.com/fluminus/fluminus_app/blob/feature__refresh/LICENSE)

An overall much better LMS (Learning management system) experience on [LumiNUS](https://luminus.nus.edu.sg/), and more to truly *illuminate your learning path*, written in [Dart](https://dart.dev/), built with [Flutter](https://flutter.dev/), available for **all** mobile platforms.

## What it does (aims to achieve)...

* A better LumiNUS mobile experience
    * push notifications powered by Firebase
        * announcement
        * file upload
        * forum posts & reply  //wonderful if we only receive “favourite” ones
        * web lecture update
    * offline file management (SQLite) ✔
    * gmail-like announcement management (flag & archive announcements) ✔
* A task management part (todo-list)
    * Basic task management ✔
    * Intelligent suggestions (extract event and time info from announcements, using Google Natural Language API)
    * Progress track (allow users to break one big task into baby steps, and track the progress)
    * Tinder-like gamified task ordering experience (help you prioritize tasks like choosing dates)
* (Possibly a forum that’s deeply linked to modules)
    * share past year materials
    * etc.

## Milestones

Please look at our [Project board](https://github.com/fluminus/fluminus_app/projects)

## Related work

[fluminus](https://github.com/indocomsoft/fluminus) the project that inspired this project, a library in Elixir to access the reverse-engineered LumiNUS API.

[luminus_api](https://github.com/fluminus/luminus_api) a Dart library providing abstraction for LumiNUS's OpenID Connect authentication flow and API responses.

## Developers

[Tan Yuanhong](https://github.com/le0tan)

[Zhang Xiaoyu](https://github.com/ZhangHuafan)
