using EFCodeFirst.Models;

namespace EFCodeFirst
{
    internal class Program
    {
        static void Main(string[] args)
        {

            MyContext db = new MyContext();

            #region add category
            //db.Categories.Add(new Category { Name = "Sports", Description = "Sports news" });
            //db.Categories.Add(new Category { Name = "Tech", Description = "Technology news" });
            //db.SaveChanges();
            #endregion

            #region add Authors
            //db.Authors.Add(new Author { Name = "Radwa", Username = "radwa1", Password = "123" });
            //db.Authors.Add(new Author { Name = "Rawan", Username = "rawan1", Password = "456" });
            //db.SaveChanges();
            #endregion
            Console.WriteLine("Enter username:");
            string user = Console.ReadLine();
            Console.WriteLine("Enter password:");
            string pass = Console.ReadLine();

            var logged = db.Authors.FirstOrDefault(a => a.Username == user && a.Password == pass);
            if (logged == null)
            {
                Console.WriteLine("Login failed");
                return;
            }

            Console.WriteLine($"Welcome {logged.Name} ");

            logged.ViewProfile();


            int choice = 0;
            do
            {
                Console.WriteLine("--- MENU ---");
                Console.WriteLine("1. Create News");
                Console.WriteLine("2. Update News");
                Console.WriteLine("3. Delete News");
                Console.WriteLine("4. Show My News");
                Console.WriteLine("5. Exit");
                Console.Write("Enter choice: ");
                int.TryParse(Console.ReadLine(), out choice);
                switch (choice)
                {
                    case 1: 
                        Console.Write("Enter title: ");
                        string title = Console.ReadLine();
                        Console.Write("Enter description: ");
                        string desc = Console.ReadLine();
                        Console.Write("Enter Breaf: ");
                        string bre = Console.ReadLine();

                        Console.WriteLine("Choose category:");
                        foreach (var c in db.Categories)
                        {
                            Console.WriteLine($"{c.CategoryId}. {c.Name}");
                        }
                        int catId = int.Parse(Console.ReadLine());

                        var news = new News
                        {
                            Title = title,
                            Description = desc,
                            AuthorId = logged.AuthorId,
                            CategoryId = catId,
                            Breaf= bre,
                            Date = DateTime.Now
                        };
                        db.News.Add(news);
                        db.SaveChanges();
                        Console.WriteLine("News created");
                        break;

                    case 2:
                        Console.Write("Enter News Id to update: ");
                        int nid = int.Parse(Console.ReadLine());
                        var toUpdate = db.News.FirstOrDefault(n => n.NewsId == nid && n.AuthorId == logged.AuthorId);
                        if (toUpdate != null)
                        {
                            Console.Write("Enter new title: ");
                            toUpdate.Title = Console.ReadLine();
                            Console.Write("Enter new description: ");
                            toUpdate.Description = Console.ReadLine();
                            db.SaveChanges();
                            Console.WriteLine("News updated");
                        }
                        else
                        {
                            Console.WriteLine("News not found");
                        }
                        break;

                    case 3:
                        Console.Write("Enter News Id to delete: ");
                        int did = int.Parse(Console.ReadLine());
                        var toDelete = db.News.FirstOrDefault(n => n.NewsId == did && n.AuthorId == logged.AuthorId);
                        if (toDelete != null)
                        {
                            db.News.Remove(toDelete);
                            db.SaveChanges();
                            Console.WriteLine("News deleted");
                        }
                        else
                        {
                            Console.WriteLine("News not found");
                        }
                        break;

                    case 4: 
                        var myNews = db.News
                            .Where(n => n.AuthorId == logged.AuthorId)
                            .ToList();

                        Console.WriteLine($"{logged.Name}'s News:");
                        if (myNews.Count == 0)
                        {
                            Console.WriteLine("No news yet");
                        }
                        else
                        {
                            foreach (var n in myNews)
                            {
                                Console.WriteLine(n);
                            }
                        }
                        break;

                    case 5:
                        Console.WriteLine("Exittt");
                        break;

                    default:
                        Console.WriteLine("Invalid choice.");
                        break;
                }

            } while (choice != 5);

        }
    }
}
