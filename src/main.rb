#!/usr/bin/env ruby
$LOAD_PATH << '.'

require 'clone.rb'
require 'files.rb'
require 'search.rb'

include Clone
include Files
include Search

destination = ARGV[0]
language = 'javascript'

puts "Searching repositories..."
Search.find_repositories(language).each_pair do |repo, clone_url|
    path = destination + File::SEPARATOR + repo
    puts "Cloning \"#{repo}\"..."
    Clone.git_clone(clone_url, path)
    puts "Selecting only first-party files..."
    files = Files.only_first_party(path, language)
    puts "Copying selected files..."
    Files.copy_with_path(files, path, path + '_src')
    puts "Removing \"#{path}\"..."
    Files.remove_cloned_repo(path)
end
puts "DONE"