# frozen_string_literal: true

desc 'Build docker image'
task :build do
  sh('docker build . --tag testrail-restore-backup')
end

desc 'Run docker image'
task run: :build do
  sh('docker run -it -p 80:80 testrail-restore-backup')
end
