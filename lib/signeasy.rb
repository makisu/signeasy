require 'gem_config'
require 'signeasy/version'
require 'signeasy/client'
require 'signeasy/template'
require 'signeasy/pending_file'
require 'signeasy/request_signature'
require 'signeasy/remind_result'
require 'signeasy/cancel_result'
require 'signeasy/url_result'
require 'signeasy/pdf_result'
require 'signeasy/callback'

module Signeasy
  include GemConfig::Base

  with_configuration do
    has :api_token, classes: String
    has :client_id, classes: String
  end
end
