Gem::Specification.new do |s|
  s.name        = 'notepadqq_api'
  s.version     = '0.1.0'
  s.date        = '2015-04-30'
  s.summary     = "Notepadqq API Layer"
  s.description = "Notepadqq API Layer for extensions"
  s.authors     = ["Daniele Di Sarli"]
  s.email       = 'danieleds0@gmail.com'
  s.files       = ["lib/notepadqq_api.rb",
                   "lib/notepadqq_api/message_channel.rb",
                   "lib/notepadqq_api/message_interpreter.rb",
                   "lib/notepadqq_api/stubs.rb",
                  ]
  s.homepage    = 'http://rubygems.org/gems/hola'
  s.license     = 'MIT'

  s.add_runtime_dependency 'json', '~> 1.8', '>= 1.8.0'
end
