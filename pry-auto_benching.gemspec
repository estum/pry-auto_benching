require './lib/pry-auto_benching/version'
Gem::Specification.new do |spec|
  spec.name = "pry-auto_benching"
  spec.version = Pry::AutoBenching::VERSION
  spec.authors = ["Robert Gleeson"]
  spec.email = "trebor.g@protonmail.com"
  spec.summary = "Automatic benchmarking inside the Pry REPL"
  spec.description = spec.summary
  spec.homepage = "https://github.com/r-obert/pry-auto_benching.rb"
  spec.licenses = ["MIT"]
  spec.require_paths = ["lib"]
  spec.files = Dir["*.{md,txt,gemspec}", "lib/**/*.rb"]
  spec.required_ruby_version = ">= 2.1"
  spec.add_runtime_dependency "pry", ">= 0.12"
end
