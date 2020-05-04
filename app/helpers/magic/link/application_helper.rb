module Magic
  module Link
    module ApplicationHelper
      def magic_link_to(name = nil, options = nil, html_options = nil, resource:, reusable: false, &block)
        html_options, options, name = options, name, block if block_given?
        options ||= {}

        if resource.class == MagicLink 
          mg = resource
        elsif resource.class == Magic::Link.user_class
          mg = Magic::Link::MagicLink.new(email: resource.email, reusable: reusable)
        else 
          raise "Resource class #{resource.class } is not compatible with magic_link_to. It must be #{Magic::Link.user_class} or #{MagicLink.class}."
        end 

        html_options = convert_options_to_data_attributes(options, html_options)

        url = url_for(options)

        url_parts = URI.parse(url)
        params = Rack::Utils.parse_query(url_parts.query)

        params.merge!(email: resource.email, sign_in_token: mg.get_login_token)

        url_parts.query = params.to_param 
        Rails.logger.info(url_parts.to_s)

        url = url_parts.to_s
        html_options["href"] ||= url

        content_tag("a", name || url, html_options, &block)
      end 
    end
  end
end
