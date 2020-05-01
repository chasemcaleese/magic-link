module Magic
  module Link
    class Railtie < ::Rails::Railtie
      config.to_prepare do
        ::ApplicationController.send(:include, Magic::Link::ControllerExtensions)
        ::ApplicationController.send(:helper, Magic::Link::ApplicationHelper)
        ::ApplicationController.send(:before_action, :authenticate_user_from_magic_link_token!)
        ::Magic::Link.user_class.send(:has_many, :magic_link_tokens, class_name: 'Magic::Link::Token', foreign_key: 'resource_id')
      end
    end
  end
end
