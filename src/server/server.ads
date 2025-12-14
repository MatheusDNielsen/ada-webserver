with GNAT.Sockets;
with Ada.Text_IO;

package Server is
  package S renames GNAT.Sockets;
  package T_IO renames Ada.Text_IO;
  function Open_TCP_Connection (Port : in Integer) return S.Socket_Type;

  procedure Greet_Forever (Server_Socket : in S.Socket_Type);

end Server;
