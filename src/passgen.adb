pragma License (GPL);
------------------------------------------------------------------------------
-- EMAIL: <darkestkhan@gmail.com>                                           --
-- License: GNU GPLv3 or any later as published by Free Software Foundation --
-- (see README file)                                                        --
--                    Copyright © 2013 darkestkhan                          --
------------------------------------------------------------------------------
--  This Program is Free Software: You can redistribute it and/or modify    --
--  it under the terms of The GNU General Public License as published by    --
--    the Free Software Foundation, either version 3 of the license, or     --
--                (at Your option) any later version.                       --
--                                                                          --
--      This Program is distributed in the hope that it will be useful,     --
--      but WITHOUT ANY WARRANTY; without even the implied warranty of      --
--      MERCHANTABILITY or FITNESS for A PARTICULAR PURPOSE. See the        --
--              GNU General Public License for more details.                --
--                                                                          --
--    You should have received a copy of the GNU General Public License     --
--   along with this program. If not, see <http://www.gnu.org/licenses/>.   --
------------------------------------------------------------------------------

  ----------------------------------------------------------------------------
  -- This program generates random alphanumeric passwords of specified      --
  -- length.                                                                --
  ----------------------------------------------------------------------------

with Ada.Text_IO;
with Ada.Numerics.Discrete_Random;
with Ada.Command_Line;
with Ada.Characters.Handling;
procedure PassGen is

  package TIO renames Ada.Text_IO;
  package CLI renames Ada.Command_Line;
  package Random_Char is new Ada.Numerics.Discrete_Random (Character);

  function To_Lower (Item: in String) return String
  is
    Result: String (Item'Range);
  begin
    for I in Item'Range loop
      Result (I) := Ada.Characters.Handling.To_Lower (Item (I));
    end loop;
    return Result;
  end To_Lower;

  Seed: Random_Char.Generator;
  Length: Positive := 20;

begin
  Random_Char.Reset (Seed);

  if CLI.Argument_Count > 0 then
    declare
      S: constant String := CLI.Argument (1);
    begin
      if To_Lower (S) = "help" then
        TIO.Put_Line
          ("This program generates random passwords of specified length.");
        TIO.Put_Line ("Default length is 20 alphanumeric characters.");
      else
        Length := Positive'Value (S);
      end if;
    end;
  end if;

  declare
    Password: String (1 .. Length);
    C: Character;
  begin
    for I in Password'Range loop
      <<Repeat>> -- Used when generated character is not in correct range.
      C := Random_Char.Random (Seed);
      if C in 'a' .. 'z' or C in 'A' .. 'Z' or C in '0' .. '9' then
        Password (I) := C;
      else
        goto Repeat;
      end if;
    end loop;
    TIO.Put_Line (Password);
  end;
end PassGen;
