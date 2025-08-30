namespace calcTask
{
    internal class Program
    {
        static void Main(string[] args)
        {
            int x = 10;
            double y = 10.5;

            Console.WriteLine(x.Add(5));           
            Console.WriteLine(x.Subtract(3));     
            Console.WriteLine(x.Multiply(4));        
            Console.WriteLine(x.Divide(2));          
     
            Console.WriteLine(y.Add(2.5));          
            Console.WriteLine(y.Divide(2.5));        
          
            var result = x.Add(5).Multiply(2).Subtract(3);
            Console.WriteLine(result);              


        }
    }
}
