defmodule EventApp07Web.UserController do
  use EventApp07Web, :controller

  alias EventApp07.Users
  alias EventApp07.Users.User
  alias EventApp07.Photos
  alias EventApp07Web.Plugs

  plug Plugs.RequireUser when action in [:edit, :update]
  plug :fetch_user when action in [:show, :edit, :update, :delete]
  plug :require_owner when action in [:edit, :update, :delete]

  def fetch_user(conn, _args) do
    id = conn.params["id"]
    user = Users.get_user(id)
    assign(conn, :user, user)
  end

  def require_owner(conn, _args) do
    curr_user = conn.assigns[:current_user]
    user = conn.assigns[:user]

    if user && user.id == curr_user.id do
      conn
    else
      conn
      |> put_flash(:error, "That isn't you.")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Users.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    up = user_params["photo"]
    {:ok, hash} = Photos.save_photo(up.filename, up.path)
    user_params = user_params
    |> Map.put("photo_hash", hash)

    case Users.create_user(user_params) do
      {:ok, user} ->
        Users.update_invitations(user_params["email"], user.id)
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Users.get_user(id)
    changeset = Users.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user(id)
    up = user_params["photo"]

    user_params = if up do
      # FIXME: Remove old image
      {:ok, hash} = Photos.save_photo(up.filename, up.path)
      Map.put(user_params, "photo_hash", hash)
    else
      user_params
    end

    case Users.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user(id)
    {:ok, _user} = Users.delete_user(user)

    # FIXME: Remove old image

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end

  # New controller function.
  def photo(conn, %{"id" => id}) do
    user = Users.get_user(id)
    {:ok, _name, data} = Photos.load_photo(user.photo_hash)
    conn
    |> put_resp_content_type("image/jpeg")
    |> send_resp(200, data)
  end

end
