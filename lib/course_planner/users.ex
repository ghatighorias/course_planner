defmodule CoursePlanner.Users do
  @moduledoc """
    Handle all interactions with Users, create, list, fetch, edit, and delete
  """
  alias CoursePlanner.{Repo, User, Notification, Notifications}
  alias Ecto.{DateTime, Changeset, Multi}
  @notifier Application.get_env(:course_planner, :notifier, CoursePlanner.Notifier)

  def all do
    Repo.all(User)
  end

  def new_user(user, token) do
    user =
      user
      |> Map.put_new("reset_password_token", token)
      |> Map.put_new("reset_password_sent_at", DateTime.utc())
      |> Map.put_new("password", "fakepassword")
      |> Map.put_new("password_confirmation", "fakepassword")

    User.changeset(%User{}, user)
  end

  def get(id) do
    case Repo.get(User, id) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  def delete(id) do
    case get(id) do
      {:ok, user} -> Repo.delete(user)
      error -> error
    end
  end

  def notify_user(%{id: id}, %{id: id}, _, _), do: nil
  def notify_user(modified_user, _current_user, notification_type, path) do
    Notifications.new()
    |> Notifications.type(notification_type)
    |> Notifications.resource_path(path)
    |> Notifications.to(modified_user)
    |> @notifier.notify_later()
  end

  def update_notifications(user) do
    multi = Multi.new()

    user.notifications
    |> Enum.reduce(multi, &delete_notifications/2)
    |> Multi.update(User, Changeset.change(user, notified: Ecto.Date.utc()))
    |> Repo.transaction()
  end

  defp delete_notifications(notification, multi) do
    Multi.delete(multi, Notification, notification)
  end
end
