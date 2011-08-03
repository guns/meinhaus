# -*- encoding: utf-8 -*-

$:.unshift File.expand_path('../../lib', __FILE__)

require 'rubygems' # 1.8.6 compat
require 'minitest/pride' if $stdout.tty? and [].respond_to? :cycle
require 'minitest/autorun'
require 'haus/task_options'
require 'haus/test/helper/minitest'

describe :TaskOptions do
  before do
    @opt = Haus::TaskOptions.new
  end

  it 'should be a subclass of Haus::Options' do
    @opt.class.ancestors[1].must_equal Haus::Options
  end

  describe :users= do
    it 'should set the users option' do
      users     = [0, Etc.getlogin]
      haususers = users.map { |u| Haus::User.new u }

      @opt.users = users
      @opt.instance_variable_get(:@ostruct).users.must_equal haususers
      @opt.users.must_equal haususers
    end
  end
end
