require 'thor'
require 'plist'

APP_NAME = "noise"
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

  desc "tag VERSION", "tag the project with the specified version"
  def tag(version)
    info = Plist::parse_xml(INFO_PLIST_PATH)
    info['CFBundleVersion'] = version
    info.save_plist(INFO_PLIST_PATH)

    git "add #{INFO_PLIST_PATH}"
    git "commit -m 'Prepare release #{version}.'"
    git "tag #{version}"
    #git "push --tags origin master"
  end

  desc "release VERSION", "cut a new release and upload it"
  def release(version)
    path = create_release(version)
    length = File.size(path)
    signature = sign(path)

    puts path, length, signature

    create_post(version, length, signature)
  end

  private
    def git(action)
      system "git #{action}"
    end

    def xcode(action)
      system "#{CC} #{CFLAGS} #{action}"
    end

    def sign(path)
      `openssl dgst -sha1 -binary < "#{path}" | openssl dgst -dss1 -sign "#{PRIVATE_KEY}" | openssl enc -base64`
    end

    def create_release(version)
      release_file_name = "#{APP_NAME}-#{version}.tar.bz2"
      release_path = File.join('/', 'tmp', release_file_name)

      tag(version)
      build
      system "tar -cjf #{release_path} -C build/Release #{APP_NAME}.app"

      release_path
    end

    def create_post(version, length, signature)
      git "checkout gh-pages"

      post_file_name = Time.new.strftime("%Y-%m-%d") + "-release-#{version}.markdown"
      post_path = File.join(File.dirname(__FILE__), '_posts', post_file_name)

      open(post_path, 'w') { |file| file.puts <<EOF }
---
layout: post
title: Release #{version}
release-version: #{version}
release-length: #{length}
release-signature: #{signature}
---

<p>Sample Appcast</p>
EOF

      git "add _posts #{post_path}"
      git "commit -m 'Added new post for version #{version}.'"
      #git "push origin gh-pages"
      git "checkout master"
    end
end
