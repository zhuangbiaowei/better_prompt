Gem::Specification.new do |spec|
  spec.name          = "better_prompt"
  spec.version       = "0.1.0"
  spec.authors       = ["zhuang biaowei"]
  spec.email         = ["zbw@kaiyuanshe.org"]
  spec.summary       = "A better command line prompt utility"
  spec.description   = "Provides enhanced command line prompt functionality with customization options"
  spec.homepage      = "https://github.com/zhuangbiaowei/better_prompt"
  spec.license       = "MIT"

  spec.files         = Dir["{lib}/**/*.rb", "LICENSE", "README.md"]
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.6.0"

  spec.add_dependency "ruby_rich", "~> 0.3.1"
  
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end