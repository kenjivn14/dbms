use Temp_1
--Cau 3b
create proc cau_3_b
AS
BEGIN
	declare cap_nhap cursor
	for select trinhdo FROM NhanVien open cap_nhap
 declare @trinhdo int = 1
 FETCH NEXT FROM cap_nhap into @trinhdo
 WHILE @@FETCH_STATUS = 0
Begin
	UPDATE NhanVien
	SET trinhdo = 2
	WHERE @trinhdo = 1 AND (YEAR(GETDATE())-YEAR(Ngay_vao_lam)>2)
		FETCH NEXT FROM cap_nhap into @trinhdo
	END
 close cap_nhap
 deallocate cap_nhap
End
--Trigger
--câu 3c
create trigger khong_hop_le on nhanvien
for insert
as
begin
	declare @temp varchar(10),
	declare @temp_2 varchar(10)
		select @temp=trinhdo,@temp_2=mucluong
		from inserted
		
		if(trinhdo=1 & mucluong>10000000)
		print 'Them khong hop le'
		else
		print 'Hop le'
end


