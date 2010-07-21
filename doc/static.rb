require File.expand_path('../support', __FILE__)
require 'fileutils'
require 'pathname'

here = Pathname.new(File.expand_path("..", __FILE__))
source = here.join("source")
output = here.join("static")
posts = source.join("posts")
template = here.join('source/templates/browse.wtpl')

Dir[File.join(source, "public/*")].each do |file|
  FileUtils.cp_r(file, output)
end

Dir[File.join(here, "source", "posts", "**", "*.wtxt")].each do |file|
  rel_file = Pathname.new(file).relative_path_from(posts)
  context = {
    :base           => "http://127.0.0.1:9292/",
    :requested_file => file
  }
  wlanged = ::WLang::file_instantiate(template.to_s, context)
  
  target_dir = output.join(rel_file).dirname
  target_dir.mkdir unless target_dir.exist?
  File.open(target_dir.join("#{rel_file.basename('.wtxt')}.html"), "w") do |file|
    file << wlanged
  end
end