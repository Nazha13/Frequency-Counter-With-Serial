----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.10.2026 12:25:53
-- Design Name: 
-- Module Name: synchronizer - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity synchronizer is
  Port (clk, reset, async_in : in std_logic;
        sync_out             : out std_logic);
end synchronizer;

architecture Behavioral of synchronizer is

signal Q1, Q2 : std_logic := '0';

begin

process(clk, reset)
begin
if reset = '1' then
    Q1 <= '0';
    Q2 <= '0';
elsif rising_edge(clk) then
    Q1 <= async_in;
    Q2 <= Q1;
end if;
end process;

sync_out <= Q2;

end Behavioral;
