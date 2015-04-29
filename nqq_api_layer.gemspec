Gem::Specification.new do |s|
  s.name        = 'nqq_api_layer'
  s.version     = '0.1.0'
  s.date        = '2015-04-30'
  s.summary     = "Notepadqq API Layer"
  s.description = "Notepadqq API Layer for extensions"
  s.authors     = ["Daniele Di Sarli"]
  s.email       = 'danieleds0@gmail.com'
  s.files       = ["lib/nqq_api_layer.rb",
                   "lib/nqq_api_layer/message_channel.rb",
                   "lib/nqq_api_layer/message_interpreter.rb",
                   "lib/nqq_api_layer/stubs.rb",
                  ]
  s.homepage    = 'http://rubygems.org/gems/hola'
  s.license     = 'MIT'

  s.add_runtime_dependency 'json', '~> 1.8', '>= 1.8.0'
end
