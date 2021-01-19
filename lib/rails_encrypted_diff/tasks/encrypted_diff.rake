namespace :encrypted do
  desc 'Diff the encrypted storage against a version in another branch (master by default)'

  task :diff, %i[store key target_branch] => :environment do |_, args|
    store = args[:store] || 'credentials'
    key = args[:key] || 'master'
    target_branch = args[:target_branch] || 'master'

    key_file = "./config/#{key}.key"
    encrypted_store_file_path = "./config/#{store}.yml.enc"

    # head = current state
    # target = comparison state
    # the goal is to diff FROM taget_file TO head_file

    # this two files will store the decrypted contents of the credentials store
    # in order to invoke unix diff on it
    head_tmp_file = Tempfile.new('head-', mode: 0o600)
    target_tmp_file = Tempfile.new('target-', mode: 0o600)

    begin
      # fetch the contents of the encrypted storage from target_branch
      # into target_tmp_file
      system("git show #{target_branch}:#{encrypted_store_file_path} > #{target_tmp_file.path}")
      # having both encrypted storages, decrypt both storage and read the contents
      encrypted_target_contents = Rails.application.encrypted(target_tmp_file.path, key_path: key_file).read
      encrypted_head_contents = Rails.application.encrypted(encrypted_store_file_path, key_path: key_file).read

      # Reset the target file
      target_tmp_file.truncate(0)

      # write unencrypted contents into the tmpfiles
      target_tmp_file.write(encrypted_target_contents)
      head_tmp_file.write(encrypted_head_contents)

      # force it to flush, else diff will always evaluate to no output
      [head_tmp_file, target_tmp_file].each(&:flush)
      # invoke unix diff
      system("diff -a -u3 --color='always' #{target_tmp_file.path} #{head_tmp_file.path}")
    ensure
      # at the end, no matter what, close & unlink the files
      [head_tmp_file, target_tmp_file].each { |f| f.close(true) }
    end
  end
end
