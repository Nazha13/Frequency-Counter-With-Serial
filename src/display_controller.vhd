----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.10.2026 12:30:25
-- Design Name: 
-- Module Name: display_controller - Behavioral
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

entity display_controller is
  Port (clk, reset : in std_logic; 
        bcd_in     : in std_logic_vector(15 downto 0);
        active_bit : out std_logic_vector(7 downto 0);
        bcd_out    : out std_logic_vector(6 downto 0));
end display_controller;

architecture Behavioral of display_controller is

component sevseg is
  Port (a : in std_logic_vector(3 downto 0);
        y : out std_logic_vector(6 downto 0));
end component;

type statetype is (bit1, bit2, bit3, bit4);
signal state : statetype;
signal count : unsigned(15 downto 0) := to_unsigned(0,16);
signal config : std_logic_vector(7 downto 0):= "11110000";
signal nibble : std_logic_vector(3 downto 0) := "0000";

begin
process(clk, reset)
begin
if reset = '1' then
    state <= bit1;
    count <= to_unsigned(0,16);
    config <= "11111110";
    nibble <= "0000";
elsif rising_edge(clk) then
    if state = bit1 then
        if count = 50000 then
            state <= bit2;
            count <= to_unsigned(0,16);
            config <= "11111101";
            nibble <= bcd_in(7 downto 4);
        else
            config <= "11111110";
            nibble <= bcd_in(3 downto 0);
            count <= count + 1;
        end if;
    elsif state = bit2 then
        if count = 50000 then
            state <= bit3;
            count <= to_unsigned(0,16);
            config <= "11111011";
            nibble <= bcd_in(11 downto 8);
        else
            config <= "11111101";
            nibble <= bcd_in(7 downto 4);
            count <= count + 1;
        end if;
    elsif state = bit3 then
        if count = 50000 then
            state <= bit4;
            count <= to_unsigned(0,16);
            config <= "11110111";
            nibble <= bcd_in(15 downto 12);
        else
            config <= "11111011";
            nibble <= bcd_in(11 downto 8);
            count <= count + 1;
        end if;
    elsif state = bit4 then
        if count = 50000 then
            state <= bit1;
            count <= to_unsigned(0,16);
            config <= "11111110";
            nibble <= bcd_in(3 downto 0);
        else
            config <= "11110111";
            nibble <= bcd_in(15 downto 12);
            count <= count + 1;
        end if;
    end if;             
end if;
end process;

active_bit <= config;
decode : sevseg port map(a => nibble, y => bcd_out);

end Behavioral;
