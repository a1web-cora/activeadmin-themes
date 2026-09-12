# lib/active_admin/themes/tasks.rb
# frozen_string_literal: true

require "active_admin/themes/recipe"
require "rake"

# Hosts explicitly require this file in their Rakefile; library loading alone
# does not register Rails hooks, alter assets, or run an installation.
namespace :activeadmin_themes do
  desc "List available theme recipes"
  task :list do
    ActiveAdmin::Themes.registry.each { |theme| puts "#{theme.key}: #{theme.name} (recipe #{theme.recipe_version})" }
  end

  %i[install status].each do |operation|
    desc "#{operation.capitalize} a recipe; supply theme key and Tailwind entrypoint relative to the current directory"
    task operation, %i[theme entrypoint] do |_task, args|
      raise ArgumentError, "theme and entrypoint are required" unless args[:theme] && args[:entrypoint]

      recipe = ActiveAdmin::Themes::Recipe.new(
        root: Dir.pwd, entrypoint: args[:entrypoint], key: args[:theme],
        active_admin_version: Gem.loaded_specs.fetch("activeadmin").version.to_s
      )
      result = recipe.public_send(operation)
      puts "#{recipe.theme.key} recipe #{recipe.theme.recipe_version}: #{result} #{recipe.destination}"
      puts recipe.instructions
    end
  end
end
