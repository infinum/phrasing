# Phrasing!

1. gem install phrasing

2. rake copycat:install

3. rake db:migrate

4. must have a current_user method

5.a) must have bootstrap in your app

5.b) your application.js file should look something like this:

```javascript
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require bootstrap-editable
//= require bootstrap-editable-rails
//= require_tree .
```

On production you can include `bootstrap-editable.min` instead of `bootstrap-editable`

6.a) add to your layout file: ( most of the time its your application.html)

= stylesheet_link_tag "phrasing" if current_user
	
6.b) add to your application.css.scss

//= require bootstrap
--------//= require bootstrap-editable

7.a) Restart your server after adding all of these assets!

7.b) Start with adding your phrases w/ phrase('my-first-phrase')

8. The username and password for the HTTP Basic authentification are placedin the config/initializers/copycat.rb file.
   If you are going to change them, remember that you should restart your server.

# Current user

Phrasing expects that your view helpers have a <tt>current_user</tt> method defined.