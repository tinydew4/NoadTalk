unit http;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, IdHTTP, IdSSLOpenSSL;

function HTTPGet(AURL: string): string;

implementation

function CreateHTTP: TIdHTTP;
var
  _IOHandler: TIdSSLIOHandlerSocketOpenSSL;
begin
  Result := TIDHTTP.Create;
  _IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(Result);
  _IOHandler.SSLOptions.Method := TIdSSLVersion(sslvSSLv23);
  Result.IOHandler := _IOHandler;
end;

function HTTPGet(AURL: string): string;
begin
  with CreateHTTP do begin
    Result := Get(AURL);
    Free;
  end;
end;

end.

