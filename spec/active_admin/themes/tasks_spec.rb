# spec/active_admin/themes/tasks_spec.rb
# frozen_string_literal: true

require "spec_helper"

require "fileutils"
require "rake"
require "tmpdir"

require "active_admin/themes/tasks"

# These examples exercise named tasks rather than a library class API.
RSpec.describe "Explicit recipe tasks" do # rubocop:disable RSpec/DescribeClass
  let(:root) { Dir.mktmpdir("theme-tasks") }

  before { Rake::Task.tasks.each(&:reenable) }
  after { FileUtils.remove_entry(root) }

  it "lists the catalog" do
    expect { Rake::Task["activeadmin_themes:list"].invoke }.to output(/v3: ActiveAdmin V3/).to_stdout
  end

  it "requires explicit arguments" do
    expect { Rake::Task["activeadmin_themes:install"].invoke }.to raise_error(ArgumentError)
  end

  it "requires an explicit entrypoint" do
    expect { Rake::Task["activeadmin_themes:install"].invoke("v3") }.to raise_error(ArgumentError)
  end

  it "installs and reports status in the host directory" do
    File.write(File.join(root, "admin.css"), '@import "tailwindcss";')
    Dir.chdir(root) do
      expect { Rake::Task["activeadmin_themes:install"].invoke("v3", "admin.css") }.to output(/created/).to_stdout
      expect { Rake::Task["activeadmin_themes:status"].invoke("v3", "admin.css") }.to output(/identical/).to_stdout
    end
  end
end
