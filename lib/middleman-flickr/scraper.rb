module Middleman
  class Flickr
    class Scraper
      attr_reader :options

      def initialize(data = {})
        @options = data

        FlickRaw.api_key = ENV['FLICKR_KEY']
        FlickRaw.shared_secret = ENV['FLICKR_SECRET']
        @flickr = FlickRaw::Flickr.new
        @flickr.access_token = ENV['FLICKR_TOKEN']
        @flickr.access_secret = ENV['FLICKR_TOKEN_SECRET']

        @flickr.test.login # will raise error on auth failure!
      end

      def scrape
        data = options.delete(:data)
        data.map do |kind, ids|
          ids.map { |id| request kind, id, options }.compact
        end.compact.flatten(1).uniq
      end

      def to_html
        html = scrape.map do |img|
          <<-HTML
          <div class='grid-item'>
            <a href='#{img[:url]}' rel='lightbox'>
              <img src='#{img[:thumb]}' class='lazyload flickr'/>
            </a>
          </div>"
          HTML
        end
        "<div class='grid'>#{html.join}</div>" if html.any?
      end

      def get_photoset(id, opts = {})
        options = { photoset_id: id, extras: 'url_c,url_n', per_page: 500 }
        options = options.merge(opts)
        response = @flickr.photosets.getPhotos options
        response.photo.map { |p| { thumb: p['url_n'], url: p['url_c'] } }
      end

      def get_photo(id)
        options = { photo_id: id, extras: 'url_c,url_n' }
        options = options.merge(opts)
        photo = @flickr.photos.getInfo options
        { thumb: photo['url_n'], url: photo['url_c'] }
      end

      def request(kind, id)
        send("get_#{kind}", id) if respond_to?("get_#{kind}")
      rescue FlickRaw::FailedResponse => err
        on_error = options[:suppress_errors]
        raise unless on_error
        on_error.call(err) if on_error.respond_to?(:call)
      end
    end
  end
end
