using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExaminationSystem1
{
    internal class students
    {
        private int _id;
        private string _name;
        private string _email;

        private static int counter = 0;

        public int Id { get; }
        public string Name { get; set; }
        public string Email { get; set; }



        public students(string name, string email)
        {
            Id = ++counter;
            Name = name;
            Email = email;
        }
        public void Report()
        {
            Console.WriteLine($"Student ID   : {Id}");
            Console.WriteLine($"Student Name : {Name}");
            Console.WriteLine($"Student Email: {Email}");
        }


    }
}
