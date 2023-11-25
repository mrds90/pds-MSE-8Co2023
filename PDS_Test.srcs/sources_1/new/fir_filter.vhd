library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;

entity fir_core is
  generic (
    N : positive := 2   -- Tamaño configurable
  );
  Port (
    clk : in STD_LOGIC;           -- Reloj
    rst : in STD_LOGIC;           -- Reset asincrónico
    entrada : in STD_LOGIC_VECTOR(N-1 downto 0);     -- Señal de entrada
    sumando : in STD_LOGIC_VECTOR(N-1 downto 0);     -- Sumando
    coeficiente : in STD_LOGIC_VECTOR(N-1 downto 0); -- Coeficiente
    salida : out STD_LOGIC_VECTOR(N-1 downto 0);      -- Salida del componente
    salida_sin_delay : out STD_LOGIC_VECTOR(N-1 downto 0);      -- Salida del componente
    salida_mul : out STD_LOGIC_VECTOR(2 * N - 1 downto 0);
    salida_sum : out STD_LOGIC_VECTOR(N - 1 downto 0)
  );
end fir_core;

architecture Behavioral of fir_core is
  signal multiplicacion1 : STD_LOGIC_VECTOR(2 * N - 1 downto 0);
  signal suma : STD_LOGIC_VECTOR(N - 1 downto 0);
  signal resultado : STD_LOGIC_VECTOR(N-1 downto 0);
  signal flipflop_salida : STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0');
begin
  -- Multiplicación 1
  multiplicacion1 <= STD_LOGIC_VECTOR(SIGNED(entrada) * SIGNED(coeficiente));
  salida_mul <= multiplicacion1;
  -- Multiplicación 2
  suma <= STD_LOGIC_VECTOR(SIGNED(multiplicacion1(2*N - 2 downto N-1)) + SIGNED(sumando));
  salida_sum <= suma;
  -- Resultado

  resultado <= (others => '0') when rst = '1' else suma;
  
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
