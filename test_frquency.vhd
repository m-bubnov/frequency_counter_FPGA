----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.10.2020 17:20:33
-- Design Name: 
-- Module Name: main - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_frquency is
    Port ( in_signal : in STD_LOGIC;
           CLK : in STD_LOGIC;
           SEG_OUT : out STD_LOGIC_VECTOR (6 downto 0);
           anod_activate : out STD_LOGIC_VECTOR (3 downto 0));
end test_frquency;

architecture Behavioral of test_frquency is

signal counter_input: std_logic_vector(23 downto 0);  -- счет для входного сигнала
signal counter_seg: std_logic_vector(23 downto 0);   -- счет для обновления индикаторов
signal anod_activation: std_logic_vector(1 downto 0);  --выбирает матрицу
signal SEG_IN: std_logic_vector(3 downto 0);  --записывает значения сегментов
signal num0: std_logic_vector (3 downto 0);
signal num1: std_logic_vector (3 downto 0);
signal num2: std_logic_vector (3 downto 0);
signal num3: std_logic_vector (3 downto 0);

begin

process(CLK)  -- отчет 1 секунды
begin
    if CLK'event and CLK='1' then 
        counter_input <= counter_input + 1;
        if counter_input > 9999999 then
        counter_input <= "000000000000000000000000";
        end if;
    end if;
end process;

process(counter_input)  -- количество входных ипульсов
begin
if in_signal'event and in_signal='1' then      
        num0 <= num0 + 1;
        if num0 = 9 then 
            num0 <= "0000";
            num1 <= num1 + 1;
            if num1 = 9 then 
                num2 <= num2 + 1;
                num1 <= "0000";
                    
                    if num2 = 9 then 
                        num3 <= num3 + '1';
                        num2 <= "0000";
                            if num3 = 9 then 
                                num3 <= "1001";
                            end if;
                        if num2 = 9 and num3 = 9 then 
                            num2 <= "1001";
                        end if;
                    
                      end if;
                if num1 = 9 and num2 = 9 and num3 = 9 then 
                   num1 <= "1001";
                end if;
            end if;
            if num0 = 9 and num1 = 9 and num2 = 9 and num3 = 9 then 
                num0 <= "1001";
            end if;
        end if;
end if;   
    if counter_input = 9999999 then 
    num0 <= "0000";
    num1 <= "0000";
    num2 <= "0000";
    num3 <= "0000";    
    end if; 
end process;


process(CLK)  -- процесс для обновления матриц индикатора
begin
    if CLK'event and CLK='1' then 
        counter_seg <= counter_seg + 1;
        if anod_activation = 4 then
        anod_activation <= "00";
        else 
        anod_activation <= anod_activation + 1;
        end if;
        if counter_seg = 9999999 then 
        counter_seg <= "000000000000000000000000";
        end if;
    end if;
end process;

process(anod_activation)
begin
    case (anod_activation) is
    when "11" => 
        anod_activate <= "1110"; -- активируется первый индикатор
        SEG_IN <= num0;
    when "10" => 
        anod_activate <= "1101"; -- активируется второй индикатор
        SEG_IN <= num1;
    when "01" => 
         anod_activate <= "1011"; -- активируется третий индикатор
         SEG_IN <= num2;
    when "00" => 
         anod_activate <= "0111"; -- активируется четвертый индикатор
         SEG_IN <= num3;                                
    end case;    
end process;

process(SEG_IN)  --выводим цифры на индикатор
begin
    case SEG_IN is
    when "0001" => SEG_OUT <= "1111001";
    when "0010" => SEG_OUT <= "1111100";
    when "0011" => SEG_OUT <= "0110000";
    when "0100" => SEG_OUT <= "0011001";
    when "0101" => SEG_OUT <= "0010010";
    when "0110" => SEG_OUT <= "0000010";
    when "0111" => SEG_OUT <= "1111000";
    when "1000" => SEG_OUT <= "0000000";
    when "1001" => SEG_OUT <= "0010000";
    when "0000" => SEG_OUT <= "1000000";
    when "1010" => SEG_OUT <= "0000010"; -- a
    when "1011" => SEG_OUT <= "1100000"; -- b
    when "1100" => SEG_OUT <= "0110001"; -- C
    when "1101" => SEG_OUT <= "1000010"; -- d
    when "1110" => SEG_OUT <= "0110000"; -- E
    when "1111" => SEG_OUT <= "0111000"; -- F
end case;
end process;

end Behavioral;
