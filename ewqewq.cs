using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Text.RegularExpressions;
using System.Data.SqlClient;
using Microsoft.SqlServer.Management.Smo;
using Microsoft.SqlServer.Management.Common;
using Microsoft.SqlServer.Management.Sdk.Sfc;
using Microsoft.Win32;

namespace QuanLyHocSinh
{
    public partial class frmConnectDatabase : Form
    {
        #region Các biến
        private bool IntegratedSecurity;
        private Server LayTenCSDLCuaServer;
        private ServerConnection ServerConn;
        private string TenServer;
        private string TenCSDL;
        private string TenTaiKhoan;
        private string MatKhau;
        private string ThongTinKetNoiServer;
        private string ThongTinKetNoiCSDL;
        private bool KetQuaKetNoiServer = false;
        private bool KetQuaKetNoiCSDL = false;
        private List<string> DanhSachTenServer;
        #endregion
        public frmConnectDatabase()
        {
            InitializeComponent();
        }
        public static List<string> LayTatCaTenServer()
        {
            List<string> listServer = KiemTraServer();
            List<string> listTenServer = new List<string>();
            string macineName = Environment.MachineName;
            listTenServer.Add(macineName);
            foreach (string s in listServer)
            {
                listTenServer.Add(macineName + @"\" + s);
            }
            return listTenServer;
        }

        // Lấy danh sách các server có trong máy
        public static List<string> KiemTraServer()
        {
            List<string> instanceNameArr = new List<string>();

            RegistryView registryView = Environment.Is64BitOperatingSystem ? RegistryView.Registry64 : RegistryView.Registry32;
            using (RegistryKey hklm = RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, registryView))
            {
                RegistryKey instanceKey = hklm.OpenSubKey(@"SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL", false);
                if (instanceKey != null)
                {
                    foreach (var instanceName in instanceKey.GetValueNames())
                    {
                        instanceNameArr.Add(instanceName);
                    }
                }
            }
            return instanceNameArr;
        }


        private void cbTenServer_SelectedIndexChanged(object sender, EventArgs e)
        {
            TenServer = cbTenServer.Text;

        }

        private void cbKieuXacThuc_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (cbKieuXacThuc.SelectedIndex == 0)
            {
                txbMatKhau.Clear();
                txbMatKhau.Enabled = false;
                txbTenTaiKhoan.Enabled = false;
                txbThongTinKetNoiServer.Clear();
                txbTenTaiKhoan.Text = System.Security.Principal.WindowsIdentity.GetCurrent().Name.ToString();
                IntegratedSecurity = true;
                chbHienThiMatKhau.Enabled = false;
            }
            else
            {
                txbMatKhau.Clear();
                txbMatKhau.Enabled = true;
                txbThongTinKetNoiServer.Clear();
                txbTenTaiKhoan.Clear();
                txbTenTaiKhoan.Enabled = true;
                IntegratedSecurity = false;
                chbHienThiMatKhau.Enabled = true;
            }
        }

        private void txbTenTaiKhoan_TextChanged(object sender, EventArgs e)
        {
            TenTaiKhoan = txbTenTaiKhoan.Text;
        }

        private void txbMatKhau_TextChanged(object sender, EventArgs e)
        {
            MatKhau = txbMatKhau.Text;
            if (cbKieuXacThuc.SelectedIndex == 1)
                txbMatKhau.UseSystemPasswordChar = true;
        }

        private void chbHienThiMatKhau_CheckedChanged(object sender, EventArgs e)
        {
            if (chbHienThiMatKhau.Checked == true)
                txbMatKhau.UseSystemPasswordChar = false;
            else
                txbMatKhau.UseSystemPasswordChar = true;
        }

