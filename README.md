# Phrasing!

[![Build Status](https://travis-ci.org/infinum/phrasing.png)](https://travis-ci.org/infinum/phrasing)

Phrasing is a gem for live editing phrases (copy) on websites.

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
Include the phrasing **html** initializer right below the `<body>` tag in your application layout file.

```
<%= render 'phrasing/initializer' %>
```

Include the required **javascript** files:

```javascript
//= require phrasing
```

Include the required **javascript** files:

```javascript
//= require jquery
//= require jquery_ujs
//= require phrasing
```

Include the required **stylesheet** file:

```css
*= require phrasing
```

## How to use phrasing?

You can start adding new phrases by simply adding them in your view file:

	<%= phrase('my-first-phrase') %>

If you want the key not to be the default phrase, you can define one like here:

	<%= phrase('my-first-phrase',default: 'default phrase') %>

Aside from editing phrases (basically, Rails translations) you can also edit model attributes inline. Use the same `phrase` method, with the first attribute being the record in question, and the second one the attribute you wish to make editable:

    <%= phrase(@post, :title) %>

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

If you're using Turbolinks make sure the phrasing gem is required after it:

```javascript
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require phrasing
```

## Phrasing Appearance

The `phrase` view helper can take the `options` hash as the last parameter. Features:
```ruby
url: custom_url # point Phrasing to other actions in other controllers
inverse: true # change the hovered background and underline colors to better fit darker backgrounds
class: custom_class # add custom CSS classes to your phrases to change the appearance of phrases in your application
scope: 'homepage.footer' # add scopes just like you would w/ I18.n. If the first argument is 'test', than the key would be 'homepage.footer.test'
```

## Credits

Phrasing is maintained and sponsored by
[Infinum](http://www.infinum.co).

<img src="https://infinum.co/infinum.png" width="264">

Phrasing leverages parts of [Copycat](https://github.com/Zorros/copycat) and [ZenPen](https://github.com/tholman/zenpen/tree/master/).

## License

Phrasing is Copyright © 2013 Infinum. It is free software, and may be redistributed under the terms specified in the LICENSE file.
