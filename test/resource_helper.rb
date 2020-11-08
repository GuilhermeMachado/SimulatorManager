class ResourceHelper
  def find_file(name)
    File.expand_path("resources/#{name}", __dir__)
  end
end
