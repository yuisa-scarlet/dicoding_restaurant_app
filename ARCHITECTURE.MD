## ARCHITECTURE

State Management: Provider
Network: http
Loading animation: Shimmer

## RULE

Semua inisiasi harus berada di dalam file app.dart

## FOLDER STRUCTURE

lib/
├── core/
│   ├── api_client.dart
│   ├── app.dart
│   ├── app_route.dart
│   └── config.dart
├── features/
│   ├── home/
│   │   ├── providers/
│   │   │   ├── restaurant_detail/
│   │   │   │   └── restaurant_detail_provider.dart
│   │   │   └── restaurant_list/
│   │   │       └── restaurant_list_provider.dart
│   │   ├── screens/
│   │   │   ├── home_detail_screen.dart
│   │   │   └── home_screen.dart
│   │   └── widgets/
│   │       └── restaurant_card.dart
│   └── setting/
│       └── screens/
│           └── setting_screen.dart
├── shared/
│   ├── model/
│   │   ├── customer_review.dart
│   │   ├── item.dart
│   │   ├── menu.dart
│   │   └── restaurant.dart
│   └── widgets/
│       └── restaurant_bottom_navigation.dart
└── main.dart


## SCREEN

1. Home Screen
2. Home Detail Screen
3. Setting Screen


## PROVIDER

1. Restaurant List Provider
2. Restaurant Detail Provider


## API

1. Restaurant List
2. Restaurant Detail


## FEATURE

1. Halaman Daftar Restoran
- Membuat satu halaman berisi daftar restoran.
- Informasi daftar restoran didapat dari API.
- Menampilkan item yang mencakup informasi minimal, seperti nama, gambar, kota, dan rating restoran.

2. Halaman Detail Restoran
- Membuat satu halaman berisi detail restoran.
- Informasi detail restoran didapat dari API.
- Menampilkan informasi restoran, seperti nama, gambar, deskripsi, kota, alamat, rating, menu makanan, dan minuman.

3. Mengganti Tema Default
- Menambahkan tema terang dan gelap.
- Mengubah default font type.
- Mengubah warna pada tema selain warna default aplikasi.

4. Indikator Loading
- Terdapat indikator loading untuk setiap proses pemanggilan API.
- Indikator loading menggunakan shimmer

5. Menggunakan State Management
- Menggunakan library state management Provider.
- Cukup menggunakan satu state management untuk mengelola state.
- Manfaatkan sealed class, khususnya pada saat memanggil Web API.

6. Membuat Halaman Favorit Restoran
- Membuat satu halaman khusus berisi daftar favorit restoran. 
- Menampilkan item card pada halaman daftar favorit yang mencakup informasi minimal, seperti nama, gambar, kota, dan rating restoran. 
- Apabila item favorit ditekan, aplikasi dapat bernavigasi ke halaman detail. 
- Pengguna bisa menambah dan menghapus item restoran dari daftar favorit atau detail restoran.
- Informasi daftar favorit restoran didapatkan melalui pencatatan database SQLite. 

7. Membuat Fitur Pengaturan Daily Reminder
- Menambahkan pengaturan untuk menghidupkan dan mematikan reminder di halaman setting.
- Simpan pengaturan Daily Reminder menggunakan penyimpanan shared preferences.
- Menampilkan notifikasi pada pukul 11.00 AM dengan memanfaatkan Schedule Notification untuk mengingatkan makan siang.

8. Membuat Pengujian (Testing)
- Menerapkan tiga skenario pengujian pada fungsi di dalam Provider untuk mengambil list data restoran.
- Berikut skenario yang bisa Anda buat. 
-- Memastikan state awal provider harus didefinisikan.
-- Memastikan harus mengembalikan daftar restoran ketika pengambilan data API berhasil.
-- Memastikan harus mengembalikan kesalahan ketika pengambilan data API gagal.