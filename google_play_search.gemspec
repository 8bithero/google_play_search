Gem::Specification.new do |s|  
  s.name        = 'google_play_search'  
  s.version     = '0.0.4'  
  s.date        = '2012-06-03'  
  s.summary     = "google play market search"  
  s.description = "google play market search gem"  
  s.authors     = ["Grant Chen"]  
  s.email       = 'kucss@hotmail.com'  

  s.add_dependency('nokogiri','>= 1.5.3')

  s.files         = Dir['lib/**/*.rb'] + Dir['*.rb']
  s.homepage    =  
    'https://github.com/kucss/google_play_search'  
end 
