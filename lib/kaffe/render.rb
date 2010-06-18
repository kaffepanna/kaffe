module Kaffe
  module Render
    include Tilt::CompileSite
    def templates
      @templates ||= Tilt::Cache.new
    end

    def render(template, options = {:layout => true} )
      t = templates.fetch(template) { Tilt.new template }

      return t.render(self)
    end
  end
end
