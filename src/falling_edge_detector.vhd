----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.10.2026 15:25:04
-- Design Name: 
-- Module Name: falling_edge_detector - Behavioral
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

entity falling_edge_detector is
  Port (clk, reset, sync_in : in std_logic;
        pulse_out : out std_logic);
end falling_edge_detector;

architecture Behavioral of falling_edge_detector is

signal sync_delayed : std_logic := '0';

begin
process(clk, reset)
begin
if reset = '1' then
    sync_delayed <= '0';
elsif rising_edge(clk) then
    sync_delayed <= sync_in;
end if;
end process;

pulse_out <= (not sync_in) and sync_delayed;

end Behavioral;
