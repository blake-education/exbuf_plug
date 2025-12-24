# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.1] - 2025-12-24

### Changed

- bump protobuf dependency to 0.15.0 for compatibility with blake_protobufs

## [2.0.0] - 2025-01-29

### Added

- bump Elixir to 1.16.3 and Erlang to 26.2.5.6 for testing
- change package dependency from `ex_protobufs` to `protobufs`, this is a potentially breaking change:
  - when decoding, the nested complex types are now the relevant struct, not a map
  - run `mix deps.unlock --unused` to clean up your `mix.lock` file.

## [1.0.0] - 2024-07-05

### Added

- Add support for multipart form data

## [0.1.0] - 2019-02-07

### Changed

- removing the need for a base64 string, and instead deal with raw binary

[2.0.1]: https://github.com/olivierlacan/keep-a-changelog/compare/2.0.0...2.0.1
[2.0.0]: https://github.com/olivierlacan/keep-a-changelog/compare/1.0.0...2.0.0
[1.0.0]: https://github.com/olivierlacan/keep-a-changelog/compare/0.1.0...1.0.0
[0.1.0]: https://github.com/olivierlacan/keep-a-changelog/releases/tag/0.1.0
