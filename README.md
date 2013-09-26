# Phrasing!

![Phrasing](http://www.miataturbo.net/attachments/miata-parts-sale-trade-5/74257-lots-leftovers-near-boston-archer-phrasing2-300x225-jpg?dateline=1366600534)

Phrasing is a gem for live editing phrases (copy) on websites.

## Requirements

1. Phrasing expects that your view helpers have a <tt>current_user</tt> method defined.

2. Must install the bootstrap gem.

## Installation

Include the gem in your Gemfile

```ruby
gem "phrasing"
```

Run the install script:

```ruby
rake phrasing:install
```

This will create a migration file and a config file. The config file will be placed in the <tt>config/initializers/phrasing.rb</tt> and you will be able to change your HTTP basic auth username and password for editing the live content. 

Migrate your database
```ruby
rake db:migrate
```

## Setup

Include the required javascript files (most often its your application.js file). It should look something like this:

```javascript
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require bootstrap-editable
//= require bootstrap-editable-rails
//= require_tree .
```

If youre running Bootstrap 3, please require <tt>bootstrap-editable-3</tt> instead of <tt>bootstrap-editable</tt>

Include the required stylesheet file (most often its your application.css file). It should look something like this:

```haml
//= require phrasing
```

Require the <tt>bootstrap</tt> stylesheet in your css/scss layout file:

```css
//= require bootstrap
```

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

```ruby
Phrasing.white_list = ["Project.description", "Project.name"]
```

or you can whitelist all of them (not recommended) with:

```ruby
Phrasing.allow_update_on_all_models_and_attributes = true
```

## Authors

Copyright (c) 2013, Infinum

Phrasing relies heavily (or is built) on two other gems: Copycat and Bootstrap-editable-rails. So thank you to the authors and all the contributors! 
