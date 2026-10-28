----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.10.2026 12:06:30
-- Design Name: 
-- Module Name: doubdab - Behavioral
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

entity doubdab is
  Port (clk, reset, valid_in : in std_logic;
        freq_in    : in std_logic_vector(24 downto 0);
        bcd_out    : out std_logic_vector(15 downto 0);
        valid_out  : out std_logic);
end doubdab;

architecture Behavioral of doubdab is

signal output : unsigned(15 downto 0) := to_unsigned(0,16);

begin
process(clk, reset)

variable dab_register : unsigned(29 downto 0);

begin
if reset = '1' then
    dab_register := (others => '0');
    output <= (others => '0');
    valid_out <= '0';
elsif rising_edge(clk) then
    valid_out <= '0';
    if valid_in = '1' then
        if unsigned(freq_in) > 9999 then
            dab_register(29 downto 14) := (others => '0');
            dab_register(13 downto 0) := to_unsigned(9999,14);
        else
            dab_register(29 downto 14) := (others => '0');
            dab_register(13 downto 0) := unsigned(freq_in(13 downto 0));
        end if;
    
        for i in 13 downto 0 loop
            if dab_register(17 downto 14) >= 5 then
                dab_register(17 downto 14) := dab_register(17 downto 14) + 3;
            end if;
            if dab_register(21 downto 18) >= 5 then
                dab_register(21 downto 18) := dab_register(21 downto 18) + 3;
            end if;
            if dab_register(25 downto 22) >= 5 then
                dab_register(25 downto 22) := dab_register(25 downto 22) + 3;
            end if;
            if dab_register(29 downto 26) >= 5 then
                dab_register(29 downto 26) := dab_register(29 downto 26) + 3;
            end if;
        
            dab_register := dab_register(28 downto 0) & '0';
        end loop;
    
        output <= dab_register(29 downto 14);
        valid_out <= '1';
        end if;
    end if;
end process;

    bcd_out <= std_logic_vector(output);

end Behavioral;
