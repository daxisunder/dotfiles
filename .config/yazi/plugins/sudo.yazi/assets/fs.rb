#!/usr/bin/env ruby

require 'fileutils'
require 'optparse'

def legit_name(path)
	return path unless File.exist?(path)

	name = File.basename(path, ".*")
	ext = File.extname(path)
	i = 1
	loop do
		new_name = "#{name}_#{i}#{ext}"
		return new_name unless File.exist?(new_name)
		i += 1
	end
end

def cp(paths, force: false)
	paths.each do |src|
		dest = File.basename(src)
		dest = legit_name(dest) unless force
		if File.directory?(src)
			FileUtils.cp_r(src, dest, verbose: true)
		else
			FileUtils.cp(src, dest, verbose: true)
		end
	end
end

def mv(paths, force: false)
	paths.each do |src|
		dest = File.basename(src)
		dest = legit_name(dest) unless force
		FileUtils.mv(src, dest, verbose: true)
	end
end

def ln(paths, relative: false)
	paths.each do |src|
		dest = legit_name(File.basename(src))
		if relative
			FileUtils.ln_s(Pathname.new(src).relative_path_from(Pathname.new(Dir.pwd)), dest, verbose: true)
		else
			FileUtils.ln_s(src, dest, verbose: true)
		end
	end
end

def hardlink(paths)
	paths.each do |src|
		dest = legit_name(File.basename(src))
		FileUtils.ln(src, dest, verbose: true)
	end
end

def rm(paths, permanent: false)
	paths.each do |path|
		if permanent
			FileUtils.rm_r(path, verbose: true)
		else
			# A more robust solution would use a trash library
			puts "Moved #{path} to trash (simulation)"
		end
	end
end

options = {}
OptionParser.new do |opts|
	opts.banner = "Usage: fs.rb [command] [options]"

	opts.on("--force", "Force overwrite") do |f|
		options[:force] = f
	end
	opts.on("--relative", "Create relative symlink") do |r|
		options[:relative] = r
	end
	opts.on("--permanent", "Permanently delete") do |p|
		options[:permanent] = p
	end
end.parse!

command = ARGV.shift

case command
when "cp"
	cp(ARGV, force: options[:force])
when "mv"
	mv(ARGV, force: options[:force])
when "ln"
	ln(ARGV, relative: options[:relative])
when "hardlink"
	hardlink(ARGV)
when "rm"
	rm(ARGV, permanent: options[:permanent])
end
