defmodule PRM.Web do
  def controller do
    quote do
      use Phoenix.Controller, namespace: PRM.Web
      import Plug.Conn
      import PRM.Web.Router.Helpers
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def view do
    quote do
      use Phoenix.View, root: ""

      import PRM.Web.ErrorHelpers
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
