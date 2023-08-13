// text by ccircle
// 2023 Aug 13
// Igor Emelyanoff
// vectorgmbh@gmail.com


                                                    Procedure AddTextToBoard;
Var
    View      : IServerDocumentView;
    Document  : IServerDocument;
    TextObj   : IPCB_Text;
    Board     : IPCB_Board;
    i : word;
    angle: float;
    Text : string;
Begin
    If PCBServer = Nil Then Exit;

    Board := PcbServer.GetCurrentPCBBoard;
    If Board = Nil Then Exit;

    View := Client.GetCurrentView;
    Document := View.OwnerDocument;
    Document.Modified := True;

    Board.LayerIsDisplayed[ILayer.MechanicalLayer(6)] := true;

    PCBServer.PreProcess;


        Text :=                   'Vector super spiral Vector super spiral Vector super spiral ';

for i := 0 to length(Text )-1 do
begin
        TextObj := PCBServer.PCBObjectFactory(eTextObject,  eNoDimension,  eCreate_Default);

        PCBServer.SendMessageToRobots(TextObj.I_ObjectAddress, c_Broadcast, PCBM_BeginModify, c_NoEventData);

        //TextObj.UseTTFonts := True;

        TextObj.Layer := ILayer.MechanicalLayer(6);
        TextObj.Text  := Copy(Text, i+1, 1);
        TextObj.Size  :=  MilsToCoord(50);

        angle := i * 2* 3.14 /length(Text );
        TextObj.XLocation := MilsToCoord(1500+ sin( angle ) * 300  )  ;
        TextObj.YLocation := MilsToCoord(1500+ cos(angle)  * 300 )  ;
        TextObj.Rotation :=    - angle * 360 / 2 /3.14  ;
        Board.AddPCBObject(TextObj);

        PCBServer.SendMessageToRobots(TextObj.I_ObjectAddress, c_Broadcast, PCBM_EndModify, c_NoEventData);
        PCBServer.SendMessageToRobots(Board.I_ObjectAddress, c_Broadcast, PCBM_BoardRegisteration, TextObj.I_ObjectAddress);
end;
           PCBServer.PostProcess;


    Board.ViewManager_FullUpdate;
    Client.SendMessage('PCB:Zoom', 'Action=All' , 255, Client.CurrentView);
End;

