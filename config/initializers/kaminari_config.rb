Kaminari.configure do |config|
  config.default_per_page = 9
  config.param_name = :page
  config.page_method_name = :page
  config.window = 1

  # config.outer_window = 0
  # config.left = 0
  # config.right = 0
end
