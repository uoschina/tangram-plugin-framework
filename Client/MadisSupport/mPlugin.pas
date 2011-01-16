unit mPlugin;

interface

uses SysUtils,Classes,Graphics,MainFormIntf,MenuRegIntf,
     uTangramModule,PluginBase,RegIntf,uDM,SysFactoryEx;

Type
  TmPlugin=Class(TPlugin)
  private
    dm:Tdm;
    procedure SortCutClick(pIntf:IShortCutClick);
  public
    Constructor Create; override;
    Destructor Destroy; override;

    procedure Init; override;
    procedure final; override;
    procedure Register(Flags: Integer; Intf: IInterface); override;

    class procedure RegisterModule(Reg:IRegistry);override;
    class procedure UnRegisterModule(Reg:IRegistry);override;
  End;

implementation

uses uFrame,DBIntf,InvokeServerIntf,SysSvc;

const
  InstallKey='SYSTEM\LOADPACKAGE\DBSUPPORT';
  ValueKey='Package=%s;load=True';
{ TTest2Menu }

constructor TmPlugin.Create;
begin
  (SysService as IMainForm).RegShortCut('Midas远程方法调用',self.SortCutClick);

  dm:=Tdm.Create(nil);
  TObjFactoryEx.Create([IDBConnection,IDBAccess,IInvokeServer],dm);
end;

destructor TmPlugin.Destroy;
begin
  dm.Free;
  inherited;
end;

procedure TmPlugin.final;
begin
  inherited;

end;

procedure TmPlugin.Init;
begin
  inherited;

end;

procedure TmPlugin.Register(Flags: Integer; Intf: IInterface);
begin
  inherited;

end;

class procedure TmPlugin.RegisterModule(Reg: IRegistry);
var ModuleFullName,ModuleName,Value:String;
begin
  //注册包
  if Reg.OpenKey(InstallKey,True) then
  begin
    ModuleFullName:=SysUtils.GetModuleName(HInstance);
    ModuleName:=ExtractFileName(ModuleFullName);
    Value:=Format(ValueKey,[ModuleFullName]);
    Reg.WriteString(ModuleName,Value);
    Reg.SaveData;
  end;
end;

procedure TmPlugin.SortCutClick(pIntf: IShortCutClick);
begin
  pIntf.RegPanel(TFrame4);
end;

class procedure TmPlugin.UnRegisterModule(Reg: IRegistry);
var ModuleName:String;
begin
  //取消注册包
  if Reg.OpenKey(InstallKey) then
  begin
    ModuleName:=ExtractFileName(SysUtils.GetModuleName(HInstance));
    if Reg.DeleteValue(ModuleName) then
      Reg.SaveData;
  end;
end;

initialization
  RegisterPluginClass(TmPlugin);
finalization
end.
 