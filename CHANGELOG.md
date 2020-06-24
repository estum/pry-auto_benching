# CHANGELOG

## v3.2.1

* Fix a silly error where `Moment` was defined under `Object` instead of  
  `Pry::AutoBenching`.

## v3.2.0

* Add `lib/pry-auto_benching/moment.rb`.

* Switch to using `require_relative` for files belonging to `pry-auto_benching.rb`.

## v3.1.0

* Align the index, duration, and line of input in the output of
 `auto-benching --past`.

* Improve `auto-benching --past` by modifying its output.  

* Fix a typo shown when choosing an invalid target display.

## v3.0.0

* Remove `:output` as a target display, and the related code that supported    
 `:output` as a target display.

## v2.10.5

* Doc updates

## v2.10.4

* Doc updates

## v2.10.3

* Doc updates

## v2.10.2

* Prevent an exception from being raised when running `auto-benching --version`.

## v2.10.1

* Fix a typo in write_duration lambda that didn't mention 'none' as a valid
  value for `_pry_.config.auto_benching.target_display`

## v2.10.0

* Add 'none' as a possible target display.
  When chosen benchmark results are not written to a display but are still
  recorded and can be viewed on demand by running `auto-benching --past`.

## v2.9.1

* Fix a bug where `MomentList` would not cycle oldest entries first.

## v2.9.0

* Add '--target-display' option (shorthand: '-t') to the `auto-benching` command.  
 The option is for changing where benchmark results are written to.

* Accept 'output' and 'prompt' as valid values for `Pry.config.auto_benching.target_display`,
  in addition to the already accepted values `:output` and `:prompt`.
