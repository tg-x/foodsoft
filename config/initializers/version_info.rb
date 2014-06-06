# config/initializers/version_info.rb
VersionInfo.file_format = :text
module Foodsoft
  include VersionInfo
  VERSION.load
  # try to load REVISION from file left by Capistrano, but don't fail on that
  VERSION.revision = File.read(Rails.root.join('REVISION')) rescue nil
end
