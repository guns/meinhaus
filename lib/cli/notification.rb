# -*- encoding: utf-8 -*-
#
# Copyright (c) 2011 Sung Pae <self@sungpae.com>
# Distributed under the MIT license.
# http://www.opensource.org/licenses/mit-license.php

module CLI
  class Notification
    attr_accessor :message, :title, :sticky, :audio

    def initialize opts = {}
      @message = opts[:message] || 'Attention'
      @title   = opts[:title]
      @sticky  = opts[:sticky]
      @audio   = opts[:audio] || :voice
    end

    def have cmd
      system %Q(/bin/sh -c 'command -v #{cmd}' &>/dev/null)
    end

    def spawn *args
      Process.detach fork { exec *args }
    end

    def notify
      if have 'growlnotify'
        cmd  = %W[growlnotify -m #{message}]
        cmd += %W[--title #{title}] if title
        cmd += %w[--sticky] if sticky
        spawn *cmd
      elsif have 'notify-send'
        spawn 'notify-send', title || '', message
      end
    end

    def play
      return unless audio

      if audio == :voice
        if RUBY_PLATFORM =~ /darwin/i and have 'say'
          spawn 'say', message
        elsif have 'espeak'
          spawn 'espeak', '-ven-us', message
        end
      elsif File.readable? audio
        if have 'afplay'
          spawn 'afplay', audio
        elsif have 'play'
          spawn 'play', '-q', audio
        end
      end
    end

    def call
      pool = []
      %w[play notify].each do |m|
        pool << Thread.new { send m }
      end
      pool.each &:join
    end
  end
end
