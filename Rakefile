Rake::TestTask.new(:spec) do |t|
  t.libs << "spec"
  t.libs << "lib"
  t.test_files = FileList['spec/**/*_spec.rb']
  t.warning = false
end

task :default => :spec
task :test => :spec
