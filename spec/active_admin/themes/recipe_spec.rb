# spec/active_admin/themes/recipe_spec.rb
# frozen_string_literal: true

require "spec_helper"

require "fileutils"
require "tmpdir"

require "active_admin/themes/recipe"

RSpec.describe ActiveAdmin::Themes::Recipe do
  subject(:recipe) { described_class.new(root: root, entrypoint: "admin.css", active_admin_version: "4.0.0.beta22") }

  let(:root) { Dir.mktmpdir("theme-recipe") }

  before { File.write(File.join(root, "admin.css"), '@import "tailwindcss";') }
  after { FileUtils.remove_entry(root) }

  it "installs a packaged recipe once and reports repeat installation" do
    expect(recipe.status).to eq(:missing)
    expect(recipe.install).to eq(:created)
    expect(recipe.install).to eq(:identical)
    expect(recipe.status).to eq(:identical)
  end

  it "preserves customization and the host entrypoint" do
    recipe.install
    File.write(File.join(root, recipe.destination), "custom")
    expect { recipe.install }.to raise_error(described_class::Conflict)
    expect(File.read(File.join(root, "admin.css"))).to eq('@import "tailwindcss";')
  end

  it "reports explicit import and build instructions" do
    expect(recipe.instructions).to include('@import "./active_admin_v3.css";', "admin.css", "existing CSS build")
  end

  it "requires an existing entrypoint" do
    File.unlink(File.join(root, "admin.css"))
    expect { recipe }.to raise_error(ArgumentError, "styling entrypoint does not exist")
  end

  it "rejects a non-Tailwind entrypoint" do
    File.write(File.join(root, "admin.css"), "body {}")
    expect { recipe }.to raise_error(ArgumentError, "select the existing Tailwind CSS entrypoint")
  end

  it "rechecks a changed entrypoint before installing" do
    recipe
    File.write(File.join(root, "admin.css"), "body {}")
    expect { recipe.install }.to raise_error(ArgumentError)
    expect(Dir.children(root)).to eq(["admin.css"])
  end
end
