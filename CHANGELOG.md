# Change Log

## v3.2.4 (May 8th, 2014)

Changed InlineHelper#phrasing_polymorphic_url to use rails path helper.

## v3.2.3 (March 3rd, 2014)

Exctracted import/export functionality to Phrasing::Serializer. Importer now accepts nested yaml files, just like the ones from /config/locales.

## v3.2.2 (Feb 19th, 2014)

Scope option for phrases added:

scope: 'homepage.footer' # add scopes just like you would w/ I18.n. If the first argument is 'test', than the key would be 'homepage.footer.test'

Change in generated migration file:

:phrasing_phrase_id changed from t.string to t.integer.

Change in PhrasingPhrasesController#index:

Fix order clause so it runs on Rails 3.2 and MySQL 

## v3.2.1 (Jan 29th, 2014)

Created PhrasingPhrase.search_i18n_and_create_phrase for proper lookup of translations in config/locales.

## v3.2.0 (Jan 16th, 2014)

New design for edit mode bubble.

Non breaking IE9 javascript fix.

