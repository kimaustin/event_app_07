defmodule EventApp07.Invitations do
  @moduledoc """
  The Invitations context.
  """

  import Ecto.Query, warn: false
  alias EventApp07.Repo
  alias EventApp07.Users.User
  alias EventApp07.Invitations.Invitation

  @doc """
  Returns the list of invitations.

  ## Examples

      iex> list_invitations()
      [%Invitation{}, ...]

  """
  def list_invitations do
    Repo.all(Invitation)
    |> Repo.preload(:user)
    |> Repo.preload(:event)
  end

  def list_invitations_for_user(user_id) do
    # query = from invitation in Invitation, where invitation.user_id = user_id
    # Repo.all(Invitation)
    Enum.filter(Repo.all(Invitation), fn x ->
      x.user_id == user_id
    end)
  end


  @doc """
  Gets a single invitation.

  Raises `Ecto.NoResultsError` if the Invitation does not exist.

  ## Examples

      iex> get_invitation!(123)
      %Invitation{}

      iex> get_invitation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_invitation!(id) do
    Repo.get!(Invitation, id)
    # if invitation.user_id == nil do
    #   user = Repo.get_by(User, email: invitation.email)
    #   if user do
    #     invitation.user_id = user.id
    #   end
    # end
    # invitation
  end

  def load_event_user(%Invitation{} = invitation) do
    Repo.preload(invitation, [event: :invitation, user: :invitation])
    # Repo.preload(event, [invitations: :user])
  end

  # def get_invitation!(id) do
  #   invitation = Repo.get!(Invitation, id)
  #   if invitation.user_id == nil do
  #     user = Repo.get_by(User, email: invitation.email)
  #     if user do
  #       invitation.user_id = user.id
  #     end
  #   end
  #   invitation
  # end

  @doc """
  Creates a invitation.

  ## Examples

      iex> create_invitation(%{field: value})
      {:ok, %Invitation{}}

      iex> create_invitation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_invitation(attrs \\ %{}) do
    %Invitation{}
    |> Invitation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a invitation.

  ## Examples

      iex> update_invitation(invitation, %{field: new_value})
      {:ok, %Invitation{}}

      iex> update_invitation(invitation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_invitation(%Invitation{} = invitation, attrs) do
    invitation
    |> Invitation.changeset(attrs)
    |> Repo.update()
  end


  @doc """
  Deletes a invitation.

  ## Examples

      iex> delete_invitation(invitation)
      {:ok, %Invitation{}}

      iex> delete_invitation(invitation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_invitation(%Invitation{} = invitation) do
    Repo.delete(invitation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking invitation changes.

  ## Examples

      iex> change_invitation(invitation)
      %Ecto.Changeset{data: %Invitation{}}

  """
  def change_invitation(%Invitation{} = invitation, attrs \\ %{}) do
    Invitation.changeset(invitation, attrs)
  end
end
