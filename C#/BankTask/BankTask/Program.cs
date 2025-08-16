using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace BankTask
{
    public class Program
    {
        static void Main(string[] args)
        {
            Bank bank = new Bank ("Bank Misr","Bank100" );


            bool exit = false;

            while (!exit)
            {
                Console.WriteLine("Welcome to Bank System Menu \nPLZ press any num from 1 to 7 :");
                Console.WriteLine("1. Add Savings Account");
                Console.WriteLine("2. Add Current Account");
                Console.WriteLine("3. Deposit");
                Console.WriteLine("4. Withdraw");
                Console.WriteLine("5. Show All Accounts");
                Console.WriteLine("6. Show Bank Report");
                Console.WriteLine("7. Exit");
                Console.Write("Choose option: ");
                string choice = Console.ReadLine();

                switch (choice)
                {
                    case "1":
                        Console.Write("Enter Customer Name: ");
                        string sName = Console.ReadLine();

                        Console.Write("Enter SSN: ");
                        string sSSN = Console.ReadLine();

                        Console.Write("Enter Initial Balance: ");
                        double sBalance = double.Parse(Console.ReadLine());

                        Console.Write("Enter Birth Date : ");
                        DateTime sBirth = DateTime.Parse(Console.ReadLine());

                        Console.Write("Enter Interest Rate %: ");
                        double rate = double.Parse(Console.ReadLine());

                        Savings_account saving = new Savings_account(bank.Name, bank.BranchCode, sName, sSSN, sBalance, sBirth, rate);
                        bank.AddCustomer(saving);
                        Console.WriteLine("Saving account created successfully");
                        break;

                    case "2":
                        Console.Write("Enter Customer Name: ");
                        string cName = Console.ReadLine();

                        Console.Write("Enter SSN: ");
                        string cSSN = Console.ReadLine();

                        Console.Write("Enter Initial Balance: ");
                        double cBalance = double.Parse(Console.ReadLine());

                        Console.Write("Enter Birth Date (yyyy-mm-dd): ");
                        DateTime cBirth = DateTime.Parse(Console.ReadLine());

                        Console.Write("Enter Overdraft Limit: ");
                        double overdraft = double.Parse(Console.ReadLine());

                        Current_account current = new Current_account(bank.Name, bank.BranchCode, cName, cSSN, cBalance, cBirth, overdraft);
                        bank.AddCustomer(current);
                        Console.WriteLine("Current account created successfully");
                        break;

                    case "3":
                        Console.Write("Enter Account Number: ");
                        int depAccNum = int.Parse(Console.ReadLine());

                        Console.Write("Enter Amount to Deposit: ");
                        double depAmount = double.Parse(Console.ReadLine());
                        
                        CustomerAcc depAccount = null;

                        foreach (CustomerAcc acc in bank.CustomersAcc)
                        {
                            if (acc.AccountNumber == depAccNum)
                            {
                                depAccount = acc;
                                break;
                            }
                        }
                        if (depAccount != null)
                            depAccount.Deposit(depAmount);
                        else
                            Console.WriteLine("Account not found!");

                        break;

                    case "4":
                        Console.Write("Enter Account Number: ");
                        int withAccNum = int.Parse(Console.ReadLine());

                        Console.Write("Enter Amount to Withdraw: ");
                        double withAmount = double.Parse(Console.ReadLine());

                        CustomerAcc withAccount = null;

                        foreach (CustomerAcc acc in bank.CustomersAcc)
                        {
                            if (acc.AccountNumber == withAccNum)
                            {
                                withAccount = acc;
                                break;
                            }
                        }
                        if (withAccount != null)
                            withAccount.Withdrawing(withAmount);
                        else
                            Console.WriteLine("Account not found!");
                        break;

                    case "5":
                        Console.WriteLine("--- All Accounts ---");
                        foreach (var acc in bank.CustomersAcc)
                        {
                            acc.ShowAccountDetails();
                            Console.WriteLine("---------------------------------");
                        }
                        break;

                    case "6":
                        Console.WriteLine("\n--- Bank Report ---\n");
                        bank.ShowReport();
                        break;

                    case "7":
                        exit = true;
                        Console.WriteLine(" Exiting");
                        break;

                    default:
                        Console.WriteLine("Invalid option, try again");
                        break;


                        Console.ReadLine();
                }

            }
        }
    }
}