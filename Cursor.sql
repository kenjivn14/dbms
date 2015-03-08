--Khai báo
DECLARE cursor_C cursor for select * from	TuaSach
--open cursor
open cursor_C
--Lấy dữ liệu từ trong cursor
FETCH NEXT FROM cursor_name INTO @variable1, @variable2,...
--Kiểm tra kết quả lấy dữ liệu từ cursor (kiểm tra ngay sau lệnh FETCH NEXT):
@@FETCH_STATUS=0 --lấy dữ liệu thành công.
@@FETCH_sTATUS<0 --không lấy được dữ liệu.
--đóng cursor
close cursor_C
--hủy bỏ cursor
deallocate cursor_C
--vd
declare @btt int,@btt2 int
declare @c cursor
set @c= cursor for select tt,tt2 from bang1 where dk

open @c
fetch next from @c into @btt,@btt2
while(@@FETCH_STATUS=0)
begin
	fetch next from @c into @btt,@btt2
end
close @C
deallocate @c

use QL_Thu_Vien
--ví dụ cursor lồng / Top 2 đọc giả đọc những loại sách nào ?
declare @c cursor
set @c=cursor for select top 2 ma_docgia from DocGia

open @c

declare @madg varchar(10)
fetch next from @c into @madg

while @@fetch_status=0
begin
	print @madg
	declare @c2 cursor
	set @c2=cursor for select top 4 ma_tuasach from TuaSach

	open @c2

	declare @mats varchar(100)
	fetch next from @c2 into @mats

	while @@fetch_status=0
	begin
		print ' '+@mats;
		fetch next from @c2 into @mats
	end
	close @c2
	deallocate @c2

	fetch next from @c into @madg
end

close @c
deallocate @c
