# Phrasing!

[![Build Status](https://travis-ci.org/infinum/phrasing.png)](https://travis-ci.org/infinum/phrasing)

![Phrasing](http://www.miataturbo.net/attachments/miata-parts-sale-trade-5/74257-lots-leftovers-near-boston-archer-phrasing2-300x225-jpg?dateline=1366600534)

Phrasing is a gem for live editing phrases (copy) on websites.

**Notice:** If using Phrasing version 3, checkout the [old README](https://github.com/infinum/phrasing/blob/new-release-4/README-3.md).

## Installation

Include the gem in your Gemfile

```ruby
gem "phrasing"
```

Bundle the Gemfile

```shell
bundle install
```

Run the install script which will create a migration file and a config file.

```shell
rails generate phrasing
```

Migrate your database
```shell
rake db:migrate
```

## Setup

The rake task will also generate <tt>phrasing_helper.rb</tt> in your <tt>app/helpers</tt> folder. Here you will need to implement the <tt>can_edit_phrases?</tt> method. Use this to hook-up your existing user authentication system to work with Phrasing.

For example:

```ruby
module PhrasingHelper

  def can_edit_phrases?
    current_user.is_admin?
  end

end
```
Include the phrasing **html** initializer at the top of your application layout file.

```haml
= render 'phrasing/initializer'
```

Include the required **javascript** files:

```javascript
//= require phrasing
```

Include the required **javascript** files:

```javascript
//= require jquery
//= require jquery_ujs
//= require jquery.cookie
//= require phrasing
```

Include the required **stylesheet** file:

```css
*= require phrasing
```

## How to use phrasing?

You can start adding new phrases by simply adding them in your view file:

	= phrase('my-first-phrase')

Aside from editing phrases (basically, Rails translations) you can also edit model attributes inline. Use the same `phrase` method, with the first attribute being the record in question, and the second one the attribute you wish to make editable:

  	= phrase(@post, :title)

In the above example, <tt>@post</tt> is the record with a <tt>title</tt> attribute.

## Security

Since Phrasing can be used to update any attribute in any table (using the model_phrase method), special care must be taken into consideration from a security standpoint.

By default, Phrasing doesn't allow updating of any attribute apart from <tt>PhrasingPhrase.value</tt>. To be able to work with other attributes, you need to whitelist them.

In the <tt>config/initializers/phrasing.rb</tt> file you can whitelist your model attributes like this:

```ruby
config.white_list = ["Post.title", "Post.body"]
```

or you can whitelist all of them (not recommended) with:

```ruby
config.allow_update_on_all_models_and_attributes = true
```

## Turbolinks

If you're experiencing problems with Rails apps using Turbolinks, include the [jQuery-turbolinks](https://github.com/kossnocorp/jquery.turbolinks) gem in your application and simply require it in the following order:

```javascript
//= require jquery
//= require jquery_ujs
//= require jquery.cookie
//= require jquery.turbolinks
//= require phrasing
//= require turbolinks
```

## Phrasing Appearance

The `phrase` view helper can take the `options` hash as the last parameter. Features:
```ruby
url: custom_url # point Phrasing to other actions in other controllers
inverse: true # change the hovered background and underline colors to better fit darker backgrounds
class: custom_class # add custom CSS classes to your phrases to change the appearance of phrases in your application
scope: 'homepage.footer' # add scopes just like you would w/ I18.n. If the first argument is 'test', than the key would be 'homepage.footer.test'
```

## Phrasing Autosave

By default, Phrasing autosaves after 2.5 seconds. In the <tt>config/initializers/phrasing.rb</tt> file, this feature can be toggled:

```ruby
Phrasing.autosave = false
```

This will create a button for the editor to save all alterations on the current page.


## Credits

Phrasing is maintained and sponsored by
[Infinum] (http://www.infinum.co).

![Infinum](https://www.infinum.co/assets/logo_pic-2e19713f50692ed9b0805b199676c19a.png)

Phrasing leverages parts of [Copycat](https://github.com/Zorros/copycat) and [ZenPen](https://github.com/tholman/zenpen/tree/master/).

## License

Phrasing is Copyright © 2013 Infinum. It is free software, and may be redistributed under the terms specified in the LICENSE file.
