defmodule CoursePlanner.OfferedCoursesTest do
  use CoursePlanner.ModelCase
  import CoursePlanner.Factory
  alias CoursePlanner.OfferedCourses

  test "should return the amount of common students by pair of courses" do
    term = insert(:term)

    [student1, student2, student3] = insert_list(3, :student)

    course1 = insert(:offered_course, %{term: term, students: [student1, student2]})
    course2 = insert(:offered_course, %{term: term, students: [student1]})
    course3 = insert(:offered_course, %{term: term, students: [student3]})

    students = OfferedCourses.student_matrix(term.id)

    assert {course1.id, 2} in Map.get(students, course1.id)
    assert {course2.id, 1} in Map.get(students, course1.id)
    assert {course3.id, 0} in Map.get(students, course1.id)
    assert {course1.id, 1} in Map.get(students, course2.id)
    assert {course2.id, 1} in Map.get(students, course2.id)
    assert {course3.id, 0} in Map.get(students, course2.id)
    assert {course1.id, 0} in Map.get(students, course3.id)
    assert {course2.id, 0} in Map.get(students, course3.id)
    assert {course3.id, 1} in Map.get(students, course3.id)
  end

  test "should return the subscribed users of offered_courses" do
    students = insert_list(3, :student)
    teachers = insert_list(2, :teacher)
    insert(:coordinator)

    offered_course1 = insert(:offered_course, students: students, teachers: teachers)
    offered_course2 = insert(:offered_course, students: students, teachers: teachers)

    offered_courses_users = OfferedCourses.get_subscribed_users([offered_course1, offered_course2])
    assert length(offered_courses_users) == 5
  end
end
