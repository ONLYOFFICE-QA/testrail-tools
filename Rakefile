# frozen_string_literal: true

task :build do
  sh(`docker build . --tag testrail-restore-backup`)
end

task :run do
  sh('docker run -it -p 80:80 testrail-restore-backup')
end
