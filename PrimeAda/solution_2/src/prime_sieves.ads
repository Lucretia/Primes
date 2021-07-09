--  Object-Oriented version.
with Ada.Containers.Ordered_Maps;

generic
   type Bit_Index_Type is range <>;
   type Boolean_Array_Type is array (Bit_Index_Type) of Boolean;

   with function "<" (LHS, RHS : Bit_Index_Type) return Boolean is <>;
package Prime_Sieves is
   package Result_Maps is new Ada.Containers.Ordered_Maps
      (Key_Type     => Long_Long_Integer,
       Element_Type => Integer);

   Results : Result_Maps.Map;

   type Prime_Sieve (Size : Bit_Index_Type) is tagged record
      Bits : Boolean_Array_Type := (others => True);
   end record;

   procedure Run (Sieve : in out Prime_Sieve);
   procedure Print_Results
      (Sieve          : Prime_Sieve;
       Total_Duration : Duration;
       Total_Passes   : Integer;
       Verbose        : Boolean := False);
   function Count_Primes (Sieve : Prime_Sieve) return Integer;
   function Validate_Results (Sieve : Prime_Sieve) return Boolean;
   procedure Generate;
end Prime_Sieves;
