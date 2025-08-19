using System;
using System.Collections.Generic;
using System.Diagnostics.Metrics;
using System.Linq;
using System.Reflection.Metadata;
using System.Text;
using System.Threading.Tasks;

namespace ExaminationSystem1
{
    public  class questions
    {
        private string _questiontype;
        private int _mark;
        private int _count;

        public static int c = 0;
        internal bool CorrectAnswer;

        public int Mark { get; set; }
        public int Count { get; private set; } 
        public string Content { get; set; }
        public questions()
        {
            
        }
     
        public questions(int mark)
        {
            Exam exam = new Exam();
            exam.TotalMark += mark;
            Mark = mark;
            c++;
            Count = c;
        }
        public questions(int mark, string content)
        {
            c++;
            Count = c;
            Mark = mark;
            Content = content;
        }
        public virtual void Show() { }



    }
}