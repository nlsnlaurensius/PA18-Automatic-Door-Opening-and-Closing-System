# PA18-Automatic-Door-Opening-and-Closing-System-

Nelson Laurensius		2306161845
Jesaya David Gamalael N P	2306161965
Fido Wahyu Choirulinsan	2306250674
Kelvin Ferrell Tjoe		2306205393


## Introduction

pintu dibuat untuk meningkatkan keamanan suatu tempat. namun, pintu terkadang menimbulkan beberapa masalah, seperti menjadi tempat menyebaran kuman pada gagangnya, tidak ramah untuk lansia dan penderita disabilitas, dan menghilangkan kondisi ideal seperti suhu jika tidak tertutup rapat.

proyek ini dirancang untuk menyelesaikan masalah-masalah tersebut. dengan otomatisasi buka-tutup pintu, kontak dengan pintu menjadi seminimal mungkin, sehingga penyebaran kuman lebih lambat. selain itu, aksesibilitas bagi lansia dan penderita disabilitas menjadi lebih mudah, dan pintu akan selalu tertutup kembali, sehingga kondisi ideal suatu ruangan dapat terjaga

## Komponen yang Digunakan
- Arduino UNO (ATmega328P) (1 unit)
- Sensor Ultrasonik HC-SR04 (1 unit)
- Servo Motor (SG90) (1 unit)
- LCD 16x2 I2C (1 unit)
- LED Merah dan Hijau (masing-masing 1 unit)
- Resistor 220Ω (ini berapa?)
- Breadboard dan Kabel Jumper
- Power Supply

## Implementasi Komponen
- Sensor Ultrasonik HC-SR04
Berfungsi untuk mendeteksi jarak objek di depan pintu.
Terhubung ke pin digital Arduino: Trig untuk mengirim sinyal ultrasonik, dan Echo untuk menerima pantulan sinyal.
Dalam Assembly, durasi pulsa dari Echo dikonversi ke jarak menggunakan timer internal.

- Arduino UNO (ATmega328P)
Mengontrol seluruh sistem: membaca sensor, mengatur servo, LED, dan LCD. Diprogram dengan Assembly untuk manipulasi langsung register dan I/O.

- Servo Motor
Membuka dan menutup pintu berdasarkan logika dari mikrokontroler.
Kontrol sudut servo dilakukan melalui sinyal PWM yang dihasilkan dari register Timer/Counter.
Sudut 0° = tertutup, 90° = terbuka.

- LED Indikator (Merah & Hijau)
Memberikan visualisasi status pintu:
LED Merah menyala saat pintu tertutup.
LED Hijau menyala saat pintu terbuka.
Pengaturan dilakukan melalui bit-manipulasi register PORT di kode Assembly.

- LCD 16x2 dengan I2C
Menampilkan informasi status pintu (“OPEN” atau “CLOSED”) dan countdown waktu penutupan otomatis.
Terhubung ke pin SDA dan SCL Arduino via protokol I2C.
Komunikasi dikendalikan melalui register TWI (TWCR, TWDR, dll.) dalam Assembly.

- Breadboard & Kabel Jumper
Digunakan untuk merangkai seluruh komponen Rangkaian dan mudah diuji/cabut-pasang.
Menyediakan konektivitas sementara sebelum sistem dipasang permanen.

## Software

Sistem diprogram menggunakan Assembly AVR dan sebagian kode .ino untuk sensor.
Fitur utama yang diimplementasikan dalam Assembly meliputi:
- Inisialisasi Sistem: Mengatur pin input/output, timer, dan komunikasi I2C.
- Pembacaan Sensor: Mengukur durasi pulsa Echo dari HC-SR04 dan menghitung jarak.
- Kontrol Servo: Mengatur sudut servo melalui PWM menggunakan Timer/Counter.
- LED Indikator: Menyalakan LED sesuai status pintu melalui register PORT.
- LCD I2C: Menampilkan status pintu dan countdown dengan komunikasi TWI/I2C.
- Logika Pintu: Menentukan kapan pintu membuka/menutup berdasarkan jarak dan waktu.

## Hasil Tes

untuk membuktikan bahwa rangkaian dapat berjalan dengan baik. maka dilakukan tes pada rangkaian menggunakan kode AVR yang sudah dibuat sebelumnya. tes dilakukan untuk membuktikan bahwa keseluruhan komponen dapat berfungsi secara optimal.
* pembacaan sensor: sensor dapat mendeteksi objek secara akurat dengan batas pembacaan 400 cm dan ambang batas 30 cm.
* pergerakan servo: servo dapat digerakkan sebesar 90 derajat dan kembali ke posisi semula menggunakan PWM pada kode assembly dengan respons yang baik.
* LED dan LCD: Pengaturan bit pada register PORT untuk LED dan pengiriman data I2C melalui register TWI oleh kode Assembly berfungsi dengan benar, sehingga LED merah dan hijau menyala sesuai status pintu, dan LCD menampilkan teks "CLOSED", "OPEN", serta hitungan mundur.
* fungsionalitas rangkaian secara keseluruhan: pintu akan terbuka secara otomatis ketika terdapat objek yang terdeteksi oleh sensor. LCD akan mulai menampilkan hitungan mundur ketika objek tidak terdeteksi, dan setelah hitung mundur selesai maka pintu akan tertutup. 

berdasarkan hasil pengujian, sistem pintu otomatis dapat melakukan fungsi utamanya dengan menggunakan pemrograman assemmbly AVR.

## Kesimpulan

Proyek *"Implementasi Sensor HC-SR04 dalam Sistem Pintu Otomatis Berbasis Arduino dengan LCD I2C dan Servo Motor"* berhasil mengembangkan sistem yang menggunakan sensor ultrasonik HC-SR04 untuk mendeteksi objek, mikrokontroler ATmega328P (Arduino UNO) yang diprogram dengan Assembly dan .ino sebagai pengendali utama, serta servo motor sebagai aktuator dan LCD I2C serta LED untuk tampilan visual. Sistem ini bekerja dengan memanipulasi register mikrokontroler secara langsung melalui kode Assembly untuk membaca data sensor, menggerakkan servo, mengatur indikator LED, dan menampilkan informasi pada LCD. Pintu dapat terbuka otomatis saat mendeteksi objek dan menutup kembali setelah jeda waktu tertentu, membuktikan kemampuan kontrol real-time pada level pemrograman rendah. Proyek ini tidak hanya menunjukkan pemahaman mendalam tentang arsitektur AVR dan pemrograman Assembly, tetapi juga menjadi dasar pengembangan sistem embedded dan otomasi lebih lanjut, meskipun menghadapi tantangan kompleksitas pemrograman tingkat rendah.

