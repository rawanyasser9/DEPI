using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace calcTask
{
    public static class CalcExtensions
    {
        public static double Add(this double x, double y) => x + y;
        public static double Subtract(this double x, double y) => x - y;
        public static double Multiply(this double x, double y) => x * y;
        public static double Divide(this double x, double y)
        {
            if (y == 0)
            {
                Console.WriteLine("can not divide by zero");
                return 0;
            }
            return x / y;
        }


        public static int Add(this int x, int y) => x + y;
        public static int Subtract(this int x, int y) => x - y;
        public static int Multiply(this int x, int y) => x * y;
        public static int Divide(this int x, int y)
        {
            if (y == 0)
            {
                Console.WriteLine("can not divide by zero");
                return 0;
            }
            return x / y;
        }

    }

    
}
