module Kaffe
  module Render
    include Tilt::CompileSite
    def templates
      @templates ||= Tilt::Cache.new
    end

    def render(template, options: {}, &block)
      local = options.delete(:locals) || {}
      views = options.delete(:views) || settings.views || "./views"
      layout = options[:layout] || settings.layout || :layout

      case template
      when Symbol
        path = nil
        found = false
        find_template(views, template, engine) do |file|
          puts "testing #{file}"
          if found = File.exists?(file)
            path = file
            break
          end
        end
        raise "Could not find Template #{template}" unless found
        t = templates.fetch(path) { Tilt.new path }
        output = t.render(self, &block)

        if layout
          return render(engine, layout, layout: false) { output }
        end
        return output
      end
    end

    def find_template(views, name, engine)
      Tilt.mappings.each do |ext, engines|
        yield ::File.join(views, "#{name}.#{ext}")
      end
    end
  end
end
