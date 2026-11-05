#let pair(a, b, cap) = figure(
  grid(columns: (1fr, 1fr), column-gutter: 6pt, image(a, width: 100%), image(b, width: 100%)),
  kind: "gambar",
  caption: cap,
)
#let shot(f, cap, w: 100%) = figure(
  image("../../media/" + f + ".png", width: w),
  kind: "gambar",
  caption: cap,
)

#show raw: set text(font: "Courier New", size: 9pt)
#show raw: set par(leading: 0.55em, first-line-indent: 0pt, justify: false)

= LAPORAN PRAKTIKUM

== Database dan Tabel Akademik

Database dibuat dengan _Blank Database_, lalu tabel Mahasiswa, Dosen, Mata_Kuliah, dan KRS dibuat melalui _Table Design_. Primary key masing-masing tabel adalah NIM, NIP, Kode_MK, dan ID_KRS.

#shot("ph-a1", [Membuat Database Kosong], w: 80%)

#pair("../../media/ph-a2.png", "../../media/ph-a3.png", [Table Design Mahasiswa dan Dosen])

#pair("../../media/ph-a4.png", "../../media/ph-a5.png", [Table Design Mata_Kuliah dan KRS])

== Input Data

Data dimasukkan melalui _Datasheet View_ dengan urutan Mahasiswa, Dosen, Mata_Kuliah, lalu KRS agar sesuai aturan integritas referensial.

#shot("ds-a1", [Data Tabel Mahasiswa dan Dosen])

#shot("ds-a2", [Data Tabel Mata_Kuliah dan KRS])

== Relasi Antar Tabel

Relasi dibuat di jendela _Relationships_ dengan _Enforce Referential Integrity_: Dosen ke Mata_Kuliah (NIP), Mahasiswa ke KRS (NIM), dan Mata_Kuliah ke KRS (Kode_MK), seluruhnya 1:M.

#shot("ph-a6", [Jendela Relationships], w: 80%)

#shot("erd-a-wm", [ERD Database Akademik], w: 88%)

== Form Input Data

Setiap tabel dibuatkan satu form menggunakan _Form Wizard_ bertata letak _Columnar_.

#pair("../../media/ph-a7.png", "../../media/ph-a8.png", [Form Mahasiswa dan Form Dosen])

#pair("../../media/ph-a9.png", "../../media/ph-a10.png", [Form Mata_Kuliah dan Form KRS])

== Query Join dan Report

Query menggabungkan empat tabel dengan _INNER JOIN_, lalu hasilnya menjadi sumber Report.

```
SELECT Mahasiswa.NIM, Mahasiswa.Nama_Mahasiswa,
       Mata_Kuliah.Kode_MK, Mata_Kuliah.Nama_MK,
       Mata_Kuliah.SKS, Dosen.Nama_Dosen,
       KRS.Semester, KRS.Tahun_Akademik
FROM ((Mahasiswa INNER JOIN KRS ON Mahasiswa.NIM = KRS.NIM)
  INNER JOIN Mata_Kuliah ON KRS.Kode_MK = Mata_Kuliah.Kode_MK)
  INNER JOIN Dosen ON Mata_Kuliah.NIP = Dosen.NIP;
```

#shot("ph-a11", [Query Design Q_KRS_Lengkap], w: 80%)

#shot("ds-qa", [Hasil Query Q_KRS_Lengkap])

#shot("ph-a12", [Report Q_KRS_Lengkap], w: 80%)

== Normalisasi pada Microsoft Excel

Data pembelian awal masih tidak normal karena satu baris memuat data pelanggan, pemasok, gudang, barang, pengiriman, dan pembayaran sekaligus.

=== Bentuk Tidak Normal (UNF)

Pembelian PB001 memuat dua barang sehingga datanya berulang (sel digabung).

#shot("xl-unf", [Tabel UNF])

=== Bentuk 1NF

Sel kosong diisi, setiap nilai atomik, dan kolom no dihapus. PK berupa gabungan (id_pembelian, id_barang).

#shot("xl-1nf", [Tabel 1NF])

=== Bentuk 2NF

Terdapat ketergantungan parsial: data pelanggan, pemasok, gudang, pengiriman, dan pembayaran hanya bergantung pada id_pembelian, sedangkan nama_barang hanya bergantung pada id_barang. Tabel dipecah menjadi Pembelian, Barang, dan Detail_Pembelian.

#shot("xl-2nf", [Tabel 2NF], w: 94%)

=== Bentuk 3NF

Terdapat ketergantungan transitif, misalnya id_pelanggan menentukan nama_pelanggan. Tabel Pembelian dipecah lagi sehingga menjadi delapan tabel. Kolom total_harga dihapus karena dapat dihitung dari jumlah dikali harga_satuan.

#shot("xl-3nf", [Tabel 3NF])

== Implementasi Hasil Normalisasi di Access

Delapan tabel hasil 3NF dibuat dalam database yang sama, masing-masing dengan PK dan FK sesuai hasil normalisasi.

#shot("ph-b1", [Navigation Pane Tabel Hasil Normalisasi], w: 80%)

#shot("ds-b1", [Data Tabel Pelanggan, Pemasok, dan Gudang])

#shot("ds-b2", [Data Tabel Barang, Pengiriman, dan Pembayaran])

#shot("ds-b3", [Data Tabel Pembelian dan Detail_Pembelian])

Relasi yang terbentuk: Pelanggan, Pemasok, dan Gudang ke Pembelian (1:M); Pengiriman dan Pembayaran ke Pembelian (1:1); Pembelian dan Barang ke Detail_Pembelian (1:M).

#shot("ph-b2", [Jendela Relationships Delapan Tabel], w: 80%)

#shot("erd-b-wm", [ERD Hasil Normalisasi], w: 92%)

Query berikut menampilkan seluruh data pembelian beserta total harga tiap barang.

```
SELECT Pembelian.id_pembelian, Pelanggan.nama_pelanggan,
       Pemasok.nama_pemasok, Gudang.nama_gudang,
       Barang.nama_barang, Detail_Pembelian.jumlah,
       Detail_Pembelian.harga_satuan,
       [jumlah]*[harga_satuan] AS total_harga,
       Pembayaran.status_pembayaran
FROM Barang INNER JOIN (Pembayaran INNER JOIN (Pengiriman
  INNER JOIN (Gudang INNER JOIN (Pemasok INNER JOIN
  (Pelanggan INNER JOIN Pembelian
    ON Pelanggan.id_pelanggan = Pembelian.id_pelanggan)
    ON Pemasok.id_pemasok = Pembelian.id_pemasok)
    ON Gudang.id_gudang = Pembelian.id_gudang)
    ON Pengiriman.id_pengiriman = Pembelian.id_pengiriman)
    ON Pembayaran.id_pembayaran = Pembelian.id_pembayaran)
  INNER JOIN Detail_Pembelian
    ON Pembelian.id_pembelian = Detail_Pembelian.id_pembelian)
  ON Barang.id_barang = Detail_Pembelian.id_barang;
```

#shot("ph-b3", [Query Design Q_Pembelian_Lengkap], w: 80%)

#shot("ds-qb", [Hasil Query Q_Pembelian_Lengkap])
