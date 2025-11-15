package com.student;
import com.student.dao.StudentDAO;
import com.student.model.Student;
import java.util.List;

public class Main {
    public static void main(String[] args) {
        StudentDAO dao = new StudentDAO();
        List<Student> students = dao.getAllStudents();
        for (Student s : students) {
            System.out.println(s);
        }

    }
}
