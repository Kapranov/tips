#!/usr/bin/env ruby

puts "What version number do you want to release?"
print "> "
version = gets.gsub(/\n/, "")

continue = system "github_changelog_generator"
continue = system "git add ."
continue = system "git commit -am \"Release version #{version}\"" if continue
continue = system "git tag v#{version}" if continue
continue = system "git push" if continue
continue = system "git push -f origin v#{version}" if continue
continue = system "mix hex.publish" if continue

puts "Version #{version} was successfully released!"
