import java.sql.*;
public class MakeDb {
  public static void main(String[] a) throws Exception {
    String f=a[0];
    new java.io.File(f).delete();
    try(Connection c=DriverManager.getConnection("jdbc:ucanaccess://"+f+";newdatabaseversion=V2010");Statement s=c.createStatement()){
      String[] ddl={
      "CREATE TABLE Mahasiswa(NIM VARCHAR(8) PRIMARY KEY, Nama_Mahasiswa VARCHAR(50), Jenis_Kelamin VARCHAR(1), Tanggal_Lahir DATETIME, Alamat VARCHAR(50))",
      "CREATE TABLE Dosen(NIP VARCHAR(5) PRIMARY KEY, Nama_Dosen VARCHAR(50), Bidang VARCHAR(40), No_HP VARCHAR(15))",
      "CREATE TABLE Mata_Kuliah(Kode_MK VARCHAR(6) PRIMARY KEY, Nama_MK VARCHAR(50), SKS INTEGER, NIP VARCHAR(5), CONSTRAINT fk_mk_dosen FOREIGN KEY (NIP) REFERENCES Dosen(NIP))",
      "CREATE TABLE KRS(ID_KRS VARCHAR(8) PRIMARY KEY, NIM VARCHAR(8), Kode_MK VARCHAR(6), Semester INTEGER, Tahun_Akademik VARCHAR(10), CONSTRAINT fk_krs_mhs FOREIGN KEY (NIM) REFERENCES Mahasiswa(NIM), CONSTRAINT fk_krs_mk FOREIGN KEY (Kode_MK) REFERENCES Mata_Kuliah(Kode_MK))",
      "CREATE TABLE Pelanggan(id_pelanggan VARCHAR(6) PRIMARY KEY, nama_pelanggan VARCHAR(50))",
      "CREATE TABLE Pemasok(id_pemasok VARCHAR(6) PRIMARY KEY, nama_pemasok VARCHAR(50))",
      "CREATE TABLE Gudang(id_gudang VARCHAR(6) PRIMARY KEY, nama_gudang VARCHAR(50))",
      "CREATE TABLE Barang(id_barang VARCHAR(6) PRIMARY KEY, nama_barang VARCHAR(50))",
      "CREATE TABLE Pengiriman(id_pengiriman VARCHAR(8) PRIMARY KEY, tanggal_kirim DATETIME, kurir VARCHAR(20))",
      "CREATE TABLE Pembayaran(id_pembayaran VARCHAR(8) PRIMARY KEY, metode_pembayaran VARCHAR(20), status_pembayaran VARCHAR(15))",
      "CREATE TABLE Pembelian(id_pembelian VARCHAR(6) PRIMARY KEY, id_pelanggan VARCHAR(6), id_pemasok VARCHAR(6), id_gudang VARCHAR(6), id_pengiriman VARCHAR(8), id_pembayaran VARCHAR(8), "
       +"CONSTRAINT fk_pb_plg FOREIGN KEY (id_pelanggan) REFERENCES Pelanggan(id_pelanggan), CONSTRAINT fk_pb_psm FOREIGN KEY (id_pemasok) REFERENCES Pemasok(id_pemasok), "
       +"CONSTRAINT fk_pb_gd FOREIGN KEY (id_gudang) REFERENCES Gudang(id_gudang), CONSTRAINT fk_pb_png FOREIGN KEY (id_pengiriman) REFERENCES Pengiriman(id_pengiriman), CONSTRAINT fk_pb_byr FOREIGN KEY (id_pembayaran) REFERENCES Pembayaran(id_pembayaran))",
      "CREATE TABLE Detail_Pembelian(id_pembelian VARCHAR(6), id_barang VARCHAR(6), jumlah INTEGER, harga_satuan LONG, PRIMARY KEY(id_pembelian,id_barang), "
       +"CONSTRAINT fk_dt_pb FOREIGN KEY (id_pembelian) REFERENCES Pembelian(id_pembelian), CONSTRAINT fk_dt_brg FOREIGN KEY (id_barang) REFERENCES Barang(id_barang))"};
      for(String q:ddl) s.execute(q);
      String[] ins={
      "INSERT INTO Dosen VALUES('D001','Dr. Ahmad Zaini','Basis Data','081234567891')","INSERT INTO Dosen VALUES('D002','Dr. Lina Suryani','Pemrograman','081234567892')",
      "INSERT INTO Dosen VALUES('D003','Dr. Hendra Putra','Jaringan','081234567893')","INSERT INTO Dosen VALUES('D004','Dr. Maya Anjani','Sistem Informasi','081234567894')",
      "INSERT INTO Dosen VALUES('D005','Dr. Yusuf Ramli','Kecerdasan Buatan','081234567895')",
      "INSERT INTO Mahasiswa VALUES('20231001','Andi Setiawan','L',#2003-01-15#,'Depok')","INSERT INTO Mahasiswa VALUES('20231002','Siti Rahma','P',#2004-02-22#,'Bekasi')",
      "INSERT INTO Mahasiswa VALUES('20231003','Budi Santoso','L',#2003-05-10#,'Surabaya')","INSERT INTO Mahasiswa VALUES('20231004','Dewi Lestari','P',#2004-09-07#,'Bandung')",
      "INSERT INTO Mahasiswa VALUES('20231005','Rian Pratama','L',#2003-12-30#,'Jakarta')",
      "INSERT INTO Mata_Kuliah VALUES('MK001','Basis Data',3,'D001')","INSERT INTO Mata_Kuliah VALUES('MK002','Pemrograman Objek',3,'D002')",
      "INSERT INTO Mata_Kuliah VALUES('MK003','Jaringan Komputer',2,'D003')","INSERT INTO Mata_Kuliah VALUES('MK004','Pembelajaran Mesin',3,'D004')",
      "INSERT INTO Mata_Kuliah VALUES('MK005','Kecerdasan Buatan',3,'D005')",
      "INSERT INTO KRS VALUES('KRS001','20231001','MK001',3,'2024/2025')","INSERT INTO KRS VALUES('KRS002','20231002','MK002',3,'2024/2025')",
      "INSERT INTO KRS VALUES('KRS003','20231003','MK003',3,'2024/2025')","INSERT INTO KRS VALUES('KRS004','20231004','MK004',3,'2024/2025')",
      "INSERT INTO KRS VALUES('KRS005','20231005','MK005',3,'2024/2025')",
      "INSERT INTO Pelanggan VALUES('PLG01','Andi Pratama')","INSERT INTO Pelanggan VALUES('PLG02','Siti Rahma')","INSERT INTO Pelanggan VALUES('PLG03','Budi Santoso')",
      "INSERT INTO Pemasok VALUES('PSM01','PT Sumber Rejeki')","INSERT INTO Pemasok VALUES('PSM02','CV Pangan Makmur')",
      "INSERT INTO Gudang VALUES('GD01','Gudang Jakarta')","INSERT INTO Gudang VALUES('GD02','Gudang Bandung')",
      "INSERT INTO Barang VALUES('BRG01','Beras')","INSERT INTO Barang VALUES('BRG02','Minyak Goreng')","INSERT INTO Barang VALUES('BRG03','Gula')",
      "INSERT INTO Pengiriman VALUES('PNG001',#2025-01-10#,'JNE')","INSERT INTO Pengiriman VALUES('PNG002',#2025-01-12#,'SiCepat')","INSERT INTO Pengiriman VALUES('PNG003',#2025-01-13#,'J&T')",
      "INSERT INTO Pembayaran VALUES('BYR001','Transfer Bank','Lunas')","INSERT INTO Pembayaran VALUES('BYR002','COD','Pending')","INSERT INTO Pembayaran VALUES('BYR003','E-Wallet','Lunas')",
      "INSERT INTO Pembelian VALUES('PB001','PLG01','PSM01','GD01','PNG001','BYR001')","INSERT INTO Pembelian VALUES('PB002','PLG02','PSM02','GD02','PNG002','BYR002')","INSERT INTO Pembelian VALUES('PB003','PLG03','PSM01','GD01','PNG003','BYR003')",
      "INSERT INTO Detail_Pembelian VALUES('PB001','BRG01',2,72000)","INSERT INTO Detail_Pembelian VALUES('PB001','BRG02',1,18000)","INSERT INTO Detail_Pembelian VALUES('PB002','BRG01',1,75000)","INSERT INTO Detail_Pembelian VALUES('PB003','BRG03',3,14000)"};
      for(String q:ins) s.execute(q);
    }
    System.out.println("ok");
  }
}
