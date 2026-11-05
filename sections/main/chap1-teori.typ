= LAPORAN TEORI

== Fungsi ERD

_Entity Relationship Diagram_ (ERD) adalah model data konseptual yang menggambarkan objek, sifat, dan hubungan antarobjek dalam suatu sistem @chen1976. ERD menjadi rancangan awal sebelum database dibuat: membantu mengenali kebutuhan data, memudahkan komunikasi antara perancang dan pengguna, serta mencegah data ganda sejak tahap desain @elmasri2016.

== Komponen ERD

#figure(
  image("../../media/t-komponen-t.png", width: 82%),
  kind: "gambar",
  caption: [Simbol Komponen ERD]
)

- *Entity*: objek yang datanya disimpan, digambar sebagai persegi panjang.
- *Attribute*: sifat yang melekat pada entity, digambar sebagai elips.
- *Key Attribute*: atribut unik yang mengidentifikasi setiap data pada entity, ditandai garis bawah.
- *Relationship*: hubungan antar entity, digambar sebagai belah ketupat.
- *Cardinality*: jumlah keterlibatan entity dalam relationship, ditulis dengan notasi _crow's foot_.
- *Primary Key* (PK): atribut atau gabungan atribut yang mengidentifikasi satu baris secara unik dan tidak boleh kosong.
- *Foreign Key* (FK): atribut yang merujuk ke PK tabel lain sehingga kedua tabel dapat dihubungkan.

== Jenis Relasi

#figure(
  image("../../media/t-kardinalitas-t.png", width: 60%),
  kind: "gambar",
  caption: [Contoh Relasi 1:1, 1:M, dan M:N]
)

- *One to One (1:1)*: satu data berpasangan dengan paling banyak satu data lain. Contoh: satu mahasiswa memiliki satu kartu mahasiswa.
- *One to Many (1:M)*: satu data berpasangan dengan banyak data, FK diletakkan di sisi "banyak". Contoh: satu dosen mengampu banyak mata kuliah.
- *Many to Many (M:N)*: banyak data berpasangan dengan banyak data, dipecah menjadi tabel penghubung berisi dua FK. Contoh: mahasiswa dan mata kuliah dihubungkan tabel KRS.

== Normalisasi

Normalisasi adalah proses menguraikan tabel menjadi tabel-tabel yang lebih kecil berdasarkan ketergantungan antaratribut @codd1970. Tujuannya menghilangkan data ganda serta mencegah anomali _insert_, _update_, dan _delete_ @elmasri2016. Tahapnya:

- *1NF*: setiap sel berisi satu nilai (atomik), tidak ada kelompok data berulang, dan setiap baris memiliki PK.
- *2NF*: sudah 1NF dan semua atribut non-kunci bergantung penuh pada seluruh PK, bukan sebagian.
- *3NF*: sudah 2NF dan tidak ada atribut non-kunci yang bergantung pada atribut non-kunci lain (ketergantungan transitif).

#figure(
  image("../../media/t-normalisasi-t.png", width: 82%),
  kind: "gambar",
  caption: [Tahapan Normalisasi]
)
