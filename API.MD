## BASE URL

https://restaurant-api.dicoding.dev

## ENDPOINT

- GET /list → untuk mendapatkan daftar restoran

Response:
{
  "error": false,
  "message": "success",
  "count": 20,
  "restaurants": [
      {
          "id": "rqdv5juczeskfw1e867",
          "name": "Melting Pot",
          "description": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...",
          "pictureId": "14",
          "city": "Medan",
          "rating": 4.2
      },
      {
          "id": "s1knt6za9kkfw1e867",
          "name": "Kafe Kita",
          "description": "Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. ...",
          "pictureId": "25",
          "city": "Gorontalo",
          "rating": 4
      }
  ]
}

- GET /detail/{id} → untuk mendapatkan detail restoran berdasarkan ID

Response:
{
  "error": false,
  "message": "success",
  "restaurant": {
      "id": "rqdv5juczeskfw1e867",
      "name": "Melting Pot",
      "description": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. ...",
      "city": "Medan",
      "address": "Jln. Pandeglang no 19",
      "pictureId": "14",
      "categories": [
          {
              "name": "Italia"
          },
          {
              "name": "Modern"
          }
      ],
      "menus": {
          "foods": [
              {
                  "name": "Paket rosemary"
              },
              {
                  "name": "Toastie salmon"
              }
          ],
          "drinks": [
              {
                  "name": "Es krim"
              },
              {
                  "name": "Sirup"
              }
          ]
      },
      "rating": 4.2,
      "customerReviews": [
          {
              "name": "Ahmad",
              "review": "Tidak rekomendasi untuk pelajar!",
              "date": "13 November 2019"
          }
      ]
  }
}

- GET /search?q={query} → untuk mencari restoran berdasarkan nama atau deskripsi
Response:
{
  "error": false,
  "founded": 1,
  "restaurants": [
      {
          "id": "fnfn8mytkpmkfw1e867",
          "name": "Makan mudah",
          "description": "But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, ...",
          "pictureId": "22",
          "city": "Medan",
          "rating": 3.7
      }
  ]
}

- POST /review → untuk menambahkan ulasan
Request:
{
  "id": "212RestaurantId",
  "name": "John Doe",
  "review": "Restoran ini luar biasa!"
}

Response:
{
  "error": false,
  "message": "success",
  "customerReviews": [
    {
      "name": "John Doe",
      "review": "Restoran ini luar biasa!",
      "date": "2020-01-01T05:05:05.000Z"
    }
  ]
}

## IMAGE FETCHING

Small resolution: https://restaurant-api.dicoding.dev/images/small/<pictureId>
Medium resolution: https://restaurant-api.dicoding.dev/images/medium/<pictureId>
Large resolution: https://restaurant-api.dicoding.dev/images/large/<pictureId>