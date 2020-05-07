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

# Helper method - pretty-return JSON tree from parser output.
def return_json(json_tree)
  if !json_tree || json_tree.empty?
    #raise RuntimeError.new("Unable to parse rule")
    return "Error encountered while parsing rule, empty tree returned from parser"
  end
  MultiJson.dump(json_tree, pretty: true)
end

# Helper method - remove all non-ascii characters.
def clean(dirty_input)
  dirty_input.gsub(/[[:^ascii:]]/, "")
end

upmsg = "<p><b>Service is up.</b></p>  <p>Please use /api/v5/parse/rule or /api/v5/parse/table to parse a rule or table file.</p>"

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
