defmodule EventApp07Web.Plugs.RequireUser do
  use EventApp07Web, :controller

  def init(args), do: args

  def call(conn, _args) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> put_flash(:error, "You must log in to do that.")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end
end
