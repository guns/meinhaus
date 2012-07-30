# -*- encoding: utf-8 -*-
#
# Copyright (c) 2012 Sung Pae <self@sungpae.com>
# Distributed under the MIT license.
# http://www.opensource.org/licenses/mit-license.php

module CLI
  module ReplHelpers
    # Invoke interactive_editor or Pry edit
    def edit *args
      ::CLI::ReplHelpers.send :remove_method, :edit
      unless $0 == 'pry'
        require 'interactive_editor'
        alias :edit :vim
        vim *args
      end
    end

    # Pretty print, returning nil
    def pp *args
      require 'pp'
      super
      nil
    end

    # Awesome print, returning nil
    def ap *args
      require 'ap'
      super
      nil
    end

    # http://stackoverflow.com/questions/123494/whats-your-favourite-irb-trick/123834#123834
    def bm n = 1
      require 'benchmark'
      warn "#{n} iteration(s):"
      Benchmark.bm do |test|
        test.report { n.times { yield } }
      end; nil
    end

    def plist_read file
      require 'plist'

      buf = File.read file

      if buf[0..7] == 'bplist00'
        system 'plutil', '-convert', 'xml1', file
        plist = Plist.parse_xml File.read(file)
        system 'plutil', '-convert', 'binary1', file
        plist
      else
        Plist.parse_xml(buf)
      end
    end

    def plist_write plist, file
      require 'plist'
      File.open(file, 'w') { |f| f.puts Plist::Emit.dump(p) }
    end

    def notify
      @notify ||= begin
        require 'cli/notification'
        CLI::Notification.new :audio => File.expand_path('~/.sounds/Message_Received.m4a')
      end
      @notify.call; nil
    end
    alias :na :notify

    # Toggle number inspect style
    def toggle_verbose_numbers
      Integer.module_eval do
        class << self
          attr_accessor :verbose_inspect
        end

        if self.verbose_inspect = !verbose_inspect
          alias_method :__inspect__, :inspect
          def inspect
            lines = ['', '']

            [%w[%-d dec], %w[%08b bin], %w[0%03o oct], %w[0x%02x hex]].each do |fmt, label|
              str = fmt % self
              len = [str, label].map(&:length).max + 1
              lines[0] << "%-#{len}s" % label
              lines[1] << "%-#{len}s" % str
            end

            lines[1] = '   %s' % lines[1] if $0 == 'pry'

            lines.join "\n"
          end
        else
          remove_method :inspect
          alias_method :inspect, :__inspect__
        end
      end
    end

    def toggle_magic_quotes
      eval <<-EVAL
        def self.method_missing *args
          args.join ' '
        end
      EVAL
    end
  end
end