# Changes

This document contains instructions for upgrading from Phrasing version 3 to Phrasing version 4.

## Separation of I18n and Phrasing:

Phrasing no longer does monkeypatching over the I18n gem, so the I18n and Phrasings behaviors are completely separate.
When using the I18n.t() method, Phrasing will no longer copy the data from the translations file and continue to use translations from the database.

However, when using the phrase(key) method, if the key doesn't currently exist in the PhrasingPhrase table, it will do a lookup in the translations file and copy the data from there to the database.

## Interpolation

The interpolation option has been kicked out.

The problem with the interpolation option is that most clients won't understand what's happening when they see something like "Hi, my name is %{name}" once they are editing data.

If they try to erase parts of it, the developer also might end up being confused and the UI might get broken or at least ugly for some time until the developer fixes the issue.

## Loading asset dependencies

From phrasing v4.0.0rc3, add your jquery files manually:

```javascript
//= require jquery
//= require jquery_ujs
//= require jquery.cookie
//= require phrasing
```

## Switching rake tasks with Rails generators

Since Rails comes with outofbox generators that enable easy existing file detection and similar behaviors, Phrasing 4 will use Rails generators instead of the old rake tasks.

## HTML Sanitization

There is a posibility we might add html sanitization to prevent ugly copy-pasted html insertion as well as XSS attacks.