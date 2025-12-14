with GNAT.Sockets;

package body Server is

  function Open_TCP_Connection (Port : in Integer) return S.Socket_type is
    Socket  : S.Socket_Type;
    Address : S.Sock_Addr_Type;

  begin
    Address.Addr := S.Inet_Addr ("127.0.0.1");
    Address.Port := S.Port_Type (Port);
    S.Create_Socket (Socket);
    S.Set_Socket_Option (Socket, S.Socket_Level, (S.Reuse_Address, True));
    S.Bind_Socket (Socket, Address);
    S.Listen_Socket (Socket);
    T_IO.Put_Line ("Listening on port" & Address.Port'Image);

    return Socket;

  end Open_TCP_Connection;

  procedure Greet_Forever (Server_Socket : in S.Socket_Type) is
    Client_Socket  : S.Socket_Type;
    Client_Address : S.Sock_Addr_Type;
    Channel        : S.Stream_Access;
    Greeting       : constant String :=
     "HTTP/1.1 200 OK"
     & ASCII.CR
     & ASCII.LF
     & "Content-Length: 15"
     & ASCII.CR
     & ASCII.LF
     & ASCII.CR
     & ASCII.LF
     & "Hello from Ada!";

  begin
    loop
      S.Accept_Socket (Server_Socket, Client_Socket, Client_Address);
      T_IO.Put_Line ("Accepted Connection!");
      Channel := S.Stream (Client_Socket);

      String'Write (Channel, Greeting);
      T_IO.Put_Line ("Sent.");

      S.Close_Socket (Client_Socket);
    end loop;
  end Greet_Forever;
end Server;
