--Create
Create Trigger name on bang
for update,delete,insert
as
begin
	--xử lý lệnh
end
--drop
drop trigger name
--vd
use QL_Thu_Vien
Create Trigger xoa_sach on muon
for delete
as
begin
	declare @isbn int,@ma_cuonsach smallint
	select @isbn=isbn,@ma_cuonsach=ma_cuonsach
	from deleted
	update cuonsach
	set tinhtrang='yes'
	where isbn=@isbn and ma_cuonsach=@ma_cuonsach
end
