require 'middleman-core'

Middleman::Extensions.register :flickr do
  require 'middleman-flickr/extension'
  Middleman::Flickr
end
