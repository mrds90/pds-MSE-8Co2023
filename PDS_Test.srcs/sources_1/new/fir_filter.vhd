library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;


entity fir_core is
  generic
  (
    N : positive := 2 -- Tamaño configurable
  );
  port
  (
    clk              : in std_logic; -- Reloj
    rst              : in std_logic; -- Reset asincrónico
    entrada          : in std_logic_vector(N - 1 downto 0); -- Señal de entrada
    sumando          : in std_logic_vector(N - 1 downto 0); -- Sumando
    coeficiente      : in std_logic_vector(N - 1 downto 0); -- Coeficiente
    salida           : out std_logic_vector(N - 1 downto 0); -- Salida del componente
    salida_sin_delay : out std_logic_vector(N - 1 downto 0) -- Salida del componente
  );
end fir_core;

architecture Behavioral of fir_core is
  signal multiplicacion1 : std_logic_vector(2 * N - 1 downto 0);
  signal suma            : std_logic_vector(N - 1 downto 0);
  signal resultado       : std_logic_vector(N - 1 downto 0);
  signal flipflop_salida : std_logic_vector(N - 1 downto 0) := (others => '0');
begin
  -- Multiplicación 1
  multiplicacion1 <= std_logic_vector(SIGNED(entrada) * SIGNED(coeficiente) + TO_SIGNED(2 ** (N - 2), 2 * N));

  -- Multiplicación 2
  suma <= std_logic_vector(SIGNED(multiplicacion1(2 * N - 2 downto N - 1)) + SIGNED(sumando));

  resultado <= (others => '0') when rst = '1' else
    suma;

  salida_sin_delay <= resultado;

  -- Flip-flop para almacenar el resultado
  process (clk, rst)
  begin
    if rising_edge(clk) then
      flipflop_salida <= resultado;
    end if;
  end process;

  -- Salida del componente
  salida <= flipflop_salida;

end Behavioral;