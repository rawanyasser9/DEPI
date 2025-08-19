using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExaminationSystem1
{
    internal class courses
    {
        private string _title;
        private string _description;
        private int _maxdegree;
        public string Title { get; set; }
        public string Description { get; set; }
        public int MaxDegree { set; get; }
        public List<students> student { get; set; } = new List<students>();
        public List<Exam> exams { get; set; } = new List<Exam>();

        public courses(string title, string description)
        {
            _title = title;
            _description = description;
        }
        public courses(string title, string description, int maxDegree)
        {
            Title = title;
            Description = description;
            MaxDegree = maxDegree;
        }

    }
}
