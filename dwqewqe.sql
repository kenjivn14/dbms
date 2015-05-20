USE [master]
--
CREATE TABLE [dbo].[Chung_Chi](
	[Mã Chứng Chỉ] [char](10) NOT NULL,
	[Tên Chứng Chỉ] [nvarchar](50) NULL,
	[Mã Học Viên] [int] NULL,
	[Mã Kì Thi] [char](10) NULL,
 CONSTRAINT [PK_Chung_Chi] PRIMARY KEY CLUSTERED 
(
	[Mã Chứng Chỉ] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

--
SET QUOTED_IDENTIFIER ON
--
SET ANSI_PADDING ON
--
CREATE TABLE [dbo].[Giang_Vien](
	[MaGV] [int] IDENTITY(1,1) NOT NULL,
	[TenGV] [nvarchar](50) NULL,
	[DiaChi] [nvarchar](50) NULL,
	[GioiTinh] [nvarchar](3) NULL,
	[NgaySinh] [date] NULL,
	[SDT] [nchar](10) NULL,
	[MaTD] [int] NULL,
	[Email] [varchar](50) NULL,
 CONSTRAINT [PK_Giang_Vien] PRIMARY KEY CLUSTERED 
(
	[MaGV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

--
SET ANSI_PADDING OFF
--
/****** Object:  Table [dbo].[Hoc_Vien]    Script Date: 5/20/2015 7:02:56 PM ******/
SET ANSI_NULLS ON
--
SET QUOTED_IDENTIFIER ON
--
SET ANSI_PADDING ON
--
CREATE TABLE [dbo].[Hoc_Vien](
	[MaHV] [int] IDENTITY(1,1) NOT NULL,
	[HoTen] [nvarchar](50) NULL,
	[GioiTinh] [nvarchar](3) NULL,
	[NgaySinh] [date] NULL,
	[DiaChi] [nvarchar](50) NULL,
	[SDT] [char](11) NULL,
	[MaLop] [int] NULL,
	[MaKhoaHoc] [int] NULL,
 CONSTRAINT [PK_Hoc_Vien] PRIMARY KEY CLUSTERED 
(
	[MaHV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

--
SET ANSI_PADDING OFF
--
/****** Object:  Table [dbo].[Khoa_Hoc]    Script Date: 5/20/2015 7:02:56 PM ******/
SET ANSI_NULLS ON
--
SET QUOTED_IDENTIFIER ON
--
CREATE TABLE [dbo].[Khoa_Hoc](
	[MaKhoaHoc] [int] IDENTITY(1,1) NOT NULL,
	[TenKhoaHoc] [nvarchar](50) NULL,
 CONSTRAINT [PK_Khoa_Hoc] PRIMARY KEY CLUSTERED 
(
	[MaKhoaHoc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

--
/****** Object:  Table [dbo].[Ky_Thi]    Script Date: 5/20/2015 7:02:56 PM ******/
SET ANSI_NULLS ON
--
SET QUOTED_IDENTIFIER ON
--
SET ANSI_PADDING ON
--
CREATE TABLE [dbo].[Ky_Thi](
	[Mã Kì Thi] [char](10) NOT NULL,
	[Tên Kì Thi] [nvarchar](50) NULL,
 CONSTRAINT [PK_Ky_Thi] PRIMARY KEY CLUSTERED 
(
	[Mã Kì Thi] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

--
SET ANSI_PADDING OFF
--
/****** Object:  Table [dbo].[Lop_Hoc]    Script Date: 5/20/2015 7:02:56 PM ******/
SET ANSI_NULLS ON
--
SET QUOTED_IDENTIFIER ON
--
CREATE TABLE [dbo].[Lop_Hoc](
	[MaLop] [int] IDENTITY(1,1) NOT NULL,
	[TenLop] [nvarchar](50) NULL,
 CONSTRAINT [PK_Lop_Hoc] PRIMARY KEY CLUSTERED 
(
	[MaLop] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

--
/****** Object:  Table [dbo].[Temp_LopHoc]    Script Date: 5/20/2015 7:02:56 PM ******/
SET ANSI_NULLS ON
--
SET QUOTED_IDENTIFIER ON
--
CREATE TABLE [dbo].[Temp_LopHoc](
	[MaLH] [int] NULL,
	[TenLH] [nchar](10) NULL
) ON [PRIMARY]

--
/****** Object:  Table [dbo].[ThongTinLop]    Script Date: 5/20/2015 7:02:56 PM ******/
SET ANSI_NULLS ON
--
SET QUOTED_IDENTIFIER ON
--
CREATE TABLE [dbo].[ThongTinLop](
	[MaLop] [int] NULL,
	[NBT] [date] NULL,
	[NKT] [date] NULL,
	[SS] [int] NULL,
	[SBD] [int] NULL,
	[MaGV] [int] NULL,
	[MaKhoaHoc] [int] NULL
) ON [PRIMARY]

--
/****** Object:  Table [dbo].[TrinhDo]    Script Date: 5/20/2015 7:02:56 PM ******/
SET ANSI_NULLS ON
--
SET QUOTED_IDENTIFIER ON
--
CREATE TABLE [dbo].[TrinhDo](
	[MaTD] [int] IDENTITY(1,1) NOT NULL,
	[TrinhDo] [nvarchar](50) NULL,
 CONSTRAINT [PK_TrinhDo] PRIMARY KEY CLUSTERED 
(
	[MaTD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

--
ALTER TABLE [dbo].[Chung_Chi]  WITH CHECK ADD  CONSTRAINT [FK_Chung_Chi_Hoc_Vien] FOREIGN KEY([Mã Học Viên])
REFERENCES [dbo].[Hoc_Vien] ([MaHV])
--
ALTER TABLE [dbo].[Chung_Chi] CHECK CONSTRAINT [FK_Chung_Chi_Hoc_Vien]
--
ALTER TABLE [dbo].[Chung_Chi]  WITH CHECK ADD  CONSTRAINT [FK_Chung_Chi_Ky_Thi] FOREIGN KEY([Mã Kì Thi])
REFERENCES [dbo].[Ky_Thi] ([Mã Kì Thi])
--
ALTER TABLE [dbo].[Chung_Chi] CHECK CONSTRAINT [FK_Chung_Chi_Ky_Thi]
--
ALTER TABLE [dbo].[Giang_Vien]  WITH CHECK ADD  CONSTRAINT [FK_Giang_Vien_TrinhDo1] FOREIGN KEY([MaTD])
REFERENCES [dbo].[TrinhDo] ([MaTD])
--
ALTER TABLE [dbo].[Giang_Vien] CHECK CONSTRAINT [FK_Giang_Vien_TrinhDo1]
--
ALTER TABLE [dbo].[Hoc_Vien]  WITH CHECK ADD  CONSTRAINT [FK_Hoc_Vien_Khoa_Hoc] FOREIGN KEY([MaKhoaHoc])
REFERENCES [dbo].[Khoa_Hoc] ([MaKhoaHoc])
--
ALTER TABLE [dbo].[Hoc_Vien] CHECK CONSTRAINT [FK_Hoc_Vien_Khoa_Hoc]
--
ALTER TABLE [dbo].[Hoc_Vien]  WITH CHECK ADD  CONSTRAINT [FK_Hoc_Vien_Lop_Hoc] FOREIGN KEY([MaLop])
REFERENCES [dbo].[Lop_Hoc] ([MaLop])
--
ALTER TABLE [dbo].[Hoc_Vien] CHECK CONSTRAINT [FK_Hoc_Vien_Lop_Hoc]
--
ALTER TABLE [dbo].[ThongTinLop]  WITH CHECK ADD  CONSTRAINT [FK_ThongTinLop_Giang_Vien] FOREIGN KEY([MaGV])
REFERENCES [dbo].[Giang_Vien] ([MaGV])
--
ALTER TABLE [dbo].[ThongTinLop] CHECK CONSTRAINT [FK_ThongTinLop_Giang_Vien]
--
ALTER TABLE [dbo].[ThongTinLop]  WITH CHECK ADD  CONSTRAINT [FK_ThongTinLop_Khoa_Hoc] FOREIGN KEY([MaKhoaHoc])
REFERENCES [dbo].[Khoa_Hoc] ([MaKhoaHoc])
--
ALTER TABLE [dbo].[ThongTinLop] CHECK CONSTRAINT [FK_ThongTinLop_Khoa_Hoc]
--
ALTER TABLE [dbo].[ThongTinLop]  WITH CHECK ADD  CONSTRAINT [FK_ThongTinLop_Lop_Hoc] FOREIGN KEY([MaLop])
REFERENCES [dbo].[Lop_Hoc] ([MaLop])
--
ALTER TABLE [dbo].[ThongTinLop] CHECK CONSTRAINT [FK_ThongTinLop_Lop_Hoc]
--
USE [master]
--
ALTER DATABASE [Trung_Tam_Anh_Ngu_A_Z] SET  READ_WRITE 
--
