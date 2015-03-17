--Khai báo Tran
begin tran
--hoàn tất Tran
commit
--Quay lùi Tran
rollback
--SavePoint Tran
save tran <name>
--Đếm Tran
@@trancount
--Error Tran
@@error
@@error = 0: --không xảy ra lỗi
@@error <> 0: --xảy ra lỗi với mã lỗi là @@error

--stampName
Begin Tran
...
Save Tran name1
Declare @name	varchar(10),
set @name='name2'
Save Tran @name

--rollBack stampName
Begin tran
--Thao tác 1
--Thao tác 2
Save tran name1
--thao tác 3
Rollback tran nam1
--Khi đến dòng ROllBack Tran thì ----thao tác 3 bị hủy 
--Thao tác 1
--Thao tác 2 , KHÔNG bị hủy
