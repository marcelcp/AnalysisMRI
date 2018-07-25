  
## References
1. Voxel Activity Prediction http://users.stat.umn.edu/~gall0441/images/Openfmri_Voxel_Activity_Prediction.pdf
2. Dataset OpenNeuro https://openneuro.org/datasets/ds000001/
3. File dataset dapat di download disini https://drive.google.com/file/d/1G-yAZAXgCHcpEhL2teV174fu4Fu-y442/view?usp=sharing

## Disclaimer
Percobaan ini dilakukan dengan mengikuti OpenfMRI Voxel Activity Prediction karya Matt Galloway dengan dilakukan beberapa modifikasi untuk tujuan studi. Data disediakan oleh organisasi OpenfMRI (openfmri.org) yang berfokus pada open-source dan berbagi dataset MRI (magnetic resonance imaging).

# AnalysisMRI using Rshiny
Anggota proyek kelompok:
<table>
  <tr>
    <th>No</th>
    <th>Member Name</th>
    <th>Github Userid</th>
    <th>Student Id</th>
  </tr>
  <tr>
    <th>2</th>
    <th>Dustin Pradipta</th>
  <th><a href="https://github.com/dust16">@dust16</th>
    <th>00000011798</th>
  <tr>
    <th>2</th>
    <th>Marcel Cahya Prasetia</th>
  <th><a href="https://github.com/marcelcp">@marcelcp</th>
    <th>00000019043</th>
  </tr>
   <tr>
    <th>3</th>
    <th>Williem Citralin</th>
    <th><a href="https://github.com/tyrand3">@tyrand3</th>
    <th>00000014292</th> 
  </tr>
</table>

## Voxel Activity Prediction menggunakan OpenfMRI

Penelitian ini bertujuan untuk melakukan prediksi dan pemberian visual pada bagian otak yang sedang beraktifitas. Pemodelan aktifitas netral dilakukan dengan studi fmri yang menggunakan polynomial kernel estimation. Dataset digunakan untuk melakukan statistik yang diperlukan untuk melacak aktifitas otak. Aktifitas tersebut direpresentasikan dengan perubahan alur darah pada otak. Pendeteksian dilakukan dengan melakukan monitor pada *hemodynamic response blood-oxygen-level dependent (BOLD)* untuk setiap voxel pada dataset. Voxel merepresentasikan nilai dari *regular grid* di ruang 3D.

## Persiapan

- Dataset yang dijadikan bahan penelitian adalah file dengan kategori NIFTI (bold.nii). 
- Dataset yang digunakan adalah sub-01_task-balloonanalogrisktask_run-01_bold.nii.gz 
- Objek ini memiliki 4 dimensi D[x, y, z, t] di mana x, y ∈ {1, ..., 64}, z ∈ {1, ..., 33}, dan t ∈ {1, ..., 210}. 
- Prediksi dilakukan terhadap respon hemodynamic dari setiap voxel. Untuk melakukan hal ini, dilakukan kernel non-parametric regression dari D[x, y, z, t] terhadap t di mana t adalah variabel waktu.
<p align="center"><img src="http://latex.codecogs.com/gif.latex?D[x,y,z,t]=&space;\muµ_{x,y,z}(t)&plus;\epsilon_{x,y,z}(t)" /></p>
  Pada rumus di atas, µ adalah fungsi yang akan dihitung. Penentu untuk µ(ti) adalah sebagai berikut:
<p align="center"><img src="http://latex.codecogs.com/gif.latex?\hat{\mu}(ti)=\frac{\sum&space;D_{x,y,z}(ti)K(\frac{t_{1}-t}{h})}{\sum&space;K(\frac{t_{1}-t}{h})}" title="\hat{\mu}(ti)=\frac{\sum D_{x,y,z}(ti)K(\frac{t_{1}-t}{h})}{\sum K(\frac{t_{1}-t}{h})}" /></p>
  Setiap pasangan (x, y, z) disebut dengan voxel yang dapat diibaratkan seperti pixel 3 dimensi. 

## Library R

Dalam melakukan penelitian digunakan library berikut:
- `library(shiny)` -> digunakan untuk menampilkan dalam bentuk website
- `library(fmri)` -> digunakan untuk membaca file .nii dan melakukan masking 
- `library(locfit)` -> digunakan untuk training data dengan mengaplikasikan `local polynomial model` dan `local linear regression`
- `library(NeatMap)`  -> digunakan untuk menampilkan kumpulan voxels dalam `bentuk heatmap`

## Langkah Penelitian

### 1. Membaca *file* .nii
Tahapan *readfile* menggunakan `library(fmri)`:
- Menggunakan `getwd()` untuk mengetahui lokasi file agar dapat dibaca
- Proses membaca file .nii hingga selesai dengan menggunakan fungsi `read.NIFTI(path)`

### 2. Masking
Tahapan *masking* menggunakan `library(fmri)`:
-Data yang diambil hanya bagian *mask* saja untuk diamati pada fungsi `data$mask`
  - Tujuannya dilakukan *masking* adalah untuk memfokuskan daerah penelitian. Daerah yang akan diteliti adalah daerah yang di *masking*, sedangkan daerah yang tidak di *masking* akan diabaikan sehingga akan mengurangi waktu komputasi
- Dilakukan *train* pada data *mask* tersebut

