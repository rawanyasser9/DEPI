using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Emit;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace ExaminationSystem1
{
    internal class Exam
    {
        private string _examtitle;
        private int _totalmarks;
        public bool Started { get; set; }

        public int TotalMark { get; set; }
        
        public string ExamTitle { get; set; }

        public List<questions> question { get; set; } = new List<questions>();
    
        public questions Searchquestion(int id)
        {
            foreach (questions q in question)
            {
                if (q.Count == id)
                {
                    return q; 
                }
            }
            return null;
        }



        public void Removeoptions(int mid)
        {

            MCQ q = new MCQ();
            if (mid + 1 == q.OptCount)
            {
                for (int i = mid; i < mid + 2; i++)
                {
                    q.Options.Remove(q.Options[mid + 1]);
                }
            }
            else return;

        }


        public void ShowExam()
        {
            Console.WriteLine($"Exam: {ExamTitle}");
            foreach (questions q in question)
            {
                q.Show();
            }
            Console.WriteLine($"Total Marks: {TotalMark}");
        }

        public void StartExam()
        {
            Started = true;
            Console.WriteLine($"exam:{ExamTitle} is started");
        }

    }
}
