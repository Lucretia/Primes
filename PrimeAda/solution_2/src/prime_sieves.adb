with Ada.Calendar;
with Ada.Text_IO; use Ada.Text_IO;
with Results;

package body Prime_Sieves is
   package IIO is new Integer_IO (Integer);
   use IIO;

   package LIIO is new Integer_IO (Long_Integer);
   use LIIO;

   package Index_IO is new Integer_IO (Bit_Index_Type);
   use Index_IO;

   package DIO is new Fixed_IO (Duration);
   use DIO;

   package BIO is new Enumeration_IO (Boolean);
   use BIO;

   procedure Run (Sieve : in out Prime_Sieve) is
      Factor : Long_Integer := 3;
   begin
      while Factor <= Long_Integer (Q) loop
         declare
            Number : Long_Integer := Factor;
         begin
            --  Ada's for loops don't have a by keyword like Pascal does.
            --  This loop is always incremented by 2 and will always be odd.
            Is_Prime : while Number < Long_Integer (Sieve_Size) loop
               if Sieve.Bits (Bit_Index_Type (Number)) then
                  Factor := Number;

                  exit Is_Prime;
               end if;

               Number := Number + 2;
            end loop Is_Prime;

            --  Probably not a good idea to re-use this loop counter!
            Number := Factor * Factor;

            --  Again, Number is always odd.
            Is_Not_Prime : while Number < Long_Integer (Sieve_Size) loop
               Sieve.Bits (Bit_Index_Type (Number)) := False;

               Number := Number + (Factor * 2);
            end loop Is_Not_Prime;
         end;

         Factor := Factor + 2;
      end loop;
   end Run;

   procedure Print_Results
      (Sieve          : Prime_Sieve;
       Total_Duration : Duration;
       Total_Passes   : Integer;
       Verbose        : Boolean := False) is
   begin
      if Verbose then
         Put ("2, ");
      end if;

      declare
         Count  : Integer      := (if Sieve_Size >= 2 then 1 else 0);
         Number : Long_Integer := 3;
      begin
         --  Again, Number is always odd.
         while Number <= Long_Integer (Sieve_Size) loop
            if Sieve.Bits (Bit_Index_Type (Number)) then
               if Verbose then
                  Put (Number, Width => 0);
               end if;

               Count := Count + 1;
            end if;

            Number := Number + 2;
         end loop;

         if Verbose then
            New_Line;
         end if;

         New_Line;
         Put ("Passes: ");
         Put (Total_Passes, Width => 0);
         Put (", Time: ");
         Put (Total_Duration, Fore => 2, Aft => 6);
         Put (", Avg: ");
         Put (Total_Duration / Duration (Total_Passes), Fore => 2);
         Put (", Limit: ");
         Put (Sieve_Size, Width => 0);
         Put (", Count1: ");
         Put (Count, Width => 0);
         Put (", Count2: ");
         Put (Sieve.Count_Primes, Width => 0);
         Put (", Valid: ");
         Put (Sieve.Validate_Results);

         New_Line;
         New_Line;

         Put ("Lucretia - Object-Oriented;");
         Put (Total_Passes, Width => 0);
         Put (";");
         Put (Total_Duration, Fore => 0, Aft => 6);
         Put (";1;algorithm=base,faithful=yes,bits=");
         IIO.Put (Sieve.Bits (Sieve.Bits'First)'Size, Width => 0);
         New_Line;
      end;
   end Print_Results;

   function Count_Primes (Sieve : Prime_Sieve) return Long_Integer is
      Count : Long_Integer := (if Sieve_Size >= 2 then 1 else 0);
   begin
      declare
         Prime : Long_Integer := 3;
      begin
         --  Again, Number is always odd.
         while Prime < Long_Integer (Sieve_Size) loop
            if Sieve.Bits (Bit_Index_Type (Prime)) then
               Count := Count + 1;
            end if;

            Prime := Prime + 2;
         end loop;
      end;

      return Count;
   end Count_Primes;

   function Validate_Results (Sieve : Prime_Sieve) return Boolean is
      Result : constant Long_Integer := Results.Find (Long_Integer (Sieve_Size));
   begin
      if Result = Results.No_Element then
         return False;
      end if;

      return (Result = Sieve.Count_Primes);
   end Validate_Results;

   procedure Generate is
      use Ada.Calendar;

      Passes_Completed :          Natural  := Natural'First;
      Start_Time       : constant Time     := Clock;
   begin
      Main_Loop : loop
         declare
            Sieve : Prime_Sieve;
         begin
            Sieve.Run;

            Passes_Completed := Passes_Completed + 1;

            if Clock - Start_Time >= Loop_Duration then
               Sieve.Print_Results
                  (Verbose        => False,
                  --  TODO: Is this correct??
                  --  The C++ version of this seem to convert it's time from secons to ms and then back to seconds.
                  Total_Duration => Clock - Start_Time,
                  Total_Passes   => Passes_Completed);
               exit Main_Loop;
            end if;
         end;
      end loop Main_Loop;
   end Generate;
end Prime_Sieves;
