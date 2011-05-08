
module RoutingHelpers

  def add_routes_runtime(&block)
    begin
      _routes = EntOs::Application.routes
      _routes.disable_clear_and_finalize = true
      _routes.clear!
      EntOs::Application.routes_reloader.paths.each{ |path| load(path) }
      _routes.draw(&block)
      ActiveSupport.on_load(:action_controller) { _routes.finalize! }
    ensure
      _routes.disable_clear_and_finalize = false
    end
  end

end
