#!/bin/bash

# ������� ��� ����������� ������� ���� � ������� ��������
get_date() {
    date +'%d%m%Y'
}

# ������� ��� ��������� IP ������ ����� ��������-������
get_ip_info() {
    ip_info=$(curl -s ipinfo.io/"$1"/country)
    if [ -z "$ip_info" ]; then
        echo "Failed to get IP information"
        exit 1
    else
        echo "$ip_info"
    fi
}

get_ip_address() {
    ip=$(curl -s ifconfig.co)
    if [ -z "$ip" ]; then
        echo "Failed to get IP address"
        exit 1
    else
        ip_info=$(get_ip_info "$ip")
        echo "$ip_info $ip"
    fi
}

# ���� � �����, ������� ����� ������������
SOURCE_DIR="/opt/outline"

# �������� ������� ���� � ����������� �
DATE=$(get_date)

# ������� ��� ������
ARCHIVE_NAME="backup_$DATE.zip"

# ���������� ���������� �����
zip -r "$ARCHIVE_NAME" "$SOURCE_DIR"

# ���������� IP �����
IP=$(get_ip_address)

# ����� ������ ���� � Telegram
BOT_TOKEN="5024923420:AAE2fsGoqK-SPbk5TZgPNNADzZ1n9iMRUe8"

# ID ���� ��� ������, � ������� ����� ��������� �����
CHAT_ID="-1001874282744"

# URL-����� ��� �������� ��������� � Telegram
TELEGRAM_API_URL="https://api.telegram.org/bot$BOT_TOKEN/sendDocument"

# ����������� ��������� (caption) � UTF-8
CAPTION="IP address = $IP"

# ���������� ����� � Telegram ������ � ���������� �� IP ������ �����������
curl -X POST "$TELEGRAM_API_URL" \
     -F "chat_id=$CHAT_ID" \
     -F "document=@$ARCHIVE_NAME" \
     -F "caption=$CAPTION" \
     --header "Content-Type: multipart/form-data; charset=utf-8"

# ������� ��������� �����
rm "$ARCHIVE_NAME"
