require 'thor'
require 'plist'
require 'curb'
require 'rexml/document'
require 'yaml'

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
    git "push --tags origin master"
  end

  desc "release VERSION", "cut a new release and upload it"
  def release(version)
    path = create_release(version)
    upload_file(path, File.basename(path), "#{APP_NAME} release #{version}.")

    length = File.size(path)
    signature = sign(path)
    update_gh_pages(version, length, signature)
  end

  private
    def git(action)
      `git #{action}`.chomp
    end

    def xcode(action)
      system "#{CC} #{CFLAGS} #{action}"
    end

    def sign(path)
      `openssl dgst -sha1 -binary < "#{path}" | openssl dgst -dss1 -sign "#{PRIVATE_KEY}" | openssl enc -base64`
    end

    def update_gh_pages(version, length, signature)
      git "checkout gh-pages"
      git "pull origin gh-pages"
      create_post(version, length, signature)
      update_index_page(version)
      git "commit -m 'Added new post for version #{version}.'"
      git "push origin gh-pages"
      git "checkout master"
    end

    def create_release(version)
      puts "Creating #{APP_NAME} release #{version}..."

      file_name = "#{APP_NAME}-#{version}.tar.gz"
      path = File.join('/', 'tmp', file_name)

      tag(version)
      build
      system "tar -czf #{path} -C build/Release #{APP_NAME}.app"

      path
    end

    def create_post(version, length, signature)
      puts "Creating #{APP_NAME} jekyll post for #{version}..."

      file_name = Time.new.strftime("%Y-%m-%d") + "-release-#{version}.markdown"
      path = File.join(File.dirname(__FILE__), '_posts', file_name)

      open(path, 'w') { |file| file.puts <<EOF }
---
layout: post
title: Release #{version}
release-version: #{version}
release-length: #{length}
release-signature: #{signature}
---

<p>Sample Appcast</p>
EOF

      git "add #{path}"
    end

    def git_config_value(name)
      # Try global scope.
      value = git "config --global --get #{name}"

      # Try project scope.
      if value.empty?
        value = git "config --get #{name}"
      end

      value
    end

    def upload_file(path, file_name, description)
      puts "Uploading #{path} to GitHub..."

      login = git_config_value("github.user")
      fail "login not set in git config" unless login
      token = git_config_value("github.token")
      fail "token not set in git config" unless token

      payload = [
        Curl::PostField.content('file_size',    File.size(path)),
        Curl::PostField.content('content_type', "application/octet-stream"),
        Curl::PostField.content('file_name',    file_name),
        Curl::PostField.content('description',  description || ''),
        Curl::PostField.content('login',        login),
        Curl::PostField.content('token',        token),
      ]

      curl = Curl::Easy.http_post("http://github.com/quamen/noise/downloads", *payload)

      fail "failed to upload to GitHub" unless curl.response_code == 200

      doc = REXML::Document.new(curl.body_str)
      upload = doc.elements.first.elements.to_a.inject({}) {|hash, element| hash[element.name] = element.text; hash}
      payload = [
        Curl::PostField.content('Filename',               path),
        Curl::PostField.content('policy',                 upload['policy']),
        Curl::PostField.content('success_action_status',  '201'),
        Curl::PostField.content('key',                    upload['prefix'] + file_name),
        Curl::PostField.content('AWSAccessKeyId',         upload['accesskeyid']),
        Curl::PostField.content('Content-Type',           "application/octet-stream"),
        Curl::PostField.content('signature',              upload['signature']),
        Curl::PostField.content('acl',                    upload['acl']),
        Curl::PostField.file('file',                      path),
      ]

      curl = Curl::Easy.http_post("http://github.s3.amazonaws.com/", *payload) do |curl|
        curl.multipart_form_post = true
      end

      fail "failed to upload to Amazon S3" unless curl.response_code == 201
    end

    def update_index_page(version)
      path = 'index.html'
      data = nil
      content = File.read(path)

      if content =~ /^(---\s*\n.*?\n?)(---.*?\n)/m
        content = content[($1.size + $2.size)..-1]
        data = YAML.load($1)
      else
        fail "failed to update version on #{path} page"
      end

      # Update the version.
      data['release-version'] = version

      open(path, 'w') do |fout|
        fout.puts data.to_yaml
        fout.puts '---'
        fout.puts content
      end

      git "add #{path}"
    end
end
