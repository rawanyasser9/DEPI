using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExaminationSystem1
{
    internal class MCQ: questions
    {
        private int _optionid;
        public static int optid =0;
        public int OptCount { get; }

        public List<string> Options { get; set; } = new List<string>();
        public string CorrectAnswer { get; set; }

        public MCQ()
        {

        }
        public MCQ(int mark) : base(mark)
        {
            optid++;
            _optionid = optid;
        }
        public  void Show()
        {
            Console.WriteLine($"[MCQ] Q{Count}: {Content}  (Marks: {Mark})");
            for (int i = 0; i < Options.Count; i++)
            {
                Console.WriteLine($"{i + 1}. {Options[i]}");
            }
        }

    }
}