        private void btnKetNoi_Click(object sender, EventArgs e)
        {
            try
            {
                if (cbKieuXacThuc.SelectedIndex == 0)
                {
                    if (KetNoiDenServer(ChuoiKetNoiDenServer(TenServer, "master", IntegratedSecurity)))
                    {
                        KetQuaKetNoiServer = true;
                        ServerConn = new ServerConnection(cbTenServer.Text);
                        LayTenCSDLCuaServer = new Server(ServerConn);
                    }
                }
                else
                {
                    if (KetNoiDenServer(ChuoiKetNoiDenServer(TenServer, "master", TenTaiKhoan, MatKhau, IntegratedSecurity)))
                    {
                        KetQuaKetNoiServer = true;
                        ServerConn = new ServerConnection(cbTenServer.Text);
                        LayTenCSDLCuaServer = new Server(ServerConn);
                    }
                }
                DanhSachCSDL();
                if (KetQuaKetNoiServer == true)
                {
                    ThongTinKetNoiServer = "\nKết nối đến SQL Server thành công! Tên Server: " + TenServer;
                    pnKetNoiServer.Enabled = false;
                    pnKetNoiCSDL.Enabled = true;
                    txbThongTinKetNoiServer.Text = ThongTinKetNoiServer;

                }
                else
                {
                    ThongTinKetNoiServer = "\nKết nối đến SQL Server thất bại!\nXin kiểm tra lại!";
                    pnKetNoiServer.Enabled = true;
                    pnKetNoiCSDL.Enabled = false;
                    txbThongTinKetNoiServer.Text = ThongTinKetNoiServer;
                }
            }
            catch (Exception ex)
            {
                ThongTinKetNoiServer = "Có lỗi xảy ra: " + ex.Message;
                txbThongTinKetNoiServer.Text = ThongTinKetNoiServer;
            }
        }
        // Kiểm tra kết nối
        public static bool KetNoiDenServer(string connectionString)
        {

            try
            {
                using (var con = new SqlConnection(connectionString))
                {
                    con.Open();
                    con.Close();
                }
                return true;
            }
            catch
            {
                return false;
            }
        }
        public static string ChuoiKetNoiDenServer(string server, string db, bool IntegratedSecurity)
        {
            return "Data Source=" + server.Trim() + ";Initial Catalog=" + db.Trim() + ";Integrated Security=" + IntegratedSecurity + ";";
        }

        // Xây dựng cuỗi kết nối
        public static string ChuoiKetNoiDenServer(string server, string db, string UserName, string Password, bool IntegratedSecurity)
        {
            return "Data Source=" + server.Trim() + ";Initial Catalog=" + db.Trim() + ";Integrated Security=" + IntegratedSecurity + ";User ID=" + UserName.Trim() + ";Password=" + Password + ";";
        }
        // Lấy danh sách cơ sở dữ liệu có trong máy
        private void DanhSachCSDL()
        {
            cbTenCSDL.Items.Clear();

            foreach (Database db in LayTenCSDLCuaServer.Databases)
            {
                //Check if database is not a system database
                if (!db.IsSystemObject)
                {
                    cbTenCSDL.Items.Add(db.Name);
                }
            }
            cbTenCSDL.SelectedIndex = -1;
        }

        private void txbThongTinKetNoiServer_TextChanged(object sender, EventArgs e)
        {
            txbThongTinKetNoiServer.Text = ThongTinKetNoiServer;

        }

        private void cbTenCSDL_SelectedIndexChanged(object sender, EventArgs e)
        {

            TenCSDL = cbTenCSDL.Text;
            btnKiemTra.Enabled = true;
            btnXoa.Enabled = true;
            btnTaoMoi.Enabled = false;
            btnKetNoiCSDL.Enabled = false;
        }

        private void btnKiemTra_Click(object sender, EventArgs e)
        {
            if (KiemTraCSDL(cbTenCSDL.Text) == true)
            {
                btnKetNoiCSDL.Enabled = true;
                btnXoa.Enabled = true;
                btnTaoMoi.Enabled = false;
                btnKiemTra.Enabled = true;
                ThongTinKetNoiCSDL = "Cơ sở dữ liệu hợp lệ! Tên cơ sở dữ liệu: " + cbTenCSDL.Text;
                txbThongTinKetNoiCSDL.Text = ThongTinKetNoiCSDL;
            }
            else
            {
                btnKiemTra.Enabled = true;
                btnXoa.Enabled = true;
                btnTaoMoi.Enabled = false;
                btnKetNoiCSDL.Enabled = false;
                ThongTinKetNoiCSDL = "Cơ sở dữ liệu không hợp lệ! Vui lòng tạo mới hoặc chọn cơ sở dữ liệu khác!";
                txbThongTinKetNoiCSDL.Text = ThongTinKetNoiCSDL;
            }
        }
        // Kiểm tra cơ sở dữ liệu có hợp lệ hay không
        private bool KiemTraCSDL(string tenCSDL)
        {
            string data = File.ReadAllText(@"13520589\\check_database.sql");
            var dsTables = LayTenCSDLCuaServer.Databases[tenCSDL].ExecuteWithResults(data);
            return dsTables.Tables[0].Rows.Count > 0;
        }

