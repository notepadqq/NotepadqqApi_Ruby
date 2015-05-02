Gem::Specification.new do |s|
  s.name        = 'notepadqq_api'
  s.version     = '0.1.4'
  s.date        = '2015-05-2'
  s.summary     = "Notepadqq API Layer"
  s.description = "Notepadqq API Layer for extensions"
  s.authors     = ["Daniele Di Sarli"]
  s.email       = 'danieleds0@gmail.com'
  s.files       = ["lib/notepadqq_api.rb",
                   "lib/notepadqq_api/message_channel.rb",
                   "lib/notepadqq_api/message_interpreter.rb",
                   "lib/notepadqq_api/stubs.rb",
                   "test/test_message_interpreter.rb",
                   "test/test_stubs.rb",
                  ]
  s.homepage    = 'https://rubygems.org/gems/notepadqq_api'
  s.license     = 'MIT'

  s.add_runtime_dependency 'json', '~> 1.8'
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'minitest', '~> 5.5'

  s.required_ruby_version = '>= 2.0'
end