### 3. Melakukan *training data*
Tahapan *train* menggunakan `library(locfit)`:
- Dengan menggunakan MSE melalui beberapa tahap:
  - Dalam penggunaannya MSE digunakan untuk menganalisa kinerja linear regression karena memungkinkan untuk mempartisi variasi dataset menjadi variasi dalam bentuk model
  - `Split test` dengan menggunakan 80% train dan 20% valid pada mask `per = round(210 * 0.8)`
  - `Cross validation` akan menggunakan `bandwidth` dan mengambil data random dari semua sisi fitting process dengan fungsi
    `sample(index, per)` dan `index[-index_train]` 
  - `Kernel density estimation` adalah *non-parametric* distribusi probabilitas (diambil dari rata-rata dan variasi). Bandwidth pada kernel adalah variabel yang bebas yang memiliki pengaruh kuat dalam mendapatkan hasil.
- Menggunakan `local polynomial model` yang didalamnya terdapat fitting process berdasarkan `bandwidth` (jumlah voxel yang ingin          diteliti) dengan menggunakan fungsi `locfit()`
- Dicari `bandwidth` yang  menampilkan `balance` antara variasi dan hasil rata-rata prediksi
- Hasil pertama akan menampilkan MSE dari train dan validasi 
<p align="center"><img src="https://github.com/marcelcp/AnalysisMRI/blob/master/MSE_result.png" /></p><br />
Kesimpulan dari hasil MSE pada `bandwidth` adalah semakin kecil `bandwidth` yang digunakan, mengakibatkan variasinya semakin besar dan sebaliknya. Dipilih bandwidth 20 karena diatasnya sudah memiliki variasi yang kecil<br /><br />


Tahapan prediksi menggunakan `library(locfit)`:
- Dari bandwidth 20 akan dilakukan proses `local linear regression` dari hasil prediksi `local polynomial model` dengan menggunakan fungsi `lm()`
- Akan diukur *activity* menggunakan `mean()` diantara `local polynomial model` dan `local linear regression` yang akan menghasilkan nilai MSE, semakin besar nilai MSE (*distance*) maka voxel tersebut lebih aktif
- *Activity* merepresentasikan koordinat voxel yang didalamnya terdapat nilai MSE

### 4. Menampilkan hasil
Hasil prediksi ditampilkan dalam bentuk `heatmap` menggunakan `library(NeatMap)`: 
- `Heatmap` merepresentasikan kumpulan voxel membentuk otak
- Pada voxel tertentu yang gelap, maka aktivitas pada voxel tersebut semakin minimal atau kurangnya aktivitas. Sedangkan pada voxel yang terang, menunjukkan bahwa terdapat aktivitas yang lebih aktif
- Hasil lainnya, jika menggunakan bandwidth 5 akan menghasilkan kumpulan voxel yang lebih terang dikarenakan variasinya yang lebih besar dari pada bandwidth 20

### 5. *Visualisasi data* 
Data akan ditampilkan secara visual dalam bentuk plot menggunakan aplikasi Shiny. Library yang digunakan adalah `library(Shiny)` dan `library(datasets)`. Plot yang ditampilkan adalah:
  
- Hasil Graph Voxel Activity pada [21,41,20]:<br />
  - Komponen I,J,K -> I adalah sumbu X, J adalah sumbu Y, dan K adalah sumbu rotasi Z
  <p align="center">Bandwidth 5:</br><img src="https://raw.githubusercontent.com/marcelcp/AnalysisMRI/master/result_zplane%3D16/activity%5B21%2C41%2C20%5D/graph_band_5.png" /></p>
  <p align="center">Bandwidth 20:</br><img src="https://raw.githubusercontent.com/marcelcp/AnalysisMRI/master/result_zplane%3D16/activity%5B21%2C41%2C20%5D/graph_band_20.png" /></p>
  <p align="center">Bandwidth 35:</br><img src="https://raw.githubusercontent.com/marcelcp/AnalysisMRI/master/result_zplane%3D16/activity%5B21%2C41%2C20%5D/graph_band_35.png" /></p>

- Heatmap:<br />
  <p align="center">Bandwidth 5:</br><img src="https://raw.githubusercontent.com/marcelcp/AnalysisMRI/master/result_zplane%3D16/bandwidth_5.png" /></p>
  <p align="center">Bandwidth 20:</br><img src="https://raw.githubusercontent.com/marcelcp/AnalysisMRI/master/result_zplane%3D16/bandwidth_20.png" /></p>
  <p align="center">Bandwidth 35:</br><img src="https://raw.githubusercontent.com/marcelcp/AnalysisMRI/master/result_zplane%3D16/bandwidth_35.png" /></p>


## Kesimpulan
Kami yakin bahwa penelitian ini telah berhasil melakukan prediksi terhadap aktivitas yang terjadi di dalam otak yang direpresentasikan dalam bentuk voxel. Hasil setiap voxel didapatkan dari hasil MSE diantara local polynomial model dan local linear regression. Pada gambar heatmap, terdapat area yang lebih berwarna terang dan gelap. Pada area yang lebih terang, merepresentasikan voxel yang memiliki banyak aktivitas pada otak yang didapatkan dari nilai MSE yang besar pada voxel tersebut. Sebaliknya, untuk area yang lebih gelap merepresentasikan aktivitas otak yang kurang aktif atau minimal yang didapatkan dari nilai MSE yang lebih kecil. 
