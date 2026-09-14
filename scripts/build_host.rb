# scripts/build_host.rb
# frozen_string_literal: true

require "fileutils"
require "pathname"

require_relative "../lib/active_admin/themes/recipes/v3"

root = Pathname.new(__dir__).parent
framework = Gem::Specification.find_by_name("activeadmin").full_gem_path
output = root.join("spec/host/app/assets/builds")
FileUtils.mkdir_p(output)
FileUtils.mkdir_p(root.join("tmp"))
root.join("tmp/active_admin_v3.css").binwrite(ActiveAdmin::Themes::Recipes::V3.source)
input = root.join("tmp/host.css")
input.write(<<~CSS)
  @import "../node_modules/tailwindcss/index.css";
  @import "./active_admin_v3.css";
  @plugin "../node_modules/@activeadmin/activeadmin/plugin.js";
  @source "#{framework}/app";
  @source "#{framework}/lib/active_admin";
  @source "../spec/host/app";
  @custom-variant dark (&:where(.dark, .dark *));
CSS
abort "CSS build failed" unless system("node", root.join("node_modules/@tailwindcss/cli/dist/index.mjs").to_s,
                                       "-i", input.to_s, "-o", output.join("active_admin.css").to_s, "--minify")
