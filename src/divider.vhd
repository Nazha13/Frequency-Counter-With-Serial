----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.10.2026 14:18:15
-- Design Name: 
-- Module Name: divider - Behavioral
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

entity divider is
  Port (clk, reset   : in std_logic;
        valid_in     : in std_logic;
        period_in    : in std_logic_vector(24 downto 0);
        valid_out    : out std_logic;
        freq_out     : out std_logic_vector(24 downto 0));
end divider;

architecture Behavioral of divider is

type statetype is (idle, divide, done);
signal state : statetype;
signal denum    : unsigned(26 downto 0) := to_unsigned(0,27);
signal num  : unsigned(26 downto 0) := to_unsigned(50000000,27);
signal output : unsigned(24 downto 0);
signal temp : unsigned(53 downto 0) := (others => '0'); 
signal count : unsigned(4 downto 0) := to_unsigned(27,5);

begin
process(clk, reset)

begin
if reset = '1' then
    temp <= (others => '0');
    valid_out <= '0';
    count <= to_unsigned(26,5);
    denum <= to_unsigned(0,27);
    output <= (others => '0');
    state <= idle;
elsif rising_edge(clk) then 
    if state = idle then
        valid_out <= '0';
        if valid_in = '1' then
            if unsigned(period_in) = 0 then
                temp <= (others => '0');
                state <= done;
            else
                temp(26 downto 0) <= num;
                temp(53 downto 27) <= (others => '0');
                denum <= resize(unsigned(period_in),27);
                count <= to_unsigned(26,5);
                state <= divide;
            end if;
        end if;
    elsif state = divide then
        if temp(52 downto 26) >= denum then
            temp(53 downto 27) <= temp(52 downto 26) - denum;
            temp(26 downto 1) <= temp(25 downto 0);
            temp(0) <= '1';
        else
            temp <= temp(52 downto 0) & '0';
        end if;
        
        if count = 0 then
            state <= done;
        else
            count <= count - 1;
        end if;    
    elsif state = done then
        output <= resize(temp(26 downto 0),25);
        valid_out <= '1';
        state <= idle;
    else
        state <= idle;
    end if; 
end if;
end process;

freq_out <= std_logic_vector(output);

end Behavioral;
