# -*- encoding: utf-8 -*-

require 'optparse'
require 'ostruct'
require 'pathname'

class Haus
  #
  # A hybrid OptionParser / OpenStruct class.
  # Mu ha ha ha ha ha...
  #
  class Options < OptionParser
    def initialize
      super
      @ostruct = OpenStruct.new
    end

    def tap
      yield self
      self
    end

    def method_missing method, *args
      @ostruct.send method, *args
    end

    # provides default value for HAUS_PATH
    def path
      @ostruct.path || File.expand_path('../../../..', __FILE__)
    end
  end
end
