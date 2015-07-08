#!/usr/bin/env ruby

require 'json'
require 'curb'

module Search
    
    # Find repositories on GitHub for a given language. Results are sorted by the number of stars.
    def Search.find_repositories(username, password, lang)
        
        repositories = Hash.new
        
        url = 'https://api.github.com/search/repositories?q=fork:false+language:'+ lang +'+stars:>=1000'
                    
        request = Curl::Easy.new(url)
        request.http_auth_types = :basic
        request.username = username
        request.password = password
        request.ssl_verify_peer = false
        request.headers['User-Agent'] = 'aserg.labsoft.dcc.ufmg.br'
        request.headers['Accept'] = 'application/json'
        request.headers['Content-Type'] = 'application/json'
        request.headers['Api-Version'] = '2.2'
        
        request.perform
        result = JSON.parse(request.body_str)
        total = result['total_count'].to_i
        puts "#{total} repositories found."
        num_pages = (total/100.0).ceil
        
        (1..num_pages).each do |page|
            url = "https://api.github.com/search/repositories?q=fork:false+language:"+ lang \
                + "+stars:>=1000&sort=stars&order=desc&page=" + page.to_s + "&per_page=100"
            
            puts url
            
            request.url = url
            request.perform
            result = JSON.parse(request.body_str)
            
            begin
                result['items'].each do |r|
                    repositories[r['name']] = r['clone_url']
                end
            rescue Exception
            end
        end
        
        puts "Got #{repositories.length} repositories clone url's."
        repositories
    end

end