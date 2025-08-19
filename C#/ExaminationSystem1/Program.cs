namespace ExaminationSystem1
{
    internal class Program
    {
        static void Main(string[] args)
        {
            instructors instructor = new instructors();
            courses course = new courses("OOP", "Object Oriented Programming", 100);
            Exam exam = instructor.createExam(course, "OOP Midterm");

            bool exit = false;
            while (!exit)
            {
                Console.WriteLine("Examination System Menu");
                Console.WriteLine("1. Add Question");
                Console.WriteLine("2. Remove Question");
                Console.WriteLine("3. Duplicate Exam to Another Course");
                Console.WriteLine("4. Start Exam");
                Console.WriteLine("5. Show Exam Info");
                Console.WriteLine("6. Exit");
                Console.Write("Enter your choice: ");
                string choice = Console.ReadLine();

                switch (choice)
                {
                    case "1":
                        Console.Write("Enter Question Type (T/M): ");
                        char qType = char.Parse(Console.ReadLine().ToUpper());
                        Console.Write("Enter Mark for Question: ");
                        int mark = int.Parse(Console.ReadLine());

                        instructor.addQuestion(course, exam, qType, mark);
                        break;

                    case "2":
                        Console.Write("Enter Question Type (T/M): ");
                        char rqType = char.Parse(Console.ReadLine());
                        Console.Write("Enter Mark of Question to Remove: ");
                        int rmark = int.Parse(Console.ReadLine());

                        instructor.removeQuestion(exam, rqType, rmark);
                        break;

                    case "3":
                        Console.Write("Enter new Course Title: ");
                        string newTitle = Console.ReadLine();
                        Console.Write("Enter new Course Description: ");
                        string newDesc = Console.ReadLine();

                        courses newCourse = new courses(newTitle, newDesc, course.MaxDegree);
                        instructor.doubleex(exam, newCourse);

                        Console.WriteLine($"Exam duplicated to course {newCourse}");
                        break;

                    case "4":
                        exam.StartExam();
                        break;

                    case "5":
                        Console.WriteLine($"Exam Title: {exam.ExamTitle}");
                        Console.WriteLine($"Total Mark: {exam.TotalMark}");
                        Console.WriteLine($"Questions Count: {exam.question.Count}");
                        foreach (questions q in exam.question)
                        {
                            Console.WriteLine($"- Q: {q.Content}, Mark: {q.Mark}");
                        }
                        break;

                    case "6":
                        exit = true;
                        break;

                    default:
                        Console.WriteLine("Invalid choice. Try again.");
                        break;
                }
            }
        }



    }
}
