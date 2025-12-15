with Ada.Directories;
with Ada.Strings.Fixed;
with Ada.Strings.Unbounded;
with Ada.Text_IO;
with Ada.Command_Line;
with GNAT.Sockets;
with Server;

procedure Hello_World is
  package T_IO renames Ada.Text_IO;
  package C_L renames Ada.Command_Line;
  package U renames Ada.Strings.Unbounded;
  package D renames Ada.Directories;

  procedure Get_Parameters
   (Port_Number : out Integer; Folder_To_Serve : out U.Unbounded_String) is
  begin
    Port_Number := Integer'Value (C_L.Argument (1));
    Folder_To_Serve := U.To_Unbounded_String (C_L.Argument (2));
  end Get_Parameters;

  procedure Get_Folder_To_Serve (Folder_To_Serve : in out U.Unbounded_String)
  is
    package S_F renames Ada.Strings.Fixed;
    use type Ada.Directories.File_Kind;

  begin
    if (D.Kind (U.To_String (Folder_To_Serve)) = D.Directory) then
      T_IO.Put_Line ("Is Dir");
    else
      raise D.Name_Error;

    end if;
  end Get_Folder_To_Serve;

  Port_Number     : Integer := 8000;
  Folder_To_Serve : U.Unbounded_String := U.To_Unbounded_String (".");
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

  begin
    Get_Folder_To_Serve (Folder_To_Serve);
  exception
    when E : D.Name_Error =>
      T_IO.Put_Line (T_IO.Standard_Error, "Error: Path is not a folder");
      C_L.Set_Exit_Status (1);
      return;
  end;

  Server_Socket := Server.Open_TCP_Connection (Port_Number);

  Server.Greet_Forever (Server_Socket);

end Hello_World;
