--Viết stored-procedure In ra dòng ‘Hello
CREATE PROC hello
AS
BEGIN
	print 'Hello'
END
EXEC hello
--Viết stored-procedure In ra dòng ‘Xin chào’.
CREATE PROC xin_chao
AS
BEGIN
	print N'Xin Chào'
END
EXEC xin_chao
--Viết stored-procedure In ra dòng ‘Xin chào’ + @ten với @ten là tham số đầu vào là tên của bạn.
CREATE PROC xin_chao_ten
(
	@ten nvarchar(10) out
)
AS
BEGIN
	print N'Xin Chào' + @ten
END
--Viết stored-procedure Nhập vào 2 số @s1,@s2. In ra tổng @s1+@s2.
alter PROC TONG
(
	@s1 int,@s2 int,@tong int out
)
as
BEGIN
	SET @tong=@s1+@s2
	--print N'Tổng là'+ cast( @tong as nvarchar(10))
END
DECLARE @tongla int
exec TONG 99, 5,@tongla out
print N'Tổng là' +cast(@tongla as nvarchar(10))
--Viết stored-procedure Nhập vào 2 số @s1,@s2. In ra max của chúng.
alter PROC Nmax
(
	@s1 int,
	@s2 int
)
as
begin
	if (@s1>@s2)
	print cast(@s1 as nvarchar(10)) +N'Lớn hơn'+cast(@s2 as nvarchar(10))
	else
	print cast(@s1 as nvarchar(10)) +N'Nhỏ hơn'+cast(@s2 as nvarchar(10))
end
exec Nmax 1,2
--Viết stored-procedure Nhập vào số nguyên @n. In ra các số từ 1 đến @n
create PROC print_N
(@n int)
as
begin
	declare @i int
	set @i=1
	while(@i<=@n)
	begin
		print cast(@i as nvarchar(10))
		set @i=@i+1
	end
end
exec print_N 10
--Viết stored-procedure Nhập vào số nguyên @n. In ra tổng các số chẵn từ 1 đến @n
create PROC print_N_Chan
(@n int,@tong int out)
as
begin
	declare @i int
	set @i=1
	set @tong=0
	while(@i<=@n)
	begin
		if(@i%2=0)
		begin
			set @tong=@tong+@i
			print cast(@tong as nvarchar(10))
		end
		set @i=@i+1
	end
end
declare @tong int
exec print_N_Chan 10, @tong out
select @tong as TỔNG
--Viết stored-procedure Nhập vào số nguyên @n. In ra tổng, và số lượng các số chẵn từ 1 đến @n
create PROC print_N_Chan_dem
(@n int,@tong int out, @dem int out)
as
begin
	declare @i int
	set @dem=0
	set @i=1
	set @tong=0
	while(@i<=@n)
	begin
		if(@i%2=0)
		begin
			set @dem=@dem+1
			set @tong=@tong+@i
			print cast(@tong as nvarchar(10))
			print cast(@dem as nvarchar(10))
		end
		set @i=@i+1
	end
end
declare @tong int,@dem int
exec print_N_Chan_dem 10, @tong out,@dem out
select @tong as TỔNG,@dem as ĐẾM_CHẲN
--Viết stored-procedure Nhập vào 2 số. In ra ước chung lớn nhất của chúng theo gợi ý dưới đây.
CREATE PROC UCLN
(@a int,@b int)
as
begin
	set @a=abs(@a)
	set @b=abs(@b)
	if(@a=0 or @b=0)
	begin
		set @a=@a+@b
		print N'UCLN là :' +cast(@a as nvarchar(10))
	end
	else
	begin
		while(@a!=@b)
		begin
			if(@a>@b)
			set @a=@a-@b
			else
			set @b=@b-@a
		end
		print N'UCLN là :' +cast(@a as nvarchar(10))
	end
end
exec UCLN 555,14
--Viết stored-procedure Nhập vào số nguyên @n <= 5. In ra tất cả các số nhị phân có @n bit.
create proc depi_2bit
(@s varchar(10), @n int)
as
begin
	if(@n=0)
	print @s
	else
	begin
		declare @s1 varchar(50)=@s+'0'
		declare @s2 varchar(50)=@s+'1'
		set @n=@n-1;
		exec depi_2bit @s1,@n
		exec depi_2bit @s2,@n
	end
end
exec depi_2bit ' ',5
--đệ quy ucln
create proc depi_ucln
(@a int, @b int)
as
begin
	if(@a=@b)
		print cast(@a as nvarchar(10))
	else
	begin
	declare @a1 int=@a-@b
	declare @b1 int=@b-@a
		if(@a>@b)
			exec depi_ucln @a1,@b
		else
			exec depi_ucln @a,@b1
	end
end
exec depi_ucln 555,14
