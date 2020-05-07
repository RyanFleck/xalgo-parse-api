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
require "sinatra/namespace"
require "xa/rules/parse"
require "multi_json"

include XA::Rules::Parse::Content

def return_json(json_tree)
  if !json_tree || json_tree.empty?
    #raise RuntimeError.new("Unable to parse rule")
    return "Error encountered while parsing rule, empty tree returned from parser"
  end
  MultiJson.dump(json_tree, pretty: true)
end

def clean(dirty_input)
  dirty_input.gsub(/[[:^ascii:]]/, "")
end

upmsg = "Service is up. Please use /rule or /table to parse a rule or table file."

get "/" do
  upmsg
end

post "/" do
  upmsg
end

namespace "/api/v5/parse" do
  puts "using API V5"

  before do
    content_type "text/plain"
    request.body.rewind
  end

  post "/rule" do
    tree = parse_rule(clean(request.body.read))
    return_json(tree)
  end

  post "/table" do
    tree = parse_table(clean(request.body.read))
    return_json(tree)
  end
end

def interlibr_process
  puts "Using rule folder #{File.join(ARGV[0], "*.rule")}"

  Dir.glob(File.join(ARGV[0], "*.rule")) do |ifn|
    tree = parse_rule(IO.read(ifn))
    exit(-1) if !tree || tree.empty?
    IO.write(ofn, MultiJson.dump(tree, pretty: true))
  end

  Dir.glob(File.join(ARGV[0], "*.table")) do |ifn|
    tree = parse_table(IO.read(ifn))
    exit(-1) if !tree || tree.empty?
    IO.write(ofn, MultiJson.dump(tree, pretty: true))
  end
end
