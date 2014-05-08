# Change Log

## v3.2.4 (8th of May 2014)

Changed InlineHelper#phrasing_polymorphic_url to use rails path helper.

## v3.2.3 (3rd of March 2014)

Exctracted import/export functionality to Phrasing::Serializer. Importer now accepts nested yaml files, just like the ones from /config/locales.

## v3.2.2 (19th of February 2014)

Scope option for phrases added:

scope: 'homepage.footer' # add scopes just like you would w/ I18.n. If the first argument is 'test', than the key would be 'homepage.footer.test'

Change in generated migration file:

:phrasing_phrase_id changed from t.string to t.integer.

Change in PhrasingPhrasesController#index:

Fix order clause so it runs on Rails 3.2 and MySQL 

## v3.2.1 (29th of January 2014)

Created PhrasingPhrase.search_i18n_and_create_phrase for proper lookup of translations in config/locales.

## v3.2.0 (16th of January 2014)

New design for edit mode bubble.

Non breaking IE9 javascript fix.

