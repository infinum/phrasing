# Phrasing Change Log

## 3.2.10 (October 2nd, 2015)

Change order parameters in PhrasingPhrases#index to support SQLServer.

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
