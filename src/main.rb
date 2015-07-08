#!/usr/bin/env ruby
$LOAD_PATH << '.'

require 'io/console'
require 'clone.rb'
require 'files.rb'
require 'search.rb'

include Clone
include Files
include Search

destination = ARGV[0]
language = 'javascript'

print "GitHub username: "
username = STDIN.gets.chomp
print "Enter your password: "
password = STDIN.noecho(&:gets).chomp 
puts

puts "Searching repositories..."
Search.find_repositories(username, password, language).each_pair do |repo, clone_url|
    begin
        path = destination + File::SEPARATOR + repo
        puts "Cloning \"#{repo}\"..."
        Clone.git_clone(clone_url, path)
        puts "Selecting only first-party files..."
        files = Files.only_first_party(path, language)
        puts "Copying selected files..."
        Files.copy_with_path(files, path, path + '_src')
        puts "Removing \"#{path}\"..."
        Files.remove_cloned_repo(path)
    rescue Exception => msg
        puts msg
        puts "On #{repo}: #{clone_url}"
    end
end
puts "DONE"