# Phrasing!

A inline editing gem, a small CMS substitute for editing live websites. 
It is stacked upon two other gems, Copycat and Bootstrap-editable-rails, immensely using their codes, so thank you to the authors and all the contributors! 

## Requirements

1. Phrasing expects that your view helpers have a <tt>current_user</tt> method defined.
	
2. Must install the bootstrap gem.

## How to use phrasing?

1. <tt> gem install phrasing </tt>

2. <tt> rake copycat:install </tt>

	This will create a migration file and a config file. The config file will be placed in the <tt>config/initializers/copycat.rb</tt> and you will be able to change your HTTP basic auth username and password for editing the live content. 

3. <tt> rake db:migrate </tt>

4. Include the javascript files (most often its your application.js file). It should look something like this:

	```javascript
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require bootstrap-editable
//= require bootstrap-editable-rails
//= require_tree .
	```

	On production you can include `bootstrap-editable.min` instead of `bootstrap-editable`

5. Add to your layout file ( most of the time its your application.html):

	<tt>= stylesheet_link_tag "phrasing" if current_user</tt>
	
6. If you haven't done it yet, require <tt>bootstrap</tt> in your layout file:

	<tt>//= require bootstrap</tt>

7. Start with adding your phrases simply by writting in your view file:

	<tt>phrase('my-first-phrase')</tt>
