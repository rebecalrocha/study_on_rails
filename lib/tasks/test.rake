namespace :test do
  desc 'test entire app'
  task full_suite: [:environment] do
    if Rails.env.production?
      p 'Rails is in production!'
    else
      coverage_folder = "#{Rails.root}/coverage"
      sh("rm -rf #{coverage_folder}")
      Rake::Task['db:drop'].invoke
      Rake::Task['db:create'].invoke
      Rake::Task['db:migrate'].invoke
      sh('rails test --verbose')
      Rake::Task['rake:spec'].invoke
    end
  end
end
