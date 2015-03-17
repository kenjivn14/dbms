
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
