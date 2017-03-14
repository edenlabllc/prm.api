defmodule PRM.Web.ErrorHelpers do
  def translate_error({msg, opts}) do
    if count = opts[:count] do
      Gettext.dngettext(PRM.Web.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(PRM.Web.Gettext, "errors", msg, opts)
    end
  end
end
