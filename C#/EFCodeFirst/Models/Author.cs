using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EFCodeFirst.Models
{
    public class Author
    {
        public int AuthorId { get; set; }

        public string Name { get; set; }
        public string Username { get; set; }

        public string Password { get; set; }

        public DateTime JoinDate { get; set; } = DateTime.Now;

        public virtual ICollection<News> News { get; set; } = new HashSet<News>();


   
        public void ViewProfile()
        {
            Console.WriteLine($"Author: {Name}");
            Console.WriteLine($"Username: {Username}");
            Console.WriteLine($"Join Date: {JoinDate}");
            Console.WriteLine($"Total News: {News.Count}");
        }

       

    }
}
