# Phrasing!

1. gem install phrasing

2. rake copycat:instal

3. rake db:migrate

4. must have a current_user method

5. add to application.js file:
	//= require bootstrap-editable
	//= require bootstrap-editable-rails

6. add to your layout file: ( most of the time its your application.html)
	= stylesheet_link_tag "phrasing" if current_user
	
7. Start with adding your phrases w/ phrase('my-first-phrase')

# Current user

Phrasing expects that your view helpers have a <tt>current_user</tt> method defined.