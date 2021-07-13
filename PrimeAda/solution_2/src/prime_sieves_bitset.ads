--  Imperative version.
with Ada.Numerics.Generic_Elementary_Functions;
with Bitsets;

generic
   Loop_Duration : Duration;
   Sieve_Size    : Long_Integer;

   -- type Bit_Index_Type is range <>;
   -- type Boolean_Array_Type is array (Bit_Index_Type) of Boolean;
package Prime_Sieves_Bitset is
   procedure Generate;
private
   package Long_Float_Ops is new Ada.Numerics.Generic_Elementary_Functions (Long_Float);
   use Long_Float_Ops;

   -- Sieve_Size :          Bit_Index_Type := Bit_Index_Type'Last;
   Q          : constant Long_Integer := Long_Integer (Sqrt (Long_Float (Sieve_Size)));

   subtype Bitset is Bitsets.Bitset (1 .. Sieve_Size / Bitsets.Sub_Bitset'Size);

   True_Bits : constant Bitset := (others => Bitsets.Sub_Bitset'Last);
   -- True_Bits : constant Boolean_Array_Type := (others => True);

   type Prime_Sieve is record
      Bits : Bitset := True_Bits;
   end record with
     Preelaborable_Initialization;

   procedure Run (Sieve : in out Prime_Sieve);
   procedure Print_Results
      (Sieve          : Prime_Sieve;
       Total_Duration : Duration;
       Total_Passes   : Integer;
       Verbose        : Boolean := False);
   function Count_Primes (Sieve : Prime_Sieve) return Long_Integer with
     Inline;
   function Validate_Results (Sieve : Prime_Sieve) return Boolean with
     Inline;
end Prime_Sieves_Bitset;
