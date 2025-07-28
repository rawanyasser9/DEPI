namespace Task_1
{
    internal class Program
    {
        static void Main(string[] args)
        {
            while (true)
            {
                Console.WriteLine("Hello!");
                double num1, num2;
                try
                {
                    Console.Write("Input the first number: ");
                    num1 = double.Parse(Console.ReadLine());
                }
                catch (FormatException)
                {
                    Console.WriteLine("Invalid input. Not a number!");
                    continue;
                }

                try
                {
                    Console.Write("Input the second number: ");
                    num2 = double.Parse(Console.ReadLine());
                }
                catch (FormatException)
                {
                    Console.WriteLine("Invalid input. Not a number!");
                    continue;
                }

                Console.WriteLine("What do you want to do with those numbers?\r\n[A]dd\r\n[S]ubtract\r\n[M]ultiply\r\n");
                char c = (char)Console.Read();
                    switch (c)
                    {
                        case 'A':
                        case 'a':
                            Console.WriteLine("Summation = " + (num1 + num2));
                            break;
                        case 's':
                        case 'S':
                            Console.WriteLine("Subtraction = " + (num1 - num2));
                            break;
                        case 'M':
                        case 'm':
                            Console.WriteLine(" multiplication = " + (num1 * num2));
                            break;
                        default:
                            Console.WriteLine("invalid choice ");
                            Console.WriteLine("PLZ input a s or a or m ");
                            break;
                    }

                Console.WriteLine("Press Y/y if you want to calculate again, \n " +
                                  "OR Press any key to close\r\n");
                Console.ReadLine();
                char choice = (char)Console.Read();
                Console.ReadLine();
                if (choice == 'Y' || choice == 'y')
                    continue;
                else  
                    break;

            }
        }
    }
}
