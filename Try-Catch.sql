
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
