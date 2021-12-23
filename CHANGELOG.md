# Changelog

## [4.4.0](https://github.com/infinum/phrasing/tree/v4.4.0) (2021-12-23)
[Full Changelog](https://github.com/infinum/phrasing/compare/v4.3.2...v4.4.0)

### Enhancements

- Bump nokogiri version from 1.10.4 to 1.12.5 due to CVEs

## [4.3.1](https://github.com/infinum/phrasing/tree/v4.3.1) (2019-09-03)
[Full Changelog](https://github.com/infinum/phrasing/compare/v4.3.0...v4.3.1)

### Enhancements

- Bump nokogiri version from 1.8.3 to 1.10.4 due to [security vulnerability](https://github.com/sparklemotion/nokogiri/issues/1915)

## [4.3.2](https://github.com/infinum/phrasing/tree/v4.3.2) (2020-10-30)
[Full Changelog](https://github.com/infinum/phrasing/compare/v4.3.1...v4.3.2)

### Bugfixes

- Send `edit_mode_enabled` as parameter and reject phrasing update if not `true` - fixes issue [#90](https://github.com/infinum/phrasing/issues/90)

## [4.3.1](https://github.com/infinum/phrasing/tree/v4.3.1) (2019-09-03)
[Full Changelog](https://github.com/infinum/phrasing/compare/v4.3.0...v4.3.1)

### Enhancements

- Bump nokogiri version from 1.8.3 to 1.10.4 due to [security vulnerability](https://github.com/sparklemotion/nokogiri/issues/1915)

## [4.3.0](https://github.com/infinum/phrasing/tree/v4.3.0) (2019-06-13)
[Full Changelog](https://github.com/infinum/phrasing/compare/v4.2.1...v4.3.0)

### Enhancements

- Add support for Rails 6
- Remove jquery.turbolinks fix suggestion

## [4.2.1](https://github.com/infinum/phrasing/tree/v4.2.1) (2018-11-05)
[Full Changelog](https://github.com/infinum/phrasing/compare/v4.2.0...v4.2.1)

### Enhancements

- Fix linear-gradient syntax to be W3C compliant.

## [4.2.0](https://github.com/infinum/phrasing/tree/v4.2.0) (2018-09-07)
[Full Changelog](https://github.com/infinum/phrasing/compare/v4.1.0...v4.2.0)

### Enhancements

- bundler-audit reported that there are DoS and RCE vulnerabilities in nokogiri:

```
Name: nokogiri
Version: 1.6.8.1
Advisory: CVE-2017-9050
Criticality: Unknown
URL: https://github.com/sparklemotion/nokogiri/issues/1673
Title: Nokogiri gem, via libxml, is affected by DoS and RCE vulnerabilities
Solution: upgrade to >= 1.8.1

Name: nokogiri
Version: 1.6.8.1
Advisory: CVE-2018-8048
Criticality: Unknown
URL: https://github.com/sparklemotion/nokogiri/pull/1746
Title: Revert libxml2 behavior in Nokogiri gem that could cause XSS
Solution: upgrade to >= 1.8.3
```

- Bumped nokogiri to 1.8.3.

## [4.1.0](https://github.com/infinum/phrasing/tree/v4.1.0) (2018-05-17)
[Full Changelog](https://github.com/infinum/phrasing/compare/v4.0.0...v4.1.0)

### Bugfixes

- Fix generated migration files for Rails 5

```
Directly inheriting from ActiveRecord::Migration is not supported. Please specify the Rails release the migration was written for.
```

- Fixed Rails 5.2 deprecation issue with `class_name`:

```
A class was passed to :class_name but we are expecting a string.
```

## [4.0.0](https://github.com/infinum/phrasing/tree/v4.0.0) (2018-02-27)
[Full Changelog](https://github.com/infinum/phrasing/compare/v3.2.10...v4.0.0)

### Breaking changes

#### Separation of I18n and Phrasing:

Phrasing no longer does monkeypatching over the I18n gem, so the I18n and Phrasings behaviours are completely separate.
When using the I18n.t() method, Phrasing will no longer copy the data from the translations file and continue to use translations from the database.

However, when using the phrase(key) method, if the key doesn't currently exist in the PhrasingPhrase table, it will do a lookup in the translations file and copy the data from there to the database.

#### Interpolation

The interpolation option has been kicked out.

The problem with the interpolation option is that most clients won't understand what's happening when they see something like "Hi, my name is %{name}" once they are editing data.

If they try to erase parts of it, the developer also might end up being confused and the UI might get broken or at least ugly for some time until the developer fixes the issue.

#### Loading asset dependencies

From phrasing v4.0.0rc3, add your jquery files manually:

```javascript
//= require jquery
//= require jquery_ujs
//= require phrasing
```

#### Switching rake tasks with Rails generators

Since Rails comes with outofbox generators that enable easy existing file detection and similar behaviors, Phrasing 4 will use Rails generators instead of the old rake tasks.

To run the initial setup generator, just do: `rails generate phrasing`

## [3.2.10](https://github.com/infinum/phrasing/tree/v3.2.10) (2015-10-02)
[Full Changelog](https://github.com/infinum/phrasing/compare/v3.2.9...v3.2.10)

### Enhancements

- Change order parameters in PhrasingPhrases#index to support SQLServer.

## [3.2.9](https://github.com/infinum/phrasing/tree/v3.2.9) (2015-01-07)
[Full Changelog](https://github.com/infinum/phrasing/compare/v3.2.8...v3.2.9)

### Enhancements

- Require only haml, not haml-rails.

## [3.2.8](https://github.com/infinum/phrasing/tree/v3.2.8) (2015-01-06)
[Full Changelog](https://github.com/infinum/phrasing/compare/v3.2.7...v3.2.8)

### Bugfixes

- Fix confirm dialogs when deleting phrases and phrase versions.

## [3.2.7](https://github.com/infinum/phrasing/tree/v3.2.7) (2014-10-03)
[Full Changelog](https://github.com/infinum/phrasing/compare/v3.2.6...v3.2.7)

### Enhancements

- Add a config option to set a parent controller to Phrasing Engine Controllers.

## [3.2.6](https://github.com/infinum/phrasing/tree/v3.2.6) (2014-09-15)
[Full Changelog](https://github.com/infinum/phrasing/compare/v3.2.5...v3.2.6)

### Enhancements

- Show Home page only when view responds to :root_path.

## [3.2.5](https://github.com/infinum/phrasing/tree/v3.2.5) (2014-06-17)
[Full Changelog](https://github.com/infinum/phrasing/compare/v3.2.4...v3.2.5)

### Enhancements

- Added index for phrasing_phrase_id in versions table.

## [3.2.4](https://github.com/infinum/phrasing/tree/v3.2.4) (2014-05-08)
[Full Changelog](https://github.com/infinum/phrasing/compare/v3.2.3...v3.2.4)

### Enhancements

- Changed InlineHelper#phrasing_polymorphic_url to use rails path helper.

## [3.2.3](https://github.com/infinum/phrasing/tree/v3.2.3) (2014-03-03)
[Full Changelog](https://github.com/infinum/phrasing/compare/v3.2.2...v3.2.3)

### Enhancements

- Exctracted import/export functionality to Phrasing::Serializer. Importer now accepts nested yaml files, just like the ones from /config/locales.

## [3.2.2](https://github.com/infinum/phrasing/tree/v3.2.2) (2014-02-19)
[Full Changelog](https://github.com/infinum/phrasing/compare/v3.2.1...v3.2.2)

### Enhancements

- Scope option for phrases added:

scope: 'homepage.footer' # add scopes just like you would w/ I18.n. If the first argument is 'test', than the key would be 'homepage.footer.test'

- Change in generated migration file:

:phrasing_phrase_id changed from t.string to t.integer.

- Change in PhrasingPhrasesController#index:

Fix order clause so it runs on Rails 3.2 and MySQL

## [3.2.1](https://github.com/infinum/phrasing/tree/v3.2.1) (2014-01-29)
[Full Changelog](https://github.com/infinum/phrasing/compare/v3.2.0...v3.2.1)

### Enhancements

- Created PhrasingPhrase.search_i18n_and_create_phrase for proper lookup of translations in config/locales.

## [3.2.0](https://github.com/infinum/phrasing/tree/v3.2.0) (2014-01-16)

### Enhancements

- New design for edit mode bubble.
- Non breaking IE9 javascript fix.
