using System;
namespace Task_2
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Bank bank1 = new Bank(); // Default values
            Bank bank2 = new Bank("Rawan Yasser", "12345678912345", "01234567890", "Menofia", 50000);
            Bank bank3 = new Bank("shahd Yasser", "12345678915945", "01234511890", "Menofia");


            bank1.ShowAccountDetails();
            Console.WriteLine("----------");
            bank2.ShowAccountDetails();
            Console.WriteLine("----------");
            bank3.ShowAccountDetails();

            Console.WriteLine("\nPress any key to exit...");
            Console.ReadKey();
        }
    }
}
