#!/usr/bin/ruby

require 'rugged'
require 'linguist'
require 'fileutils'

module Files

    # Create e returns an array with non-third-party files.
    def Files.only_first_party(path, language)
        repo = Rugged::Repository.new(path)
        project = Linguist::Repository.new(repo, repo.head.target_id)
        result = Array.new
        puts "--> Verifying files on \"#{path}\""
        project.breakdown_by_file.each do |lang, files|
        	if lang.downcase == language.downcase
        		files.each do |file|
        		    puts "\tFound: #{file}"
        		    result.push(file)
        		end
        	end
        end
        result  
    end
    
    # Create a folder without files rejected by Linguist.
    def Files.copy_with_path(files, origin, destination)
        FileUtils.mkdir_p(destination)
        puts "--> Directory \"#{destination}\" created!"
        files.each do |file|
            path = destination + File::SEPARATOR + file
            FileUtils.mkdir_p(path.rpartition(File::SEPARATOR).first)
            FileUtils.cp_r(origin + File::SEPARATOR + file, path)
            puts "\tCopy of \"#{file}\" done."
        end
    end
    
    # Remove a given directory.
    def Files.remove_cloned_repo(destination)
        FileUtils.rm_rf(destination)
        puts "--> Directory \"#{destination}\" deleted!"
    end
    
end