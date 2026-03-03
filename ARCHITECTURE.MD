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