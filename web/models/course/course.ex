defmodule CoursePlanner.Course do
  @moduledoc """
  This module holds the model for the course table
  """
  use CoursePlanner.Web, :model

  alias CoursePlanner.{OfferedCourse, Types}

  schema "courses" do
    field :name, :string
    field :description, :string
    field :number_of_sessions, :integer
    field :session_duration, Ecto.Time
    field :syllabus, :string
    field :status, Types.EntityStatus
    field :deleted_at, :naive_datetime

    has_many :classes, CoursePlanner.Class

    has_many :offered_courses, OfferedCourse, on_replace: :delete
    has_many :terms, through: [:offered_courses, :term]

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    target_params =
      [
        :name,
        :description,
        :number_of_sessions,
        :session_duration,
        :syllabus, :status, :deleted_at
      ]

    struct
    |> cast(params, target_params)
    |> validate_required([:name, :description, :number_of_sessions, :session_duration, :status])
    |> validate_number(:number_of_sessions, greater_than: 0, less_than: 100_000_000)
  end

  def changeset(struct, params, :create) do
    struct
    |> changeset(params)
    |> validate_inclusion(:status, ["Planned", "Active"])
  end
end
