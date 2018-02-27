# Phrasing Change Log

## 4.0.0 (February 27th 2018)

### Separation of I18n and Phrasing:

Phrasing no longer does monkeypatching over the I18n gem, so the I18n and Phrasings behaviors are completely separate.
When using the I18n.t() method, Phrasing will no longer copy the data from the translations file and continue to use translations from the database.

However, when using the phrase(key) method, if the key doesn't currently exist in the PhrasingPhrase table, it will do a lookup in the translations file and copy the data from there to the database.

### Interpolation

The interpolation option has been kicked out.

The problem with the interpolation option is that most clients won't understand what's happening when they see something like "Hi, my name is %{name}" once they are editing data.

If they try to erase parts of it, the developer also might end up being confused and the UI might get broken or at least ugly for some time until the developer fixes the issue.

### Loading asset dependencies

From phrasing v4.0.0rc3, add your jquery files manually:

```javascript
//= require jquery
//= require jquery_ujs
//= require phrasing
```

## Switching rake tasks with Rails generators

Since Rails comes with outofbox generators that enable easy existing file detection and similar behaviors, Phrasing 4 will use Rails generators instead of the old rake tasks.

To run the initial setup generator, just do: `rails generate phrasing`

## 3.2.9 (January 7th, 2015)

Require only haml, not haml-rails.

## 3.2.8 (January 6th, 2015)

Fix confirm dialogs when deleting phrases and phrase versions.

## 3.2.7 (October 3rd, 2014)

Add a config option to set a parent controller to Phrasing Engine Controllers.

## 3.2.6 (September 15th, 2014)

Show Home page only when view responds to :root_path.

## 3.2.5 (June 17th, 2014)

Added index for phrasing_phrase_id in versions table.

## 3.2.4 (May 8th, 2014)

Changed InlineHelper#phrasing_polymorphic_url to use rails path helper.

## 3.2.3 (March 3rd, 2014)

Exctracted import/export functionality to Phrasing::Serializer. Importer now accepts nested yaml files, just like the ones from /config/locales.

## 3.2.2 (Feb 19th, 2014)

Scope option for phrases added:

scope: 'homepage.footer' # add scopes just like you would w/ I18.n. If the first argument is 'test', than the key would be 'homepage.footer.test'

Change in generated migration file:

:phrasing_phrase_id changed from t.string to t.integer.

Change in PhrasingPhrasesController#index:

Fix order clause so it runs on Rails 3.2 and MySQL

## 3.2.1 (Jan 29th, 2014)

Created PhrasingPhrase.search_i18n_and_create_phrase for proper lookup of translations in config/locales.

## 3.2.0 (Jan 16th, 2014)

New design for edit mode bubble.

Non breaking IE9 javascript fix.