        private void btnXoa_Click(object sender, EventArgs e)
        {

            try
            {
                if (MessageBox.Show("Bạn có chắc chắn muốn xóa cơ sở dữ liệu " + TenCSDL, "Cảnh báo", MessageBoxButtons.YesNoCancel, MessageBoxIcon.Warning) == DialogResult.Yes)
                {
                    if (cbKieuXacThuc.SelectedIndex == 0)
                    {
                        string LayChuoiKetNoi = ChuoiKetNoiDenServer(TenServer, "master", IntegratedSecurity);
                        if (XoaCSDL(LayChuoiKetNoi, TenCSDL))
                        {
                            txbThongTinKetNoiCSDL.Clear();
                            txbThongTinKetNoiCSDL.Text = "Đã xóa thành công cơ sở dữ liệu '" + TenCSDL + "' từ SQL Server " + TenServer;
                            btnKiemTra.Enabled = true;
                            btnXoa.Enabled = false;
                            btnTaoMoi.Enabled = false;
                            btnKetNoiCSDL.Enabled = false;
                            cbTenCSDL.Items.Remove(TenCSDL);
                        }
                        else
                        {
                            txbThongTinKetNoiCSDL.Text = "Có lỗi xảy ra! Không thể xóa cơ sở dữ liệu: " + TenCSDL;
                        }

                    }
                    else
                    {
                        string LayChuoiKetNoi = ChuoiKetNoiDenServer(TenServer, "master", TenTaiKhoan, MatKhau, IntegratedSecurity);
                        if (XoaCSDL(LayChuoiKetNoi, TenCSDL))
                        {
                            txbThongTinKetNoiCSDL.Clear();
                            txbThongTinKetNoiCSDL.Text = "Đã xóa thành công cơ sở dữ liệu '" + TenCSDL + "' từ SQL Server " + TenServer;
                            btnKiemTra.Enabled = true;
                            btnXoa.Enabled = false;
                            btnTaoMoi.Enabled = false;
                            btnKetNoiCSDL.Enabled = false;
                        }
                        else
                        {
                            txbThongTinKetNoiCSDL.Text = "Có lỗi xảy ra! Không thể xóa cơ sở dữ liệ: " + TenCSDL;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ThongTinKetNoiCSDL = ex.Message;
                txbThongTinKetNoiCSDL.Text = "Có lỗi xãy ra: " + ThongTinKetNoiCSDL;
            }
        }

        // Xóa cơ sở dữ liệu
        public static bool XoaCSDL(string ChuoiKetNoi, string db)
        {
            SqlConnection connection = new SqlConnection(ChuoiKetNoi);
            try
            {
                SqlCommand cmd = new SqlCommand("ALTER DATABASE " + db + " SET SINGLE_USER WITH ROLLBACK IMMEDIATE", connection);
                cmd.CommandType = CommandType.Text;

                SqlCommand command = new SqlCommand();
                command.Connection = connection;
                command.CommandText = "Drop Database " + db.Trim();

                connection.Open();
                cmd.ExecuteNonQuery();
                connection.Close();

                connection.Open();
                command.ExecuteNonQuery();
                connection.Close();
                return true;

            }
            catch
            {
                if (connection.State == ConnectionState.Open)
                    connection.Close();
                return false;
            }
        }

        private void btnTaoMoi_Click(object sender, EventArgs e)
        {
            this.Cursor = Cursors.WaitCursor;
            try
            {
                if (cbKieuXacThuc.SelectedIndex == 0)
                {
                    string LayChuoiKetNoi = ChuoiKetNoiDenServer(TenServer, "master", IntegratedSecurity);
                    if (TaoMoiCSDL(LayChuoiKetNoi, TenCSDL, @"13520589\\Script_Trung_Tam_Anh_Ngu_A_Z.sql"))
                    {
                        txbThongTinKetNoiCSDL.Clear();
                        txbThongTinKetNoiCSDL.Text = "Đã tạo thành công cơ sở dữ liệu '" + TenCSDL + "' từ SQL Server " + TenServer;
                        btnKiemTra.Enabled = true;
                        btnXoa.Enabled = true;
                        btnTaoMoi.Enabled = false;
                        btnKetNoiCSDL.Enabled = true;
                        cbTenCSDL.Items.Remove(TenCSDL);
                    }
                    else
                    {
                        txbThongTinKetNoiCSDL.Text = "Có lỗi xảy ra! Không thể tạo cơ sở dữ liệu: " + TenCSDL;
                        this.Cursor = Cursors.Default;
                    }

                }
                else
                {
                    string LayChuoiKetNoi = ChuoiKetNoiDenServer(TenServer, "master", TenTaiKhoan, MatKhau, IntegratedSecurity);
                    if (TaoMoiCSDL(LayChuoiKetNoi, TenCSDL, @"13520589\\Script_Trung_Tam_Anh_Ngu_A_Z.sql"))
                    {
                        txbThongTinKetNoiCSDL.Clear();
                        txbThongTinKetNoiCSDL.Text = "Đã tạo thành công cơ sở dữ liệu '" + TenCSDL + "' từ SQL Server " + TenServer;
                        btnKiemTra.Enabled = true;
                        btnXoa.Enabled = false;
                        btnTaoMoi.Enabled = false;
                        btnKetNoiCSDL.Enabled = false;
                    }
                    else
                    {
                        txbThongTinKetNoiCSDL.Text = "Có lỗi xảy ra! Không thể tạo cơ sở dữ liệu: " + TenCSDL;
                        this.Cursor = Cursors.Default;
                    }
                }
            }
            catch (Exception ex)
            {
                ThongTinKetNoiCSDL = ex.Message;
                txbThongTinKetNoiCSDL.Text = "Có lỗi xảy ra: " + ThongTinKetNoiCSDL;
                this.Cursor = Cursors.Default;
            }
        }
        // Tạo mới cơ sở dữ liệu
        public static bool TaoMoiCSDL(string connectionString, string databaseName, string path)
        {
            SqlConnection connection = new SqlConnection(connectionString);
            try
            {
                string strscript = File.ReadAllText(path);
                string[] allCmd = strscript.Split(new[] { "GO" }, StringSplitOptions.RemoveEmptyEntries);

                SqlCommand sqlCmd = new SqlCommand();
                sqlCmd.CommandType = CommandType.Text;
                sqlCmd.Connection = connection;
                connection.Open();

                //sqlCmd.CommandText = " USE [master]";
                //sqlCmd.ExecuteNonQuery();
                // sqlCmd.CommandText = "CREATE DATABASE [" + databaseName + "]";
                //sqlCmd.ExecuteNonQuery();
                sqlCmd.CommandText = "USE [" + databaseName + "]";
                sqlCmd.ExecuteNonQuery();

                string ChuoiTruyVan = File.ReadAllText(@"13520589\\Script_Trung_Tam_Anh_Ngu_A_Z");
                sqlCmd.CommandText = ChuoiTruyVan;
                sqlCmd.ExecuteNonQuery();
                //for (int i = 0; i < allCmd.Length; i++)
                //{
                //    sqlCmd.CommandText = allCmd[i];
                //    sqlCmd.ExecuteNonQuery();
                //}
                connection.Close();
                return true;

            }
            catch
            {
                if (connection.State == ConnectionState.Open)
                    connection.Close();
                return false;
            }
        }

        private void frmConnectDatabase_Load(object sender, EventArgs e)
        {

            cbKieuXacThuc.SelectedIndex = 0;
            IntegratedSecurity = true;
            pnKetNoiServer.Enabled = true;
            pnKetNoiCSDL.Enabled = false;
            DanhSachTenServer = LayTatCaTenServer();

            foreach (string s in DanhSachTenServer)
                cbTenServer.Items.Add(s);

            cbTenServer.SelectedIndex = 0;
        }

        private void btnThoat_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void btnOK_Click(object sender, EventArgs e)
        {
            //Chưc code !
        }

        private void btnKetNoiCSDL_Click(object sender, EventArgs e)
        {
            //Chưc code !
        }

     


    }
}
