Phrasing.setup do |config|
  config.route = 'phrasing'

  # List all the model attributes you wish to edit with Phrasing, example:
  # config.whitelist = ["Post.title", "Post.description"]
  config.whitelist = []

  # You can whitelist all models, but it's not recommended.
  # Read here: https://github.com/infinum/phrasing#security
  config.allow_update_on_all_models_and_attributes = false
end