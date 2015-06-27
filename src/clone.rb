#!/usr/bin/env ruby

require 'rugged'

module Clone
    
    # Clone a GitHub repository into 'destination' folder.
    def Clone.git_clone(clone_url, destination)
        Rugged::Repository.clone_at(clone_url, destination, {
            transfer_progress: lambda { |total_objects, indexed_objects, received_objects, \
                    local_objects, total_deltas, indexed_deltas, received_bytes|
                progress = 100.0*(received_objects.to_f/total_objects.to_f)
                printf "--> Received %d KB. Progress: %.2f%%.\r", received_bytes/1024, progress
                $stdout.flush
            }
        })
        printf "\v"
    end

end