# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'bower_components', 'font-awesome', 'fonts')
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'bower_components', 'jquery-ui', 'themes', 'base')
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'bower_components', 'jquery-ui', 'themes', 'ui-lightness')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile << proc do |path|
  path =~ %r{font-awesome/fonts} && File.extname(path).in?(['.otf', '.eot', '.svg', '.ttf', '.woff'])
end

Rails.application.config.assets.precompile << proc do |path|
  path =~ %r{jquery-ui/themes/(base|ui-lightness)} && File.extname(path).in?(['.png'])
end
