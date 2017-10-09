require 'middleman-core'

# Middleman Flickr Extension namespace
module Middleman
  class Flickr < Extension
    option :html_class, 'flickr-images', 'Class for div container for response.'
    option :show_on_empty, true, 'Whether to embed markup when no photos are
    returned? You can set this option to a Proc that renders HTML, instead.'
    option :suppress_errors, false, 'Do not raise errors on missing photos! Set
    this to a Proc if you like.'

    expose_to_template :display_flickr, :get_flickr_images,
                       :display_flickr_photo, :display_flickr_photoset

    def initialize(app, options_hash = {}, &block)
      super
      require 'flickraw'
      # require 'middleman-flickr/helpers'
      # self.class.defined_helpers = [Middleman::Flickr::Helpers]
      require 'middleman-flickr/scraper'
    end

    def get_flickr_images(opts = {})
      data = options.to_h.merge(opts)
      Middleman::Flickr::Scraper.new(data).scrape
    end

    def display_flickr(opts = {})
      html = get_flickr_images(opts)

      return "<div class='#{options.html_class}'>#{html}</div>" if html
      return if !html && !(blk = options.show_on_empty)

      return blk.call(err) if blk.respond_to?(:call)
      '<div class="alert alert-warning">Images not available.</div>'
    end

    def display_flickr_photo(*args)
      opts = args.last.is_a?(Hash) ? args.pop : {}
      display_flickr opts.merge(data: { photo: args })
    end

    def display_flickr_photoset(*args)
      opts = args.last.is_a?(Hash) ? args.pop : {}
      display_flickr opts.merge(data: { photoset: args })
    end
  end
end
