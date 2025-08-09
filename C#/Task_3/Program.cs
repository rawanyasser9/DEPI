using System.Security.AccessControl;
using Task_3;

namespace Task_3
{
    internal class Program
    {
        static void Main(string[] args)
        {
            SavingAccount savingAccount = new SavingAccount("Rawan","12345678912345","01023456789","menofia",5000,5);
            CurrentAccount currentAccount = new CurrentAccount("shahd","32145678912345","01023456987","menofia",5000,1500);
            List <BankAccount> bankAccounts = new List<BankAccount> { savingAccount,currentAccount};

            foreach (BankAccount bankAccount in bankAccounts)
            {
                bankAccount.ShowAccountDetails();
                Console.WriteLine($"Calculated Interest : {bankAccount.CalculateInterest()}"); 
                Console.WriteLine("---------------------------------------");
            }
            Console.ReadLine();
        }
    }
}
