using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExaminationSystem1
{
    internal class instructors
    {
        private int _id;
        private string _name;
        private string _specialization;
        public string Name { get; set; }
        public int ID { get; set; }

        public List<courses> course { get; set; } = new List<courses>();

        public Exam createExam(courses course, string examTitle)
        {
            Exam exam = new Exam();
            exam.ExamTitle = examTitle;
            course.exams.Add(exam);
            return exam;
        }




        public bool addQuestion(courses cour, Exam ex, char type, int m)
        {

            if (ex.Started)
            {
                Console.WriteLine("canot add questions once exam started");
                return false;
            }

            if (ex.TotalMark + m > cour.MaxDegree)
            {
                Console.WriteLine("not allowed to add mor questions");
                return false;
            }

            switch (type)
            {
                case 'T':
                    Console.WriteLine("PLZ enter question :");
                    questions t_F = new T_F(m);
                    t_F.Content = Console.ReadLine();
                    Console.Write("Enter correct answer (true/false): ");
                    t_F.CorrectAnswer = bool.Parse(Console.ReadLine());
                    ex.question.Add(t_F);
                    ex.TotalMark += m;
                    return true;
                case 'M':
                    Console.WriteLine("PLZ enter question :");
                    MCQ mcq = new MCQ(m);
                    mcq.Content = Console.ReadLine();
                    Console.WriteLine("PLZ two options for this question:");
                    for (int i = 0; i < 2; i++)
                    {
                        Console.WriteLine($"enter {i + 1} option ");
                        mcq.Options.Append(Console.ReadLine());
                    }
                    Console.Write("Enter correct answer: ");
                    mcq.CorrectAnswer = Console.ReadLine();
                    ex.question.Add(mcq);
                    ex.TotalMark += m;

                    return true;
                default:
                    Console.WriteLine("invalid choice PLZ try again");
                    return false;
            }
        }



        public bool removeQuestion(Exam ex, char type, int m)
        {

            if (ex.Started)
            {
                Console.WriteLine("canot add questions once exam started");
                return false;
            }
            switch (type)
            {
                case 'T':
                    Console.WriteLine("PLZ enter question id:");
                    int id = int.Parse(Console.ReadLine());
                    ex.question.Remove(ex.Searchquestion(id));
                    ex.TotalMark -= m;
                    return true;
                case 'M':
                    Console.WriteLine("PLZ enter question id:");
                    int mid = int.Parse(Console.ReadLine());
                    ex.question.Remove(ex.Searchquestion(mid));
                    ex.Removeoptions(mid);
                    ex.TotalMark -= m;
                    return true;
                default:
                    Console.WriteLine("invalid choice PLZ try again");
                    return false;
            }
        }


        public void doubleex(Exam ex, courses cou)
        {
            cou.exams.Add(ex);
        }


    }
}