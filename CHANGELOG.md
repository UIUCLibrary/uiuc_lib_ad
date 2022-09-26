## [0.2.4] - 2022-09-26

- Fixed issue when using explicity DN where an array would not be correctly setup.

## [0.2.3] - 2022-09-21

- Modified so that if multiple dns returned when looking for dn we'll process them all. (Note: we might want to make this behavoir configurable, as if there's two objects that have the same cn, but different dns the module user might want to log a warning or something. Not clear to me though that this would typically happen, especially if the module user is setting treebases correctly.) 

## [0.2.2] - 2022-09-08

- Made changes suggested by standard

## [0.2.1] - 2022-08-15 

- Added Configuration object. Will default to accessing environmental variables if value was not set.

## [0.2.0] - 2022-08-09

- Removed AD from ADSERVER

## [0.1.2] - 2022-08-08

- Added test cases (requires env variables to be set)
- Changed so ADSERVER and TREEBASE are environmental variables instead of a config file

## [0.1.1] - 2022-08-08

- Added dependencies to gemspec

## [0.1.0] - 2022-07-27

- Initial release: using bin/console works with basic is_member_of? lookup
