----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.10.2026 13:01:09
-- Design Name: 
-- Module Name: period_counter - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity period_counter is
  Port (clk, reset, pulse_in : in std_logic;
        data_valid           : out std_logic;
        period_ticks         : out std_logic_vector(24 downto 0));
end period_counter;

architecture Behavioral of period_counter is

signal count : unsigned(24 downto 0) := to_unsigned(0,25);

begin
process(clk, reset)
begin
if reset = '1' then
    count <= to_unsigned(0,25);
    period_ticks <= (others => '0');
    data_valid <= '0';
elsif rising_edge(clk) then
    if pulse_in = '1' then
        period_ticks <= std_logic_vector(count);
        data_valid <= '1';
        count <= to_unsigned(0,25);
    else
    -- adjusted to count with a cycle clock of 50 MHz => 5 Hz is now 10000000 ticks per period
        if count >= to_unsigned(10000000,25) then
            period_ticks <= (others => '0');
            data_valid <= '1';
            count <= to_unsigned(0,25);
        else
            count <= count + 1;
            data_valid <= '0';
        end if;
    end if; 
end if;
end process;

end Behavioral;
