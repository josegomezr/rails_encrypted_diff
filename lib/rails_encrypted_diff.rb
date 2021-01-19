require "rails_encrypted_diff/version"
require 'rake'

module RailsEncryptedDiff
	class Tasks
    include Rake::DSL if defined? Rake::DSL
    def install_tasks
       load 'rails_encrypted_diff/tasks/encrypted_diff.rake'
    end
  end 
end

RailsEncryptedDiff::Tasks.new.install_tasks
