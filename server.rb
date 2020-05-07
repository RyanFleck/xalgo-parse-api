# frozen_string_literal: true

# Copyright (C) 2020 Ryan Fleck <Ryan.Fleck@protonmail.com>

# This program is free software: you can redistribute it and/or
# modify it under the terms of the GNU Affero General Public License
# as published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public
# License along with this program. If not, see
# <http://www.gnu.org/licenses/>.

require "sinatra"
require "xa/rules/parse"

include XA::Rules::Parse::Content

get "/" do
  "Service is up. Please use /rule or /table to parse a rule or table file."
end

def interlibr_process
  puts "Using rule folder #{File.join(ARGV[0], "*.rule")}"

  Dir.glob(File.join(ARGV[0], "*.rule")) do |ifn|
    puts "Processing #{ifn}"
    ofn = "#{ifn}.json"
    puts "> compiling #{ifn} to #{ofn}"
    tree = parse_rule(IO.read(ifn))
    exit(-1) if !tree || tree.empty?
    IO.write(ofn, MultiJson.dump(tree, pretty: true))
  end

  Dir.glob(File.join(ARGV[0], "*.table")) do |ifn|
    ofn = "#{ifn}.json"
    puts "> compiling #{ifn} to #{ofn}"
    tree = parse_table(IO.read(ifn))
    exit(-1) if !tree || tree.empty?
    IO.write(ofn, MultiJson.dump(tree, pretty: true))
  end
end
