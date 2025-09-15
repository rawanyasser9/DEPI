using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EFCodeFirst.Models
{
    public class Category
    {
        public int CategoryId { get; set; }

        public string Name { get; set; }

        public string Description { get; set; }


        public virtual ICollection<News> News { get; set; } = new HashSet<News>();
    }
}
