
sp_configure 'clr enabled', 1
go
reconfigure
go


--------------------------------------------------------------



sp_change_users_login 'Update_One', 'sysdba', 'sysdba'
GO

UPDATE sysdba.syncserver SET sysdba.syncserver.serverpath = ''
GO

UPDATE sysdba.BRANCHOPTIONS SET sysdba.BRANCHOPTIONS.attachmentpath = ''
GO

UPDATE sysdba.BRANCHOPTIONS SET sysdba.BRANCHOPTIONS.saleslibrarypath = ''
GO

UPDATE sysdba.systeminfo SET sysdba.systeminfo.pingserver = 'asu-programmer2'
GO


---------------------------------------------------------------



SELECT *
FROM information_schema.tables
WHERE table_name = 'myTable'
      AND table_schema = 'myDb'
