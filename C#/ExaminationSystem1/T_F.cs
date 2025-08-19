using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExaminationSystem1
{
    public class T_F:questions
    {
        public bool CorrectAnswer { get; set; }
        public T_F(int mark ) : base(mark)
        {

        }
        public T_F(int mark, string content, bool correct) : base(mark, content)
        {
            CorrectAnswer = correct;
        }
        public  void Show()
        {
            Console.WriteLine($"[T/F] Q{Count}: {Content}  (Marks: {Mark})");
        }
    }
}
