# Change Log

All notable changes to this project will be documented in this file.
See [Conventional Commits](Https://conventionalcommits.org) for commit guidelines.

<!-- changelog -->

## [v0.95.3](https://git.inhji.de/inhji/akedia/compare/v0.95.2...v0.95.3) (2020-11-15)




### Bug Fixes:

* reorder form fields, fix topic input spacing

* remove status form from public/index

## [v0.95.2](https://git.inhji.de/inhji/akedia/compare/v0.95.1...v0.95.2) (2020-11-14)




### Bug Fixes:

* small fixes

* improve post form live, first working version

* add global class helper

* taginput being reset on live view update

* rename template_name to action_name

## [v0.95.1](https://git.inhji.de/inhji/akedia/compare/v0.95.0...v0.95.1) (2020-11-12)




### Bug Fixes:

* tag input in post form live

* add live view js hooks support

* view loader string

## [v0.95.0](https://git.inhji.de/inhji/akedia/compare/v0.94.4...v0.95.0) (2020-11-12)




### Features:

* add html and sanitized content to bookmarks

### Refactors:

* show bookmark title bigger, clean up post meta

## [v0.94.4](https://git.inhji.de/inhji/akedia/compare/v0.94.3...v0.94.4) (2020-11-09)




### Bug Fixes:

* show pinned topics in tag cloud

## [v0.94.3](https://git.inhji.de/inhji/akedia/compare/v0.94.2...v0.94.3) (2020-11-09)




### Bug Fixes:

* add oban migration for versio 2.3.0

* enum.count on an integer is not a wise move

* show bookmark svg when no favicon exists

* bring back stupid glitch fix

* prettier mentions

* correctly show reposts

### Refactors:

* clean up navigation

## [v0.94.2](https://git.inhji.de/inhji/akedia/compare/v0.94.1...v0.94.2) (2020-11-09)




### Bug Fixes:

* enum.count on an integer is not a wise move

* show bookmark svg when no favicon exists

* bring back stupid glitch fix

* prettier mentions

* remove arbitrary spacing in hcard

### Refactors:

* clean up navigation

* include nprogress css, tint progress bar purple

## [v0.94.1](https://git.inhji.de/inhji/akedia/compare/v0.94.0...v0.94.1) (2020-11-09)




### Bug Fixes:

* add js view for post/edit

## [v0.94.0](https://git.inhji.de/inhji/akedia/compare/v0.93.0...v0.94.0) (2020-11-09)




### Features:

* use live view from github

* wip new post form

* show all entities again, massively improve article html

## [v0.93.0](https://git.inhji.de/inhji/akedia/compare/v0.92.1...v0.93.0) (2020-11-08)




### Features:

* new favicon

## [v0.92.1](https://git.inhji.de/inhji/akedia/compare/v0.92.0...v0.92.1) (2020-11-08)




### Bug Fixes:

* secure session options

## [v0.92.0](https://git.inhji.de/inhji/akedia/compare/v0.91.4...v0.92.0) (2020-11-08)




### Features:

* convert post form to live view, more opens the big form with content prefilled

* add nprogress

* add support for live templates

### Bug Fixes:

* make dynamic js loading work with live view, thanks to https://elixirforum.com/t/new-layouts-in-phoenix/30967

### Refactors:

* clean up some stuff

## [v0.91.4](https://git.inhji.de/inhji/akedia/compare/v0.91.3...v0.91.4) (2020-11-07)




### Bug Fixes:

* go back to node 14 lts

## [v0.91.3](https://git.inhji.de/inhji/akedia/compare/v0.91.2...v0.91.3) (2020-11-07)




### Bug Fixes:

* remove OptimizeCSSAssetsPlugin in favor of CssMinimizerPlugin

## [v0.91.2](https://git.inhji.de/inhji/akedia/compare/v0.91.1...v0.91.2) (2020-11-07)




### Bug Fixes:

* remove emoji picker from app.scss

## [v0.91.1](https://git.inhji.de/inhji/akedia/compare/v0.91.0...v0.91.1) (2020-11-07)




### Bug Fixes:

* more webpack bikeshedding

## [v0.91.0](https://git.inhji.de/inhji/akedia/compare/v0.90.3...v0.91.0) (2020-11-07)




### Features:

* Page specific JavaScript

* trim fat off of bulma

* optimize webpack build

## [v0.90.3](https://git.inhji.de/inhji/akedia/compare/v0.90.2...v0.90.3) (2020-11-07)




### Bug Fixes:

* reference to old atomex

## [v0.90.2](https://git.inhji.de/inhji/akedia/compare/v0.90.1...v0.90.2) (2020-11-07)




### Bug Fixes:

* add spacer helper class

* add link to security to menu

* rly rly use emojipicker css

* improve queue and link

### Refactors:

* add a shitton of emojis to the post form

* break out webauthn stuff into Akedia.Auth

* clean up user pages

## [v0.90.1](https://git.inhji.de/inhji/akedia/compare/v0.90.0...v0.90.1) (2020-11-06)




### Bug Fixes:

* search results

* show all drafted posts

* add emoji button css

## [v0.90.0](https://git.inhji.de/inhji/akedia/compare/v0.89.3...v0.90.0) (2020-11-06)




### Features:

* eat atomex

### Bug Fixes:

* microformats parsing

## [v0.89.3](https://git.inhji.de/inhji/akedia/compare/v0.89.2...v0.89.3) (2020-11-06)




### Bug Fixes:

* update all deps

## [v0.89.2](https://git.inhji.de/inhji/akedia/compare/v0.89.1...v0.89.2) (2020-11-06)




### Bug Fixes:

* forgot to change refs to uploaders

## [v0.89.1](https://git.inhji.de/inhji/akedia/compare/v0.89.0...v0.89.1) (2020-11-06)




### Bug Fixes:

* clean up http

* warnings

* prettier build scripts

### Refactors:

* move mention model to webmentions module

* move avatar/cover uploaders to accounts

## [v0.89.0](https://git.inhji.de/inhji/akedia/compare/v0.88.0...v0.89.0) (2020-11-06)




### Features:

* add release tasks for migrations

## [v0.88.0](https://git.inhji.de/inhji/akedia/compare/v0.87.1...v0.88.0) (2020-11-05)




### Features:

* show jobs in queue

* replace que with oban

## [v0.87.1](https://git.inhji.de/inhji/akedia/compare/v0.87.0...v0.87.1) (2020-11-04)




### Bug Fixes:

* catch errors in context worker

* allow context without content, for image only posts

* add future body class scheme-dark for manual switching

* remove weather configs

## [v0.87.0](https://git.inhji.de/inhji/akedia/compare/v0.86.0...v0.87.0) (2020-11-03)




### Features:

* clean up and moar deisgn

* update to phoenix 1.5 and frens

## [v0.86.0](https://git.inhji.de/inhji/akedia/compare/v0.85.0...v0.86.0) (2020-11-03)




### Features:

* homepage design tweaks

## [v0.85.0](https://git.inhji.de/inhji/akedia/compare/v0.84.1...v0.85.0) (2020-11-02)




### Features:

* cleaner post meta

* improve styles for blockquote, logo, media, code blocks

* add Poppins as display font, Fira Code as code font

### Bug Fixes:

* post assigns

* remove unused tagged action

* remove unused tagged template

* add gitconfig

* add json as prism language

### Refactors:

* clean up and minor style tweaks

* split up feed into entity_feed and post_feed

* delete a lot of obsolete shit

## [v0.84.1](https://git.inhji.de/inhji/akedia/compare/v0.84.0...v0.84.1) (2020-11-02)




### Bug Fixes:

* move uploads over static asset directive in endpoint

## [v0.84.0](https://git.inhji.de/inhji/akedia/compare/v0.84.0...v0.84.0) (2020-11-02)




### Features:

* add git_ops
