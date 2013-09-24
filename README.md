# Phrasing!

![Phrasing](http://www.miataturbo.net/attachments/miata-parts-sale-trade-5/74257-lots-leftovers-near-boston-archer-phrasing2-300x225-jpg?dateline=1366600534)

Phrasing is a gem for live editing phrases (copy) on websites.

## Requirements

1. Phrasing expects that your view helpers have a <tt>current_user</tt> method defined.

2. Must install the bootstrap gem.

## Installation

1. <tt> gem install phrasing </tt>

2. <tt> rake phrasing:install </tt>

This will create a migration file and a config file. The config file will be placed in the <tt>config/initializers/phrasing.rb</tt> and you will be able to change your HTTP basic auth username and password for editing the live content. 

3. <tt> rake db:migrate </tt>

4. Include the javascript files (most often its your application.js file). It should look something like this:

    //= require jquery
    //= require jquery_ujs
    //= require bootstrap
    //= require bootstrap-editable
    //= require bootstrap-editable-rails
    //= require_tree .

If using bootstrap 3 require <tt>bootstrap-editable-3</tt> instead of <tt>bootstrap-editable</tt>

5. Add to your layout file ( most of the time its your application.html):

   = stylesheet_link_tag "phrasing" if current_user


6. If you haven't done it yet, require <tt>bootstrap</tt> in your css/scss layout file:

   //= require bootstrap


## How to use phrasing?

Start with adding your phrases simply by writting in your view file:


	= phrase('my-first-phrase')

Apart from editing phrases (basically, Rails translations) you can also inline edit your models attributes, just use the `model_phrase` method:

  	= model_phrase(@post, :title)

Where @post is a object with a title attribute.

## Security

Since Phrasing can be used to update any attribute in any table (using the model_phrase method), special care must be taken into consideration from a security standpoint.

By default, Phrasing doesn't allow updating of any attribute apart from <<t>PhrasingPhrase.value</tt>. To be able to work with other attributes, you need to whitelist them.

In the <tt>config/initializers/phrasing.rb</tt> file you can whitelist your model attributes like this:


	Phrasing.white_list = ["Project.description", "Project.name"]


or you can whitelist all of them (not recommended) with:

	Phrasing.allow_update_on_all_models_and_attributes = true

## Authors

Copyright (c) 2013, Infinum

Phrasing relies heavily (or is built) on two other gems: Copycat and Bootstrap-editable-rails. So thank you to the authors and all the contributors! 
