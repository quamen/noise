require 'thor'

class Noise < Thor
  CC = "xcodebuild"
  CFLAGS = "-configuration Release"

  desc "clean", "clean the project"
  def clean
    xcode_action(:clean)
  end

  desc "build", "build the project"
  def build
    invoke :clean
    xcode_action(:build)
  end

  desc "release", "cut a new release and upload it"
  def release
    invoke :build
  end

  private
    def xcode_action(action)
      system("#{CC} #{CFLAGS} #{action}")
    end
end
