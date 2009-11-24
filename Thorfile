require 'thor'
require 'plist'

INFO_PLIST_PATH = "Info.plist"

class Noise < Thor
  CC = "xcodebuild"
  CFLAGS = "-configuration Release"
  PRIVATE_KEY = "dsa_priv.pem"

  desc "clean", "clean the project"
  def clean
    xcode :clean
  end

  desc "build", "build the project"
  def build
    clean
    xcode :build
  end

  desc "sign", "sign the build"
  def sign
    #system "openssl dgst -sha1 -binary < "#{ARGV[0]}" | openssl dgst -dss1 -sign "#{PRIVATE_KEY}" | openssl enc -base64"
  end

  desc "tag VERSION", "tag the project with the specified version"
  def tag(version)
    info = Plist::parse_xml(INFO_PLIST_PATH)
    info['CFBundleVersion'] = version
    info.save_plist(INFO_PLIST_PATH)
  end

  desc "release VERSION", "cut a new release and upload it"
  def release(version)
    tag(version)
    build
    system "tar -cjf noise-#{version}.tar.bz2 -C build/Release noise.app"
    sign
  end

  private
    def xcode(action)
      system "#{CC} #{CFLAGS} #{action}"
    end
end
