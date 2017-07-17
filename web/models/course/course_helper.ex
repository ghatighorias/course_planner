defmodule CoursePlanner.CourseHelper do
  @moduledoc """
  This module provides custom functionality for controller over the model
  """
  use CoursePlanner.Web, :model

  alias CoursePlanner.{Repo, Course, Terms, Notifier, Notifier.Notification}

  def delete(id) do
    course = Repo.get(Course, id)
    if is_nil(course) do
      {:error, :not_found}
    else
      Repo.delete(course)
    end
  end

  def notify_user_course(course, current_user, notification_type, path \\ "/") do
    course
    |> Terms.get_subscribed_users()
    |> Enum.reject(fn %{id: id} -> id == current_user.id end)
    |> Enum.each(&(notify_user(&1, notification_type, path)))
  end

  def notify_user(user, type, path) do
    Notification.new()
    |> Notification.type(type)
    |> Notification.resource_path(path)
    |> Notification.to(user)
    |> Notifier.notify_user()
  end
end
