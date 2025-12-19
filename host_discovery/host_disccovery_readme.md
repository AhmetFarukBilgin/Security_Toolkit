# Host Discovery Script

Bu betik, VPN veya iç ağ ortamlarında **hızlı ve esnek host discovery (canlı host tespiti)** yapmak amacıyla geliştirilmiştir.  
Port taraması yapmaz; yalnızca ağdaki **aktif (up) hostları** tespit etmeye odaklanır.

Özellikle:
- Hack The Box / TryHackMe
- Internal network testleri
- VPN üzerinden yapılan keşif (reconnaissance) aşamaları

için uygundur.

---

## Özellikler

- Birden fazla **host discovery metodu**
- Seçilebilir **hız profilleri**
- CIDR veya **IP listesi (.txt)** ile çalışma
- Aynı anda birden fazla **çıktı formatı**
- Temiz **sadece IP listesi** üretme
- Desktop altında otomatik sonuç klasörü

---

## Gereksinimler

- Linux / Unix tabanlı sistem
- `nmap`
- `bash`

Kontrol:
```bash
nmap --version
```
---

## Kurulum

```bash
chmod +x host_discovery.sh
```
Opsiyonel | Sistem geneline yaymak için
```bash
sudo mv host_discovery.sh /usr/local/bin/host-discovery
```

## Kullanım
```bash
./host_discovery.sh -t <target> -m <method> -s <speed> -o <output>
```

## Parametreler

### target(-t)

Tarama hedefi aşağıdaki formatlardan biri olabilir
> CIDR Bloğu
```bash
10.10.14.0/23
```
 IP listesi içeren dosya
 ```bash
targets.txt
```

### Discovery Method (-m)
|  Metot  |             Açıklama             |
|:-------:|:--------------------------------:|
| icmp    | ICMP Echo kullanır (-PE)         |
| tcp     | TCP SYN 80,443 probe (-PS80,443) |
| default | Nmap varsayılan discovery        |
| noping  | Ping bypass (-Pn, tek port)      |

### Speed (-s)

| Profil |           Açıklama          |
|:------:|:---------------------------:|
| slow   | Düşük gürültü, stabil       |
| normal | Dengeli hız (önerilen)      |
| fast   | Yüksek hız (lab ortamları)  |

### Output (-o)

|   Tip  |           Açıklama          |
|:------:|:---------------------------:|
| ip     | Sadece canlı IP listesi     |
| nmap   | Klasik nmap çıktısı         |
| grep   | Grepable output (.gnmap)    |

## Örnek Kullanımlar
### CIDR + TCP discovery + hızlı tarama
```bash
./host_discovery.sh -t <ip_cidr> -m tcp -s fast -o ip
```
### IP listesi dosyasından tarama
```bash
./host_discovery.sh -t targets.txt -m icmp -s normal -o ip,nmap
```
Ping Yasaklı Ortamlarda Tarama
```bash
./host_discovery.sh -t <ip_cidr> -m noping -s fast -o ip,grep
```
## Çıktı Yapısı
Sonuçlar otomatik olarak Desktop altında oluşturulur:
```
~/Desktop/host_discovery_YYYY-MM-DD_HH-MM-SS/
├── hosts.txt        # Sadece canlı IP listesi
├── result.nmap      # Standart nmap çıktısı
└── result.gnmap     # Grepable output
```

## Kullanım Akışı
1.Host discovery ile canlı IP’leri tespit et
2.hosts.txt dosyasını kullan
3.Port taramasına geç:
```bash
nmap -iL hosts.txt -sT --top-ports 100
```

## Güvenlik Notu
>Bu betik yalnızca keşif (discovery) amaçlıdır.
>Servis fingerprint almaz
>Exploit içermez
>Yetkisiz sistemlerde kullanımı kullanıcının sorumluluğundadır

## Future Works
>masscan entegrasyonu
>VPN interface otomatik algılama (tun0, wg0)
>JSON / CSV output
>Discovery → Port Scan pipeline
>IDS/IPS dostu random delay

## Lisans
Eğitim ve kişisel kullanım amaçlıdır.
Yetkisiz kullanım durumunda tüm sorumluluk kullanıcıya aittir.
