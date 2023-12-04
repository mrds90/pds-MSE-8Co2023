library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;
--use work.bus_multiplexer_pkg.all;

entity filtro_fir_cadena is
  generic
  (
    N : positive := 32; -- Tamaño configurable
    M : positive := 20  -- Número de componentes FIR en la cadena
  );
  port
  (
    clk     : in STD_LOGIC; -- Reloj
    rst     : in STD_LOGIC; -- Reset asincrónico
    entrada : in STD_LOGIC_VECTOR(N - 1 downto 0); -- Señal de entrada común
    coeficientes : in STD_LOGIC_VECTOR(N*M -1 downto 0);
    salida  : out STD_LOGIC_VECTOR(N - 1 downto 0); -- Salida del componente TOP
    orden : in STD_LOGIC_VECTOR(integer(ceil(log2(real(M+1)))) - 1 downto 0)
  );
end filtro_fir_cadena;

architecture Behavioral of filtro_fir_cadena is
  
  
  signal sumando_intermedio : STD_LOGIC_VECTOR(N*(M+1)-1 downto 0) := (others => '0');
  signal salida_sin_delay_s : STD_LOGIC_VECTOR(N*(M+1)-1 downto 0) := (others => '0');
  signal salida_final:        STD_LOGIC_VECTOR(N*M -1 downto 0)    := (others => '0');
  signal x_nometa:          STD_LOGIC_VECTOR(integer(ceil(log2(real(M+1)))) - 1 downto 0) := std_logic_vector(TO_UNSIGNED(M,INTEGER(ceil(log2(real(M+1))))));

  -- Declarar instancias de los componentes FIR
  component fir_core
    generic
    (
       K : positive := N -- Tamaño configurable
    ); 
    port
    (
      clk              : in std_logic;
      rst              : in std_logic;
      entrada          : in std_logic_vector(K - 1 downto 0);
      sumando          : in std_logic_vector(K - 1 downto 0);
      coeficiente      : in std_logic_vector(K - 1 downto 0);
      salida           : out std_logic_vector(K - 1 downto 0);
      salida_sin_delay : out std_logic_vector(K - 1 downto 0)
    );
  end component;

  -- Arreglo de señales de salida sin delay para cada componente FIR


begin
  -- Instancias de los componentes FIR en cadena
  fir_insts: for i in 0 to M - 1 generate
    fir_i: fir_core
      port map(
        clk              => clk,
        rst              => rst,
        entrada          => entrada,
        sumando          => sumando_intermedio((((i+1)*(N))-1) downto i*(N)),
        coeficiente      => coeficientes((((i+1)*(N))-1) downto i*(N)),
        salida           => sumando_intermedio((((i+2)*(N))-1) downto (i+1)*(N)),
        salida_sin_delay => salida_final((((i+1)*(N))-1) downto i*(N))
      );
  end generate;

  x_nometa <= std_logic_vector(TO_UNSIGNED(M,INTEGER(ceil(log2(real(M + 1)))))) when Is_X(orden) else orden;
  -- Salida del componente TOP
  salida <= salida_final(N*(TO_INTEGER(UNSIGNED(x_nometa)))-1 downto N*((TO_INTEGER(UNSIGNED(x_nometa)))-1));

end Behavioral;
