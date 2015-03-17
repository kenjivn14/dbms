--KHAI BÁO BIẾN
 --INT A=1,b=2

DECLARE @a int, @b int = 2,@c nvarchar (100)=N'Xin Chào'
SET @a=1
SELECT @a as A,@b as B,@c as kChar

--Câu trúc rẽ nhánh IF ELSE
DECLARE @dk int, @dk2 int
SET @dk=5

IF @dk>10 or @dk2 is NULL
	print N'Lớn hơn 10'
ELSE
	print N'Nhỏ hơn 10'


--Lặp
DECLARE @count int =10

WHILE @count >=0
BEGIN
	print N'Hello !!'
	SET @count =@count -1
END

--bắt lỗi
DECLARE @count2 int =10
BEGIN TRY
	--xử lý code
	SET @count2 =10/0
	--SET @count2=10/2
	--SELCET @count2
END TRY
BEGIN CATCH
	--xử lý error
	print N' Lổi chia cho 0'
END CATCH


Use QL_Thu_Vien
--System Functions
--conut()
SELECT COUNT (*),sum(isbn) from DangKy


--TẠO FUNCTIONS
--Tab Progammability -> Functions -> Scalar-valued Functions
--Đơn
--Ví Dụ
CREATE FUNCTION fc_xinchao
( @p nvarchar(100) )
RETURNS nvarchar(200)
AS
BEGIN
	RETURN N'Xin Chào' +@p
END
SELECT dbo.fc_xinchao(N' Ưng Đăng')

Use QL_Thu_Vien
--Inline Table-valued Functions
--Tab Progammability -> Functions -> Table-valued Functions ->Inline 
ALTER FUNCTION fc_InlineTable_01() --Cập nhật lại dử liệu
RETURNs TABLE
AS RETURN
(
	-- Nội dung phép try vấn trả về rowset
	SELECT cs.isbn,TinhTrang,qtm.ngay_muon 
	FROM CuonSach cs join QuaTrinhMuon qtm
	ON cs.isbn=qtm.isbn
)
SELECT * FROM dbo.fc_InlineTable_01()


Use QL_Thu_Vien
--Multi State Table-valued Functions
--Tab ... -> Table-valued Functions ->Multi State 
ALTER FUNCTION fc_MultiState_01()
RETURNs @table TABLE
(
	isbn int,
	TinhTrang nvarchar(1),
	Temp nvarchar(10)
)
AS
BEGIN
	--INSERT INTO @table VALUES(0,N'Y',NULL)
	--DECLARE @testVarible int
	--Các SET và T-SQL áp dụn
	INSERT @table
	SELECT cs.isbn,TinhTrang,qtm.ngay_muon 
	FROM CuonSach cs join QuaTrinhMuon qtm
	ON cs.isbn=qtm.isbn
	RETURN
END

SELECT * FROM dbo.fc_MultiState_01()
