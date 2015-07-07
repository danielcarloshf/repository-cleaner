#!/usr/bin/env ruby

require 'json'
require 'curb'

module Search
    
    # Find repositories on GitHub for a given language. Results are sorted by the number of stars.
    def Search.find_repositories(lang)
        
        repositories = Hash.new
        
        url = 'https://api.github.com/search/repositories?q=fork:false+language:'+ lang +'+stars:>=1000'
            
        response = Curl::Easy.http_get(url) do |curl|
            curl.headers['User-Agent'] = 'aserg.labsoft.dcc.ufmg.br'
            curl.headers['Accept'] = 'application/json'
            curl.headers['Content-Type'] = 'application/json'
            curl.headers['Api-Version'] = '2.2'
            curl.ssl_verify_peer = false
        end
        
        result = JSON.parse(response.body)
        total = result['total_count'].to_i
        puts "#{total} repositories found."
        num_pages = (total/10.0).ceil
        
        (1..num_pages).each do |page|
            url = 'https://api.github.com/search/repositories?q=fork:false+language:'+ lang \
                + '+stars:>=1000&sort=stars&order=desc&page='+ page.to_s +'&per_page=10'
                
            response = Curl::Easy.http_get(url) do |curl|
                curl.headers['User-Agent'] = 'aserg.labsoft.dcc.ufmg.br'
                curl.headers['Accept'] = 'application/json'
                curl.headers['Content-Type'] = 'application/json'
                curl.headers['Api-Version'] = '2.2'
                curl.ssl_verify_peer = false
            end
            
            result = JSON.parse(response.body)
            result['items'].each do |r|
                repositories[r['name']] = r['clone_url']
            end
        end
        
        repositories
    end

end