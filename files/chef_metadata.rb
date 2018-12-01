#!/usr/bin/env ruby

FILE_NAME = "/var/chef/updater_metadata.txt"

file = File.open(FILE_NAME, "r")
data = file.read
file.close

data.each_line do |line|
    key, value = line.split()
    if ARGV[0]
        if ARGV[0] == key
            print value
            break
        end
    else
        puts "#{key}: #{value}"
    end
end
