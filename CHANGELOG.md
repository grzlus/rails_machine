# Changelog

## Unreleased

### Fixed
- `valid_init_state` no longer raises `NoMethodError` when the state attribute is nil

### Breaking
- Minimum Ruby version raised to 3.0
- Minimum ActiveRecord version raised to 7.0
- `rails` dependency replaced with `activerecord` — consumers no longer get the full Rails stack as a transitive dependency

### Changed
- `enum` call updated to positional syntax required by ActiveRecord 7
- Test suite no longer requires a dummy Rails app — bootstrapped directly with ActiveRecord and SQLite in memory
- `rspec-rails` replaced with plain `rspec`
- Docker-based development environment added (`Dockerfile` + `compose.yml`)

## 0.0.7

### Fixed
- `init_state` validation

## 0.0.6

### Fixed
- Open-ended gem dependencies tightened

## 0.0.5

### Added
- `init_states` support — restrict which states are valid on record creation

### Fixed
- Transition validation renamed for clarity (`allowed_transition` → `allowed_state`)

## 0.0.2

### Added
- Explicit integer IDs on states
- Multiple state machines per model

## 0.0.1

- Initial release
