using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EFCodeFirst.Models
{
    public class News
    {
        public int NewsId { get; set; }

        public string Title { get; set; }

        public string Breaf { get; set; } 

        public string Description { get; set; }

        public DateTime Date { get; set; }

        // Foreign keys
        public int AuthorId { get; set; }
        public virtual Author Author { get; set; }

        public int CategoryId { get; set; }
        public virtual Category Category { get; set; }

        public override string ToString()
        {
            return $"[{NewsId}] {Title} - {Description} ({Date}) by {Author.Name}";
        }

    }
}
