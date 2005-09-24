#!/usr/bin/env ruby

# local marc library gets tested
# not already installed one
$LOAD_PATH.unshift("lib")

require 'test/unit'
require 'test/tc_subfield'
require 'test/tc_field'
require 'test/tc_record'
require 'test/tc_reader'