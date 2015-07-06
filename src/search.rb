#!/usr/bin/env ruby

require 'json'
require 'curb'

module Search
    
    # Find repositories on GitHub for a given language. Results are sorted by the number of stars.
    def Search.find_repositories(lang)
        
        url = 'https://api.github.com/search/repositories?q=fork:false+language:'+ lang \
            + '&sort=stars&order=desc'
            
        response = Curl::Easy.http_get(url) do |curl|
            curl.headers['User-Agent'] = 'aserg.labsoft.dcc.ufmg.br'
            curl.headers['Accept'] = 'application/json'
            curl.headers['Content-Type'] = 'application/json'
            curl.headers['Api-Version'] = '2.2'
            curl.ssl_verify_peer = false
        end
        repositories = Hash.new
        result = JSON.parse(response.body)
        result['items'].each do |r|
            repositories[r['name']] = r['clone_url']
        end
        repositories
    end

end