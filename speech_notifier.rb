# Copyright 2009 Clear Interactive. All rights reserved.

require 'notifier'

class SpeechNotifier < Notifier
  def initialize
    @synth = NSSpeechSynthesizer.new
    super
  end

  def notify(title, message)
    @synth.startSpeakingString(message)
  end
end
