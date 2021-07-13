with Ada.Text_IO;       use Ada.Text_IO;

package body Bitsets is
   procedure Stats (Bits : in Bitset) is
   begin
      Put ("Bits'First: ");
      Put (Bits'First'Image);
      New_Line;

      Put ("Bits'Last: ");
      Put (Bits'Last'Image);
      New_Line;

      Put ("Bits'Length: ");
      Put (Bits'Length'Image);
      New_Line;

      Put ("Bits'Size: ");
      Put (Bits'Size'Image);
      New_Line;

      Put ("Bits (Bits'First)'Size: ");
      Put (Bits (Bits'First)'Size'Image);
      New_Line;
   end Stats;

   procedure Clear (Bits : in out Bitset; Bit : Long_Integer) is
      use type Sub_Bitset;

      Index  : constant Long_Integer := Bit / Sub_Bitset'Size + 1;
      Offset : constant Sub_Bitset   := Sub_Bitset (Bit) rem Sub_Bitset'Size;
   begin
      Bits (Index) := Bits (Index) and (not I.Shift_Left (1, Natural (Offset)));
   end Clear;

   function Get (Bits : Bitset; Bit : Long_Integer) return Boolean is
      use type Sub_Bitset;

      Index  : constant Long_Integer := Bit / Sub_Bitset'Size + 1;
      Offset : constant Sub_Bitset   := Sub_Bitset (Bit) rem Sub_Bitset'Size;
      Mask   : constant Sub_Bitset   := I.Shift_Left (1, Natural (Offset));
   begin
      return (if (Bits (Index) and Mask) /= 0 then True else False);
   end Get;
end Bitsets;
