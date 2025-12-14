with Ada.Text_IO;
with Ada.Command_Line;
with GNAT.Sockets;
with Server;

procedure Hello_World is
  package T_IO renames Ada.Text_IO;
  package C_L renames Ada.Command_Line;

  procedure Get_Parameters
   (Port_Number : out Integer; Folder_To_Serve : out String) is
  begin
    Port_Number := Integer'Value (C_L.Argument (1));
    Folder_To_Serve := C_L.Argument (2);
  end Get_Parameters;


  Port_Number     : Integer := 8000;
  Folder_To_Serve : String := ".";
  Server_Socket   : GNAT.Sockets.Socket_Type;

begin
  T_IO.Put_Line ("Hello World");

  if C_L.Argument_Count < 2 then
    T_IO.Put ("Usage: ");
    T_IO.Put (C_L.Command_Name);
    T_IO.Put_Line (" <port>");
    C_L.Set_Exit_Status (C_L.Failure);
    return;
  end if;

  Get_Parameters (Port_Number, Folder_To_Serve);

  Server_Socket := Server.Open_TCP_Connection (Port_Number);

  Server.Greet_Forever (Server_Socket);

end Hello_World;
