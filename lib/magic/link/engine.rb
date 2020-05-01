module Magic
  module Link
    class Engine < ::Rails::Engine
      config.autoload_paths += %W(#{config.root}/lib)

      isolate_namespace Magic::Link
    end
  end
end
