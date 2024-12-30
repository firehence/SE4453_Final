# 1. Python 3.9 tabanlı hafif bir Linux image kullan
FROM python:3.9-slim

# 2. Çalışma dizinini ayarla
WORKDIR /app

# 3. Gerekli dosyaları image'e kopyala
COPY . /app

# 4. Sistemdeki bağımlılıkları güncelle ve yükle
RUN apt-get update
RUN apt-get install -y openssh-server
RUN apt-get clean

# 5. SSH için yapılandırmayı yap
RUN echo "root:Docker!" | chpasswd
RUN mkdir /var/run/sshd
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

# 6. Flask bağımlılıklarını yükle
RUN pip install --no-cache-dir -r requirements.txt

# 7. SSH ve Flask uygulamasını aynı anda çalıştırmak için bir giriş betiği oluştur
COPY init.sh /app/init.sh
RUN chmod +x /app/init.sh

# 8. İlgili portları expose et
EXPOSE 5000
EXPOSE 22

# 9. Başlatma komutunu ayarla
CMD ["/app/init.sh"]
