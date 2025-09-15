using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;

namespace LINQtoObject
{
    class Program
    {
        static void Main(string[] args)
        {
            #region 1-	Display book title and its ISBN.
            Console.WriteLine("Query:1");
            // query operator
            var query = SampleData.Books.Select(b => new { b.Title, b.Isbn });
            foreach (var item in query)
            {
                Console.WriteLine($"Title: {item.Title} , Isbn: {item.Isbn}");
            }

            Console.WriteLine("--------------");
            //query expression

            var query1 = from b in SampleData.Books
                         select new { b.Title, b.Isbn };

            foreach (var item in query1)
            {
                Console.WriteLine($"Title: {item.Title} , Isbn: {item.Isbn}");
            }
            #endregion
            Console.WriteLine("========================================");

            #region 2-	Display the first 3 books with price more than 25.
            Console.WriteLine("Query:2");
            // query operator

            var query2 = SampleData.Books.Where(b => b.Price > 25).Take(3);

            foreach (var item in query2)
            {
                Console.WriteLine($"Title: {item.Title} ,Price : {item.Price} ");
            }
            //query expression
            Console.WriteLine("---------------");
            var query3 = (from b in SampleData.Books
                          where b.Price > 25
                          select new { b.Title, b.Price }).Take(3);

            foreach (var item in query3)
            {
                Console.WriteLine($"Title: {item.Title} ,Price : {item.Price} ");
            }
            #endregion
            Console.WriteLine("========================================");

            #region 3- Display Book title along with its publisher name.
            Console.WriteLine("Query 3:");

            var query4 = SampleData.Books.Select(b => new { b.Title, publisherName = b.Publisher.Name });

            foreach (var item in query4)
            {
                Console.WriteLine($"Title: {item.Title} ,Publisher Name : {item.publisherName} ");
            }
            Console.WriteLine("--------------");
            var query5 = from b in SampleData.Books
                         select new { b.Title, publisherName = b.Publisher.Name };

            foreach (var item in query5)
            {
                Console.WriteLine($"Title: {item.Title} ,Publisher Name : {item.publisherName} ");
            }
            #endregion
            Console.WriteLine("========================================");

            #region 4-	Find the number of books which cost more than 20.
            Console.WriteLine("Query 4:");

            var query6 = SampleData.Books.Count(b => b.Price > 20);
            Console.WriteLine($"Number of books whose price more than 20 is {query6} ");

            Console.WriteLine("----------------");
            var query7 = (from b in SampleData.Books
                          where b.Price > 20
                          select b).Count();

            Console.WriteLine($"Number of books whose price more than 20 is {query7} ");

            #endregion
            Console.WriteLine("========================================");

            #region 5-	Display book title, price and subject name sorted by its subject name ascending and by its price descending.
            Console.WriteLine("Query 5:");

            var query8 = SampleData.Books.Select(b => new { b.Title, b.Price, subjectName = b.Subject.Name })
                                         .OrderBy(b => b.subjectName).ThenByDescending(b => b.Price);

            foreach (var item in query8)
            {
                Console.WriteLine($"Title : {item.Title} , Price : {item.Price} , Subject Name : {item.subjectName}");
            }

            Console.WriteLine("----------------");

            var query9 = from b in SampleData.Books
                         orderby b.Subject.Name, b.Price descending
                         select new { b.Title, b.Price, subjectName = b.Subject.Name };

            foreach (var item in query9)
            {
                Console.WriteLine($"Title : {item.Title} , Price : {item.Price} , Subject Name : {item.subjectName}");
            }

            #endregion
            Console.WriteLine("========================================");

            #region 6-	Display All subjects with books related to this subject. 

            Console.WriteLine("Query 6:");

            var query10 = from sub in SampleData.Subjects
                          select new
                          {
                              subjectName = sub.Name,
                              book = from b in SampleData.Books
                                     where b.Subject.Name == sub.Name
                                     select b
                          };
            foreach (var s in query10)
            {
                Console.WriteLine($"Subject Name : {s.subjectName}");
                foreach (var b in s.book)
                {
                    Console.WriteLine($"Title : {b.Title} , Price : {b.Price} , Publisher : {b.Publisher}");
                }
            }

            Console.WriteLine("-------------------------");

            var query11 = from b in SampleData.Books
                          group b by b.Subject into g
                          select new { subjectName = g.Key.Name, book = g };

            foreach (var grp in query11)
            {
                Console.WriteLine($"Subject Name : {grp.subjectName} ");
                foreach (var b in grp.book)
                {
                    Console.WriteLine($" Title : {b.Title} , Price : {b.Price} , Publisher : {b.Publisher}");
                }
            }
            #endregion

            Console.WriteLine("========================================");

            #region 7-	Try to display book title & price (from book objects) returned from GetBooks Function.

            Console.WriteLine("Query 7:");

            var query12 = from book in SampleData.GetBooks().ToArray()
                          select book;

            foreach (var bo in query12)
            {
                Console.WriteLine($"{bo}");
            }
           
            Console.WriteLine("-------------------------");

            var query13 = SampleData.GetBooks();

            foreach (var b in query13)
            {
                Console.WriteLine($"{b}");
            }
            #endregion

            Console.WriteLine("========================================");

            #region 8-	Display books grouped by publisher & Subject.

            Console.WriteLine("Query 8:");

            var query14 =
                from b in SampleData.Books
                group b by b.Publisher into gp
                select new
                {
                    PublisherName = gp.Key.Name,
                    Sub = from b in gp
                          group b by b.Subject into gs
                          select new
                          {
                              SubjectName = gs.Key.Name,
                              book=gs
                          }
                };
            foreach (var grp in query14)
            {
                Console.WriteLine($"Publisher : {grp.PublisherName}");
                foreach (var grs in grp.Sub)
                {
                    Console.WriteLine($"Subject : {grs.SubjectName}");
                    foreach (var b in grs.book)
                    {
                        Console.WriteLine($"Book Title: {b.Title}");

                    }
                    Console.WriteLine();

                }
            }


            Console.WriteLine("-------------------------");

            var query15 = SampleData.Books.GroupBy(p => p.Publisher)
                     .Select(ps => new
                     {
                         PublisherName = ps.Key.Name,
                         subject = ps.GroupBy(s => s.Subject)
                                   .Select(b => new
                                   {
                                       SubjectName = b.Key.Name,
                                       book = b
                                   })
                     });

            foreach (var p in query15)
            {
                Console.WriteLine($"Publisher : {p.PublisherName}");
                foreach (var s in p.subject)
                {
                    Console.WriteLine($"Subject : {s.SubjectName}");
                    foreach(var b in s.book)
                    {
                        Console.WriteLine($"Book Title : {b.Title}");
                    }
                    Console.WriteLine();

                }
            }
          
            #endregion

            Console.WriteLine("========================================");

            #region 9*************

            Console.WriteLine("Query 9:");
            /*   	Ask the user for a publisher name & sorting method (sorting criteria (by Title, price, etc….)
             *      and sorting way (ASC. Or DESC.))…. 
             *      And implement a function named FindBooksSorted() 
             *      that displays all books written by this Author sorted as the user requested.
             */
            Console.WriteLine("Please Enter Pubisher Name :");
            var pub = (Console.ReadLine()).ToLower();
            Console.WriteLine("Please Enter sorting method :");
            Console.WriteLine("Please Enter 1 --> Title ");
            Console.WriteLine("OR 2 --> Authors ");
            Console.WriteLine("OR 3 --> PageCount ");
            Console.WriteLine("OR 4 --> Price ");
            Console.WriteLine("OR 5 --> PublicationDate ");
            var smethod = int.Parse(Console.ReadLine());
            Console.WriteLine("Please Enter sorting way (asc/desc): ");
            var sway = (Console.ReadLine()).ToLower();
            var query16 = SampleData.Books.FindBooksSorted(pub, smethod, sway);

            foreach (var p in query16)
            {
                Console.WriteLine($"{p.Title} | {p.Authors.First().FirstName} | {p.PageCount} pages | {p.Price} | {p.PublicationDate} | {p.Publisher.Name}");
            }

            #endregion

            Console.WriteLine("========================================");



            Console.ReadKey();
        }
    }
}
