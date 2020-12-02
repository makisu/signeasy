config = YAML.load_file(SPEC_DIR.join('config.yml')).with_indifferent_access
if api_token = ENV['BLOOM_REMIT_API_TOKEN'].presence
  config[:api_token] = api_token
end
CONFIG = config
